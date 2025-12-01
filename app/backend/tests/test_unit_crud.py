from app import crud, models, schemas

def test_crud_votar_ou_trocar(session):
    # Setup
    user = models.User(nome="Teste", email="t@t.com", role="Colaborador", empresa_id=1, cargo="X", hashed_password="x")
    session.add(user)
    pergunta = models.Perguntas(descricao="P1", tema="T1", empresa_id=1)
    session.add(pergunta)
    session.commit()

    # 1. Voto Novo
    voto_schema = schemas.VotoCreate(pergunta_id=pergunta.id, voto_valor=5)
    crud.votar_ou_trocar_voto(session, user_id=user.id, dados_voto=voto_schema)
    
    voto_db = session.query(models.Respostas).first()
    assert voto_db.voto_valor == 5

    # 2. Troca de Voto
    voto_update = schemas.VotoCreate(pergunta_id=pergunta.id, voto_valor=3)
    crud.votar_ou_trocar_voto(session, user_id=user.id, dados_voto=voto_update)

    # Verifica contagem e valor
    assert session.query(models.Respostas).count() == 1 # Não criou duplicata
    voto_atualizado = session.query(models.Respostas).first()
    assert voto_atualizado.voto_valor == 3 # Valor mudou
