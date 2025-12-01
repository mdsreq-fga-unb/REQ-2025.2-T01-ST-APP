from app import models

def test_geracao_pdf_sucesso(client, session, criar_token_jwt):
    # Setup básico
    empresa = models.Empresa(nome="Empresa PDF")
    session.add(empresa)
    session.commit()
    pergunta = models.Perguntas(descricao="P PDF", tema="Relatorios", empresa_id=empresa.id)
    session.add(pergunta)
    session.commit()
    
    headers = criar_token_jwt(email="pdf@teste.com", empresa="Empresa PDF")

    # Chama o endpoint
    response = client.get("/api/relatorio-pdf/Relatorios", headers=headers)

    # Verificações
    assert response.status_code == 200
    assert response.headers["content-type"] == "application/pdf"
    assert "attachment; filename=" in response.headers["content-disposition"]
    assert len(response.content) > 0 # Garante que o arquivo não está vazio