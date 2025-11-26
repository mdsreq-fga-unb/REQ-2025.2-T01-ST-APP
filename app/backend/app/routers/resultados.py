from fastapi import APIRouter, Depends, HTTPException, Response
from sqlalchemy.orm import Session
from .. import models, schemas, crud, dependencies
import typing

from jinja2 import Environment, FileSystemLoader
from weasyprint import HTML

env = Environment(loader=FileSystemLoader("templates"))

router = APIRouter()


@router.get("/respostas/{tema_nome}", response_model=list[schemas.ResultadoVoto])
def get_resultados_por_tema(
    tema_nome: str,
    db: Session = Depends(dependencies.get_db),
    current_user: models.User = Depends(dependencies.get_current_user),
):

    resultados_contados = crud.get_resultados_agregados_por_tema(
        db, empresa_id=current_user.empresa_id, tema=tema_nome
    )

    resultados_finais = []

    for voto_valor_db, total_votos in resultados_contados:
        resultados_finais.append(
            schemas.ResultadoVoto(voto_valor=voto_valor_db, total_votos=total_votos)
        )

    return resultados_finais


@router.get("/relatorio-pdf/{tema_nome}")
def get_relatorio_pdf(
    tema_nome: str,
    db: Session = Depends(dependencies.get_db),
    current_user: models.User = Depends(dependencies.get_current_user),
):
   
  
    resultados_agregados_db = crud.get_resultados_agregados_por_tema(
        db, empresa_id=current_user.empresa_id, tema=tema_nome
    )

 
    total_votos_tema = sum(total for _, total in resultados_agregados_db)
    resultados_agregados_formatados = []

    for voto_valor, total in resultados_agregados_db:
        percent = (total / total_votos_tema) * 100 if total_votos_tema > 0 else 0

        resultados_agregados_formatados.append(
            {
                "voto_nome": voto_valor.name.replace("_", " ").title(),
                "total_votos": total,
                "porcentagem": percent,
            }
        )

    perguntas = crud.get_perguntas_por_tema(
        db, empresa_id=current_user.empresa_id, tema=tema_nome
    )

    perguntas_com_breakdown = []

    for pergunta in perguntas:

        
        resultados_pergunta_db = crud.get_resultados_votacao(
            db, pergunta_id=pergunta.id
        )

        total_votos_pergunta = sum(total for _, total in resultados_pergunta_db)
        resultados_formatados = []

        for voto_valor, total in resultados_pergunta_db:
            percent = (total / total_votos_pergunta) * 100 if total_votos_pergunta > 0 else 0

            resultados_formatados.append(
                {
                    "voto_nome": voto_valor.name.replace("_", " ").title(),
                    "total_votos": total,
                    "porcentagem": percent,
                }
            )

        perguntas_com_breakdown.append(
            {"descricao": pergunta.descricao, "resultados": resultados_formatados}
        )

    try:
        template = env.get_template("relatorio_template.html")
        html_string = template.render(
            tema_nome=tema_nome,
            resultados_agregados=resultados_agregados_formatados,
            total_votos_tema=total_votos_tema,
            perguntas_com_breakdown=perguntas_com_breakdown,
        )

    except Exception as e:
        print(f"Erro ao renderizar o template Jinja2: {e}")
        raise HTTPException(
            status_code=500, detail="Erro ao gerar o template do relatório."
        )

    try:
        pdf_bytes = HTML(string=html_string).write_pdf()

    except Exception as e:
        print(f"Erro ao converter HTML para PDF com WeasyPrint: {e}")
        raise HTTPException(
            status_code=500, detail="Erro ao gerar o arquivo PDF."
        )


    filename = f"relatorio_{tema_nome.lower().replace(' ', '_')}.pdf"

    return Response(
        content=pdf_bytes,
        media_type="application/pdf",
        headers={"Content-Disposition": f"attachment; filename={filename}"},
    )
