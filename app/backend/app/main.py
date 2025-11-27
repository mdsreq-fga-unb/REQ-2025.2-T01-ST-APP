from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
from app import models, dependencies
from app.seed_data import seed_database
from fastapi.middleware.cors import CORSMiddleware

from .routers import auth, home, forms, resultados, pesquisa_sociodemografica


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


@app.on_event("startup")
def startup_seed():
    print("=== EXECUTANDO SEED AUTOMÁTICO ===")
    seed_database()
    print("=== SEED CONCLUÍDO ===")


app.include_router(auth.router, prefix="/auth", tags=["Autenticação"])
app.include_router(home.router, prefix="/auth", tags=["Usuário Logado"])
app.include_router(forms.router, prefix="/api", tags=["Questinario"])
app.include_router(resultados.router, prefix="/api", tags=["Questinario"])
app.include_router(
    pesquisa_sociodemografica.router, prefix="/api", tags=["Questinario"]
)


@app.get("/")
def read_root():
    return {"message": "Bem-vindo à API GenT"}


@app.post("/seed")
def executar_seed():
    """
    Endpoint para executar o seed manualmente
    """
    try:
        seed_database()
        return {"message": "Seed executado com sucesso"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Erro no seed: {str(e)}")


@app.get("/perguntas")
def listar_perguntas(
    db: Session = Depends(dependencies.get_db),
    current_user: models.User = Depends(dependencies.get_current_user),
):
    print(
        f"DEBUG - Usuário logado: {current_user.email} | Empresa ID: {current_user.empresa_id}"
    )

    if not current_user.empresa_id:
        print("DEBUG - Usuário não tem empresa vinculada")
        raise HTTPException(
            status_code=404, detail="Usuário não tem empresa vinculada."
        )

    perguntas = (
        db.query(models.Perguntas)
        .filter(models.Perguntas.empresa_id == current_user.empresa_id)
        .all()
    )

    print(
        f"DEBUG - Encontradas {len(perguntas)} perguntas para a empresa {current_user.empresa_id}"
    )

    return perguntas
