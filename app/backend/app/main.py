from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
from app import models, dependencies
from fastapi.middleware.cors import CORSMiddleware
from .routers import auth, home, forms, resultados

app = FastAPI(
    title="GenT API",
    description="API para coleta e análise de feedback interno.",
    version="0.1.0",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


app.include_router(auth.router, prefix="/auth", tags=["Autenticação"])
app.include_router(home.router, prefix="/auth", tags=["Usuário Logado"])
app.include_router(forms.router, prefix="/api", tags=["Questinario"])
app.include_router(resultados.router, prefix="/api", tags=["Questinario"])


@app.get("/")
def read_root():
    return {"message": "Bem-vindo à API GenT"}

@app.get("/perguntas")
def listar_perguntas(
    db: Session = Depends(dependencies.get_db),
    # MUDANÇA AQUI: Usamos dependencies.get_current_user
    current_user: models.User = Depends(dependencies.get_current_user) 
):
    print(f"Usuário logado: {current_user.email} | Empresa ID: {current_user.empresa_id}")

    if not current_user.empresa_id:
        raise HTTPException(status_code=404, detail="Usuário não tem empresa vinculada.")

    # Busca perguntas filtrando pela empresa
    perguntas = db.query(models.Perguntas).filter(
        models.Perguntas.empresa_id == current_user.empresa_id
    ).all()

    return perguntas