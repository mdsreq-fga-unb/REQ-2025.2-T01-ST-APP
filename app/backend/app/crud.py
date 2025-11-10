import re
from sqlalchemy.orm import Session
from . import models, schemas, security


def get_user_email(db: Session, email: str) -> models.User | None:

    return db.query(models.User).filter(models.User.email == email).first()


def get_empresa_nome(db: Session, nome: str) -> models.Empresa | None:

    return db.query(models.Empresa).filter(models.Empresa.nome == nome).first()


def create_empresa(db: Session, nome: str) -> models.Empresa:

    db_empresa = models.Empresa(nome = nome)
    db.add(db_empresa)
    db.commit()
    db.refresh(db_empresa)

    return db_empresa


def get_or_create_empresa(db: Session, nome: str) -> models.Empresa:

    db_empresa = get_empresa_nome(db, nome=nome)

    if(db_empresa):
        return db_empresa

    return create_empresa(db, nome=nome)

    
def create_user(db: Session, user: schemas.UserCreate, empresa_id: int):

    hashed_password = security.get_password_hash(user.password)

    db_user = models.User(
        nome = user.nome,
        email = user.email,
        hashed_password = hashed_password,
        empresa_id = empresa_id,
        cargo = user.cargo,
        role = user.role 
    )

    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user
