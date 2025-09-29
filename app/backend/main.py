from fastapi import FastAPI, status
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from models import gerar_dashboard

from models import (
    criar_tabelas,
    popular_especies_e_perguntas,
    cadastrar_usuario,
    verificar_login,
    buscar_perguntas,
    salvar_respostas_bulk
)
from schemas import Usuario, LoginData, RespostasBulk

app = FastAPI(
    title="ST-APP API",
    version="1.0.0"
)

# CORS – para Flutter Web (Chrome)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],            # em produção, restrinja
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Inicializa DB e popula perguntas ao subir
criar_tabelas()
popular_especies_e_perguntas()

@app.post("/cadastro", status_code=status.HTTP_201_CREATED)
def cadastro(usuario: Usuario):
    resultado = cadastrar_usuario(usuario.nome, usuario.email, usuario.senha)
    if "erro" in resultado:
        return JSONResponse(content=resultado, status_code=status.HTTP_400_BAD_REQUEST)
    return resultado

@app.post("/login")
def login(dados: LoginData):
    resultado = verificar_login(dados.email, dados.senha)
    if "erro" in resultado:
        return JSONResponse(content=resultado, status_code=status.HTTP_400_BAD_REQUEST)
    return resultado

@app.get("/perguntas")
def listar_perguntas():
    # retorna array simples, ex:
    # [ {"id": 1, "pergunta": "..."}, ... ]
    return buscar_perguntas()

@app.post("/respostas")
def salvar_respostas(dados: RespostasBulk):
    resultado = salvar_respostas_bulk(
        usuario_id=dados.usuario_id,
        respostas_map=dados.respostas
    )
    return resultado

@app.get("/dashboard")
def dashboard():
    return gerar_dashboard()