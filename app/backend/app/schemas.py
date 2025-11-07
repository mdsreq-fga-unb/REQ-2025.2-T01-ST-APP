from pydantic import BaseModel, EmailStr
from typing import Dict
from .models import UserRole

class UserBase(BaseModel):
    
    email: str
    nome: str
    role: UserRole = UserRole.Colaborador 


class UserCreate(UserBase):
    password:str

    
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

    
