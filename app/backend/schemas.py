from pydantic import BaseModel
from typing import Dict

class Usuario(BaseModel):
    nome: str
    email: str
    senha: str

class LoginData(BaseModel):
    email: str
    senha: str

class RespostasBulk(BaseModel):
    usuario_id: int
    respostas: Dict[str, str]  # pergunta_id -> "Sim"/"Não"
