from pydantic import BaseModel
from typing import Optional
from .models import UserRole


class UserBase(BaseModel):
    email: str
    nome: str
    role: UserRole = UserRole.Colaborador
    empresa: Optional[str] = None
    cargo: Optional[str] = None


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
