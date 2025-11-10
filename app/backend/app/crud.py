from sqlalchemy.orm import Session
from . import models, schemas, security


def get_user_email(db: Session, email: str) -> models.User | None:

    return db.query(models.User).filter(models.User.email == email).first()


def create_user(db: Session, user: schemas.UserCreate):

    hashed_password = security.get_password_hash(user.password)

    db_user = models.User(
        nome=user.nome,
        email=user.email,
        hashed_password=hashed_password,
        empresa=user.empresa,
        cargo=user.cargo,
        role=user.role,
    )

    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user
