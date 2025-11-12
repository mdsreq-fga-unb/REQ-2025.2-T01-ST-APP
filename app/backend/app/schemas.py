from pydantic import BaseModel
from .models import UserRole, VotoValor


class UserBase(BaseModel):

    email: str
    nome: str
    empresa: str
    cargo: str
    role: UserRole = UserRole.Colaborador


class UserCreate(UserBase):
    password: str


class User(UserBase):
    id: int
    is_active: bool

    class Config:
        from_attributes = True


class Token(BaseModel):
    access_token: str
    token_type: str


class TokenData(BaseModel):
    email: str | None = None


class Home(BaseModel):

    nome: str
    cargo: str | None = None

    class Config:
        from_attributes = True


class PerguntasBase(BaseModel):
    descricao: str


class Perguntas(PerguntasBase):

    id: int

    class Config:
        from_attributes = True


class VotoCreate(BaseModel):

    pergunta_id: int
    voto_valor: int


class ResultadoVoto(BaseModel):

    voto_valor: VotoValor
    total_votos: int

    class Config:

        from_attributes = True
