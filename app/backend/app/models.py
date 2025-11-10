import enum
from operator import index
from sqlalchemy import (
    Column,
    Integer,
    String,
    Boolean,
    ForeignKey,
    Enum as SQLAlchemyEnum,
    UniqueConstraint,
)
from sqlalchemy.orm import MapperEvents, relationship, Mapped, mapped_column
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

    id: Mapped[int] = mapped_column(primary_key=True, index=True)
    nome: Mapped[str] = mapped_column(String, index=True)
    email: Mapped[str] = mapped_column(String, unique=True, index=True)
    hashed_password: Mapped[str] = mapped_column(String)

    cargo: Mapped[str | None] = mapped_column(String, nullable=True)

    is_active: Mapped[bool] = mapped_column(Boolean, default=True)

    role: Mapped[UserRole] = mapped_column(
        SQLAlchemyEnum(UserRole), nullable=False, default=UserRole.Colaborador
    )

    empresa_id: Mapped[int] = mapped_column(ForeignKey("empresas.id"))

    empresa: Mapped["Empresa"] = relationship(back_populates="usuarios")

    respostas_dadas: Mapped[list["Respostas"]] = relationship(back_populates="autor")


class Perguntas(Base):
    __tablename__ = "perguntas"
    id = Column(Integer, primary_key=True, index=True)
    descricao = Column(String)
    tema = Column(String)
    empresa_id = Column(Integer, ForeignKey("empresas.id"))
    empresa = relationship("Empresa", back_populates="perguntas")

    respostas_dos_usuarios = relationship("Respostas", back_populates="pergunta")


class VotoValor(int, enum.Enum):
    CONCORDO_TOTALMENTE = 5
    CONCORDO_PARCIALMENTE = 4
    NEM_CONCORDO_NEM_DISCORDO = 3
    DISCORDO_PARCIALMENTE = 2
    DISCORDO_TOTALMENTE = 1


class Respostas(Base):
    __tablename__ = "respostas_do_usuario"

    id = Column(Integer, primary_key=True, index=True)

    user_id = Column(Integer, ForeignKey("usuarios.id"))
    pergunta_id = Column(Integer, ForeignKey("perguntas.id"))
    autor = relationship("User", back_populates="respostas_dadas")
    pergunta = relationship("Perguntas", back_populates="respostas_dos_usuarios")
    voto_valor = Column(Integer, nullable=False)

    __table_args__ = (
        UniqueConstraint("user_id", "pergunta_id", name="_user_pergunta_uc"),
    )
