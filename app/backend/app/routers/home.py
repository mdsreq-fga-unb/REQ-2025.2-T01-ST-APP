from fastapi import APIRouter, Depends
from app import schemas, dependencies, models

router = APIRouter()


@router.get("/home", response_model=schemas.Home)
def home_gestor(user: models.User = Depends(dependencies.get_current_user)):

    return user
