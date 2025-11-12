# app/routers/auth.py
from datetime import timedelta
from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordRequestForm
from sqlalchemy.orm import Session
from app import crud, schemas, security, dependencies, models
from app.config import settings

router = APIRouter()


@router.post("/token", response_model=schemas.Token)
def login_for_access_token(
    db: Session = Depends(dependencies.get_db),
    form_data: OAuth2PasswordRequestForm = Depends(),
):

    user = crud.get_user_email(db, email=form_data.username)

    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Email ou senha incorretos",
            headers={"WWW-Authenticate": "Bearer"},
        )
    if not security.verify_password(form_data.password, user.hashed_password):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Email ou senha incorretos",
            headers={"WWW-Authenticate": "Bearer"},
        )

    access_token_expires = timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)

    access_token = security.create_access_token(
        data={"sub": user.email}, expires_delta=access_token_expires
    )

    return {"access_token": access_token, "token_type": "bearer"}


@router.post("/users")
def create_user(user: schemas.UserCreate, db: Session = Depends(dependencies.get_db)):

    db_user = crud.get_user_email(db, email=user.email)

    if db_user:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST, detail="Email ja registrado"
        )

    empresa_nome = getattr(user, "empresa", None)
    if empresa_nome:
        db_empresa = crud.get_or_create_empresa(db, nome=empresa_nome)
        empresa_id = db_empresa.id
    else:
        empresa_id = None

    return crud.create_user(db=db, user=user, empresa_id=empresa_id)
