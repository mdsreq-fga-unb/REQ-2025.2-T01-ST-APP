
def test_criar_pesquisa_sucesso(client, session, criar_token_jwt):
    # 1. Autentica
    headers = criar_token_jwt(email="demog@teste.com")
    
    # 2. Envia pesquisa válida
    payload = {
        "idade": 30,
        "genero": "Homem", # Verifique seus Enums exatos
        "raca": "Branco",
        "estado_civil": "Solteiro",
        "possui_filhos": False,
        "quantidade_filhos": 0,
        "tempo_empresa_meses": 12,
        "tempo_cargo_meses": 6,
        "escolaridade": "Superior_completo"
    }
    
    response = client.post("/api/pesquisa/salvar", json=payload, headers=headers)
    assert response.status_code == 200
    assert response.json()["idade"] == 30

def test_bloqueio_duplicidade_pesquisa(client, session, criar_token_jwt):
    # 1. Autentica
    headers = criar_token_jwt(email="dupla@teste.com")
    
    payload = {
        "idade": 25,
        "genero": "Mulher",
        "raca": "Pardo",
        "estado_civil": "Casado",
        "possui_filhos": True,
        "quantidade_filhos": 2,
        "tempo_empresa_meses": 24,
        "tempo_cargo_meses": 24,
        "escolaridade": "Mestrado"
    }
    
    # 2. Envia a primeira vez (Sucesso)
    client.post("/api/pesquisa/salvar", json=payload, headers=headers)
    
    # 3. Tenta enviar de novo (Deve falhar)
    response = client.post("/api/pesquisa/salvar", json=payload, headers=headers)
    
    assert response.status_code == 409 # Conflict
    assert response.json()["detail"] == "Usuário já respondeu à pesquisa."

def test_validacao_enum_invalido(client, session, criar_token_jwt):
    
    headers = criar_token_jwt(email="enum@teste.com")
    
    payload = {
        "idade": 30,
        "genero": "ALIENIGENA", # Valor inválido
        "raca": "Branco",
        "estado_civil": "Solteiro",
        "possui_filhos": False,
        "tempo_empresa_meses": 10,
        "tempo_cargo_meses": 10,
        "escolaridade": "Superior_completo"
    }
    
    response = client.post("/api/pesquisa/salvar", json=payload, headers=headers)
    assert response.status_code == 422 # Unprocessable Entity (Erro de validação)