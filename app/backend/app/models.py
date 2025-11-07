import enum
from sqlalchemy import (
    Column,
    Integer,
    String,
    Boolean,
    ForeignKey,
    Enum as SQLAlchemyEnum,
)
from .database import Base


class UserRole(str, enum.Enum):

    Colaborador = "Colaborador"
    Gestor = "Gestor"

class User(Base):
    __tablename__ = "usuarios"

    id = Column(Integer, primary_key=True, index=True)
    nome = Column(String, index=True)
    email = Column(String, unique=True, index=True)
    hashed_password = Column(String)
    empresa = Column(String)
    cargo = Column(String)
    is_active = Column(Boolean, default=True)

    role = Column(
        SQLAlchemyEnum(UserRole), nullable=False, default=UserRole.Colaborador
    )
