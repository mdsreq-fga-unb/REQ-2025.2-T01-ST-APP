from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware  
from .routers import users, auth

app = FastAPI(
    title="GenT API",
    description="API para coleta e análise de feedback interno.",
    version="0.1.0"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], 
    allow_credentials=True,
    allow_methods=["*"],    
    allow_headers=["*"], 
)




app.include_router(auth.router, prefix="/auth", tags=["Usuários"])

@app.get("/")
def read_root():
    return {"message": "Bem-vindo à API GenT"}
