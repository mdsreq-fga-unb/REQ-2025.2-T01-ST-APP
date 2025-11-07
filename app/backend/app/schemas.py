from pydantic import BaseModel, ConfigDict 
from typing import Optional
from .models import UserRole, VotoValor


class EmpresaRead(BaseModel):
    id: int
    nome: str
    
    class Config:
        from_attributes = True
        
class UserBase(BaseModel):
    email: str
    nome: str
    empresa: str
    cargo: str
    role: UserRole = UserRole.Colaborador
    cargo: Optional[str] = None


class UserCreate(UserBase):
    password: str
    empresa: str


class UserRead(UserBase):
    id: int
    is_active: bool
    empresa: EmpresaRead
    
    model_config = ConfigDict(from_attributes=True)
    
    
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
