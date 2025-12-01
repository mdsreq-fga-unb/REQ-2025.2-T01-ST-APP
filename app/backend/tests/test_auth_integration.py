def test_criar_usuario_sucesso(client):
    response = client.post(
        "/auth/users",
        json={
            "nome": "Teste User",
            "email": "teste@exemplo.com",
            "password": "123",
            "role": "Colaborador",
            "empresa": "Empresa Teste",
            "cargo": "Dev"
        },
    )
    assert response.status_code == 200
    data = response.json()
    assert data["email"] == "teste@exemplo.com"
    assert "id" in data

def test_criar_usuario_email_duplicado(client):
    # Cria o primeiro
    client.post(
        "/auth/users",
        json={"nome": "A", "email": "duplo@teste.com", "password": "123", "role": "Gestor", "empresa": "A", "cargo": "A"}
    )
    # Tenta criar o segundo igual
    response = client.post(
        "/auth/users",
        json={"nome": "B", "email": "duplo@teste.com", "password": "123", "role": "Gestor", "empresa": "A", "cargo": "B"}
    )
    assert response.status_code == 400
    assert response.json()["detail"] == "Email ja registrado"

def test_login_e_token(client):
    # 1. Cadastrar
    client.post(
        "/auth/users",
        json={"nome": "Login", "email": "login@teste.com", "password": "123", "role": "Gestor", "empresa": "A", "cargo": "A"}
    )
    
    # 2. Login (Form Data)
    response = client.post(
        "/auth/token",
        data={"username": "login@teste.com", "password": "123"}
    )
    
    assert response.status_code == 200
    token_data = response.json()
    assert "access_token" in token_data
    assert token_data["token_type"] == "bearer"