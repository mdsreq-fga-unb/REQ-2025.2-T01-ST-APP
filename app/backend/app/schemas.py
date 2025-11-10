<<<<<<< HEAD
from pydantic import BaseModel
from .models import UserRole


class UserBase(BaseModel):

    email: str
    nome: str
    role: UserRole = UserRole.Colaborador
    empresa: str
    cargo: str


class UserCreate(UserBase):
    password: str


=======
from pydantic import BaseModel, EmailStr
from typing import Dict
from .models import UserRole

class UserBase(BaseModel):
    
    email: str
    nome: str
    role: UserRole = UserRole.Colaborador 


class UserCreate(UserBase):
    password:str

    
>>>>>>> 1db8677 (adiciona cadastro de usuarios)
class User(UserBase):
    id: int
    is_active: bool

    class Config:
        from_attributes = True

<<<<<<< HEAD

=======
>>>>>>> 1db8677 (adiciona cadastro de usuarios)
class Token(BaseModel):
    access_token: str
    token_type: str


class TokenData(BaseModel):
    email: str | None = None
<<<<<<< HEAD
=======


class Home(BaseModel):

    nome: str
    cargo: str | None = None

    class Config:
        from_attributes = True


    

    
>>>>>>> 1db8677 (adiciona cadastro de usuarios)
