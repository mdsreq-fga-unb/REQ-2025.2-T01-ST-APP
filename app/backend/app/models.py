import enum
from operator import index
from sqlalchemy import (
    Column,
    Integer,
    String,
    Boolean,
    ForeignKey,
    Enum as SQLAlchemyEnum,
    union,
)
from sqlalchemy.orm import relationship
from .database import Base


class UserRole(str, enum.Enum):

    Colaborador = "Colaborador"
    Gestor = "Gestor"


class Empresa(Base):

    __tablename__ = "empresas"

    id = Column(Integer, primary_key=True, index=True)

    nome = Column(String, unique=True, index=True)

    usuarios = relationship("User", back_populates="empresa")

    perguntas = relationship("Perguntas", back_populates="empresa")


class User(Base):

    __tablename__ = "usuarios"

    id = Column(Integer, primary_key=True, index=True)
    nome = Column(String, index=True)
    email = Column(String, unique=True, index=True)
    hashed_password = Column(String)
    cargo = Column(String)
    is_active = Column(Boolean, default=True)

    role = Column(
        SQLAlchemyEnum(UserRole), nullable=False, default=UserRole.Colaborador
    )

    empresa_id = Column(Integer, ForeignKey("empresas.id"))

    empresa = relationship("Empresa", back_populates="usuarios")


class Perguntas(Base):

    __tablename__ = "perguntas"
    id = Column(Integer, primary_key=True, index=True)
    descricao = Column(String)

    opcoes = relationship("Respostas", back_populates="pergunta")

    empresa_id = Column(Integer, ForeignKey("empresas.id"))

    empresa = relationship("Empresa", back_populates="perguntas")


class Respostas(Base):

    __tablename__ = "respostas"
    id = Column(Integer, primary_key=True, index=True)

    descricao = Column(String, nullable=False)

    pergunta_id = Column(Integer, ForeignKey("perguntas.id"))

    votos = Column(Integer, default=0, nullable=False)

    pergunta = relationship("Perguntas", back_populates="opcoes")
