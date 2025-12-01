import pytest
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.pool import StaticPool

# Importe os objetos da sua aplicação real
from app.database import Base
from app import models
from app.main import app
from app.dependencies import get_db

# 1. Configura um banco de dados SQLite em memória
# "check_same_thread": False é necessário para o SQLite trabalhar com o FastAPI (que é async)
# StaticPool mantém a conexão aberta para que o banco em memória não suma entre requisições
SQLALCHEMY_DATABASE_URL = "sqlite:///:memory:"

engine = create_engine(
    SQLALCHEMY_DATABASE_URL,
    connect_args={"check_same_thread": False},
    poolclass=StaticPool,
)

# Cria uma fábrica de sessões específica para os testes
TestingSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine, expire_on_commit=False)

@pytest.fixture(name="session")
def session_fixture():
    """
    Esta fixture cria uma nova sessão de banco de dados para cada teste.
    Ela cria as tabelas antes do teste e as apaga depois.
    """
    # Cria todas as tabelas no banco em memória
    Base.metadata.create_all(bind=engine)
    
    db = TestingSessionLocal()
    try:
        yield db
    finally:
        db.close()
        # Limpa o banco (drop tables) após cada teste para garantir isolamento
        Base.metadata.drop_all(bind=engine)

@pytest.fixture(name="client")
def client_fixture(session):
    """
    Esta fixture cria o TestClient (o navegador simulado).
    O segredo aqui é o 'dependency_overrides': ele força o FastAPI
    a usar a nossa sessão de teste (fixture anterior) em vez da conexão real.
    """
    def override_get_db():
        try:
            yield session
        finally:
            session.close()

    # Substitui a dependência real pela de teste
    app.dependency_overrides[get_db] = override_get_db
    
    yield TestClient(app)
    
    # Limpa a substituição depois do teste
    app.dependency_overrides.clear()
    
@pytest.fixture
def criar_token_jwt(client):
    """
    Fixture que retorna uma FUNÇÃO para criar usuários e gerar tokens.
    Isso permite criar tokens para diferentes usuários/empresas nos testes.
    """
    def _get_auth_headers(email="user@teste.com", empresa="Empresa X"):
        # 1. Cria usuário
        client.post(
            "/auth/users",
            json={
                "nome": "User Teste",
                "email": email,
                "password": "123",
                "role": "Colaborador",
                "empresa": empresa,
                "cargo": "Dev"
            },
        )
        # 2. Login
        response = client.post(
            "/auth/token",
            data={"username": email, "password": "123"}
        )
        # Se o login falhar, o teste que chamou vai falhar aqui
        assert response.status_code == 200 
        
        token = response.json()["access_token"]
        return {"Authorization": f"Bearer {token}"}

    return _get_auth_headers