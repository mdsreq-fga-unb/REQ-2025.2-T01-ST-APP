from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from .. import models, schemas, crud, dependencies
import typing


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
