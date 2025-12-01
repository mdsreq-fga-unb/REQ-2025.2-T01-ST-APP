from fastapi import APIRouter, Depends, HTTPException, status

from sqlalchemy.orm import Session

from .. import models, schemas, dependencies, crud

router = APIRouter(prefix="/pesquisa", tags=["Pesquisa Sociodemográfica"])


@router.post("/salvar", response_model=schemas.PesquisaSociodemograficaResponse)
def salvar_pesquisa(
    pesquisa_data: schemas.PesquisaSociodemograficaCreate,
    db: Session = Depends(dependencies.get_db),
    current_user: models.User = Depends(dependencies.get_current_user),
):

    if crud.get_pesquisa_by_user_id(db, usuario_id=current_user.id):
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="Usuário já respondeu à pesquisa.",
        )

    return crud.create_pesquisa(
        db=db, pesquisa=pesquisa_data, usuario_id=current_user.id
    )


@router.get("/leitura", response_model=schemas.PesquisaSociodemograficaResponse)
def ler_minha_pesquisa(
    db: Session = Depends(dependencies.get_db),
    current_user: models.User = Depends(dependencies.get_current_user),
):
    pesquisa = crud.get_pesquisa_by_user_id(db, usuario_id=current_user.id)

    if not pesquisa:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Pesquisa não encontrada."
        )

    return pesquisa
