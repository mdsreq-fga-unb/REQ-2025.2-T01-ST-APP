from fastapi import Depends, APIRouter
from app import schemas, dependencies, models, crud
from sqlalchemy.orm import Session
from sqlalchemy import func

router = APIRouter()


@router.post("/responder")
def votar_trocar_voto(
    dados_voto: schemas.VotoCreate,
    user: models.User = Depends(dependencies.get_current_user),
    db: Session = Depends(dependencies.get_db),
):
    
    crud.votar_ou_trocar_voto(db=db, user_id=user.id, dados_voto=dados_voto)

    return {"status": "Voto computado com sucesso!"}
