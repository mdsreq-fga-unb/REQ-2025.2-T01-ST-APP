def test_criar_usuario(client):
    response = client.post(
        "/auth/users",
        json={
            "nome": "Teste User",
            "email": "teste@exemplo.com",
            "password": "123",
            "role": "Gestor",
            "empresa": "Empresa Teste",
            "cargo": "Dev"
        },
    )
    assert response.status_code == 200
    data = response.json()
    assert data["email"] == "teste@exemplo.com"
    assert "id" in data

def test_login_sucesso(client):
    # 1. Primeiro cria o usuário (setup)
    client.post(
        "/auth/users",
        json={
            "nome": "Login User",
            "email": "login@exemplo.com",
            "password": "123",
            "role": "Colaborador",
            "empresa": "Empresa X",
            "cargo": "Analista"
        },
    )

    # 2. Tenta fazer login
    response = client.post(
        "/auth/token",
        data={"username": "login@exemplo.com", "password": "123"}, # Form-data
    )
    
    assert response.status_code == 200
    assert "access_token" in response.json()