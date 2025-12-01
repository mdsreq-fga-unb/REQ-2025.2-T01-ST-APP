from datetime import datetime, timedelta
from app import models

def test_filtro_datas_dashboard(client, session, criar_token_jwt):
    # --- SETUP ---
    empresa = models.Empresa(nome="Empresa Data")
    session.add(empresa)
    session.commit()
    
    pergunta = models.Perguntas(descricao="P1", tema="Tempo", empresa_id=empresa.id)
    session.add(pergunta)
    session.commit()
    
    # User 1 (Para o voto de HOJE)
    headers = criar_token_jwt(email="data@teste.com", empresa="Empresa Data")
    user1 = session.query(models.User).filter(models.User.email == "data@teste.com").first()

    # User 2 (Para o voto ANTIGO) - Necessário para não violar Unique Constraint
    user2 = models.User(
        nome="User Antigo", 
        email="antigo@teste.com", 
        role="Colaborador", 
        empresa_id=empresa.id,
        hashed_password="x"
    )
    session.add(user2)
    session.commit()

    # --- INSERÇÃO MANUAL ---
    
    # Voto 1: Hoje (User 1)
    voto_hoje = models.Respostas(
        user_id=user1.id, 
        pergunta_id=pergunta.id, 
        voto_valor=5, 
        data_resposta=datetime.now()
    )
    session.add(voto_hoje)
    
    # Voto 2: 60 dias atrás (User 2)
    data_antiga = datetime.now() - timedelta(days=60)
    voto_antigo = models.Respostas(
        user_id=user2.id, # <--- MUDANÇA: Usa o user2
        pergunta_id=pergunta.id, 
        voto_valor=1, 
        data_resposta=data_antiga
    )
    session.add(voto_antigo)
    
    session.commit()

    # --- TESTES ---
    
    # 1. Sem filtro: Deve trazer 2 votos
    res = client.get("/api/respostas/Tempo", headers=headers)
    assert res.status_code == 200
    dados = res.json()
    total_votos = sum(item['total_votos'] for item in dados)
    assert total_votos == 2

    # 2. Filtro "Últimos 30 dias": Deve trazer só 1 voto (Hoje)
    data_inicio = (datetime.now() - timedelta(days=30)).strftime("%Y-%m-%d")
    res = client.get(f"/api/respostas/Tempo?data_inicio={data_inicio}", headers=headers)
    dados = res.json()
    total_votos = sum(item['total_votos'] for item in dados)
    assert total_votos == 1
    assert dados[0]['voto_valor'] == 5

    # 3. Filtro "Mês Passado": Deve trazer só 1 voto (Antigo)
    data_fim = (datetime.now() - timedelta(days=40)).strftime("%Y-%m-%d")
    res = client.get(f"/api/respostas/Tempo?data_fim={data_fim}", headers=headers)
    dados = res.json()
    total_votos = sum(item['total_votos'] for item in dados)
    assert total_votos == 1
    assert dados[0]['voto_valor'] == 1