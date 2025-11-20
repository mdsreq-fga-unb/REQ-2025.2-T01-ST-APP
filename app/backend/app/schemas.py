from pydantic import BaseModel, ConfigDict
from typing import Optional
from .models import UserRole, VotoValor


class EmpresaRead(BaseModel):
    id: int
    nome: str

    class Config:
        from_attributes = True


class UserBase(BaseModel):
    nome: str
    email: str
    cargo: Optional[str] = None
    role: UserRole = UserRole.Colaborador

    model_config = ConfigDict(from_attributes=True)


class UserCreate(BaseModel):
    nome: str
    email: str
    password: str
    empresa: str        
    cargo: Optional[str] = None
    role: UserRole = UserRole.Colaborador


class UserRead(UserBase):
    id: int
    is_active: bool
    empresa: EmpresaRead      

    model_config = ConfigDict(from_attributes=True)


class User(UserBase):
    id: int
    is_active: bool
    empresa_id: int

    model_config = ConfigDict(from_attributes=True)


class Token(BaseModel):
    access_token: str
    token_type: str


class TokenData(BaseModel):
    email: str | None = None


class Home(BaseModel):
    nome: str
    cargo: Optional[str] = None

    model_config = ConfigDict(from_attributes=True)


class PerguntasBase(BaseModel):
    descricao: str


class Perguntas(PerguntasBase):
    id: int

    model_config = ConfigDict(from_attributes=True)


class VotoCreate(BaseModel):
    pergunta_id: int
    voto_valor: int


class ResultadoVoto(BaseModel):
    voto_valor: VotoValor
    total_votos: int

    model_config = ConfigDict(from_attributes=True)
    
class PesquisaSociodemograficaCreate(BaseModel):
    usuario_id: int
    idade: int
    genero: str
    raca: str
    estadoCivil: str
    possuiFilhos: bool
    quantidadeFilhos: Optional[int]
    tempoEmpresaMeses: int
    tempoCargoMeses: int
    escolaridade: str
