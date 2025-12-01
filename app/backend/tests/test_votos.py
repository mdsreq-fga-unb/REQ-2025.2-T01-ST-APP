from app import models



def test_fluxo_votacao_e_resultados(client, session, criar_token_jwt):
    # --- SETUP: Criar Pergunta no Banco (Manual, pois não temos endpoint de criar pergunta) ---
    # Precisamos criar a empresa primeiro para pegar o ID correto
    empresa = session.query(models.Empresa).filter(models.Empresa.nome == "Empresa Tech").first()
    
    if not empresa:
        empresa = models.Empresa(nome="Empresa Tech")
        session.add(empresa)
        session.commit()
        session.refresh(empresa)

    pergunta = models.Perguntas(descricao="Gosta de Python?", tema="Tecnologia", empresa_id=empresa.id)
    session.add(pergunta)
    session.commit()
    session.refresh(pergunta)
    
    headers = criar_token_jwt(email="dev@tech.com", empresa="Empresa Tech")

    # --- TESTE 1: Votar pela primeira vez ---
    response = client.post(
        "/api/responder",
        json={"pergunta_id": pergunta.id, "voto_valor": 5},
        headers=headers
    )
    assert response.status_code == 200
    assert response.json()["status"] == "Voto computado com sucesso!"

    # Verifica no banco (via endpoint de resultado)
    res = client.get(f"/api/respostas/Tecnologia", headers=headers)
    dados = res.json()
    assert len(dados) == 1
    assert dados[0]["voto_valor"] == 5
    assert dados[0]["total_votos"] == 1

    # --- TESTE 2: Trocar o voto (Mesmo usuário, mesma pergunta) ---
    response = client.post(
        "/api/responder",
        json={"pergunta_id": pergunta.id, "voto_valor": 1}, # Mudou de 5 para 1
        headers=headers
    )
    assert response.status_code == 200

    # Verifica se ATUALIZOU em vez de CRIAR NOVO
    res = client.get(f"/api/respostas/Tecnologia", headers=headers)
    dados = res.json()
    
    assert len(dados) == 1          # Ainda deve ter apenas 1 registro de agrupamento
    assert dados[0]["voto_valor"] == 1  # O valor deve ser 1 agora
    assert dados[0]["total_votos"] == 1 # O total de votos continua 1 (1 usuário)

def test_isolamento_entre_empresas(client, session, criar_token_jwt):
    """Garante que usuário da Empresa A não vê/vota em perguntas da Empresa B"""
    
    # Setup: Empresa A e Pergunta A
    empresa_a = models.Empresa(nome="Empresa A")
    session.add(empresa_a)
    session.commit()
    session.refresh(empresa_a)
    
    pergunta_a = models.Perguntas(descricao="Pergunta A", tema="TemaA", empresa_id=empresa_a.id)
    session.add(pergunta_a)
    session.commit()
    session.refresh(pergunta_a)

    # Usuário da Empresa B
    headers_b = criar_token_jwt(email="user@b.com", empresa="Empresa B")

    # Tenta votar na pergunta da Empresa A
    # (Dependendo da sua lógica, isso pode dar 200 mas não computar, ou 404/403. 
    # O ideal seria dar erro, mas vamos checar se o resultado aparece para ele)
    
    client.post(
        "/api/responder",
        json={"pergunta_id": pergunta_a.id, "voto_valor": 5},
        headers=headers_b
    )

    # O usuário B tenta ver resultados do TemaA. Deve vir vazio, pois ele é da Empresa B
    res = client.get("/api/respostas/TemaA", headers=headers_b)
    assert res.json() == []