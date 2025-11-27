from fastapi import Depends, APIRouter, HTTPException
from app import schemas, dependencies, models, crud
from sqlalchemy.orm import Session
from sqlalchemy import func

router = APIRouter()


@router.post("/responder")
def votar_trocar_voto(
    dados_voto: schemas.VotoCreate,
    user: models.User = Depends(dependencies.get_current_user),
    db: Session = Depends(dependencies.get_db),
):
    print(f"DEBUG - Recebendo voto do usuário {user.id}")
    print(
        f"DEBUG - Dados do voto: pergunta_id={dados_voto.pergunta_id}, voto_valor={dados_voto.voto_valor}"
    )

    try:
        resultado = crud.votar_ou_trocar_voto(
            db=db, user_id=user.id, dados_voto=dados_voto
        )
        print(f"DEBUG - Voto salvo com sucesso: {resultado}")
        return {"status": "Voto computado com sucesso!"}
    except Exception as e:
        print(f"DEBUG - Erro ao salvar voto: {e}")
        raise HTTPException(status_code=500, detail=f"Erro ao processar voto: {str(e)}")


@router.get("/minhas-respostas")
def get_minhas_respostas(
    db: Session = Depends(dependencies.get_db),
    current_user: models.User = Depends(dependencies.get_current_user),
):
    respostas = (
        db.query(models.Respostas)
        .filter(models.Respostas.user_id == current_user.id)
        .all()
    )

    resultado = []
    for resposta in respostas:
        resultado.append(
            {
                "pergunta_id": resposta.pergunta_id,
                "voto_valor": resposta.voto_valor,
                "pergunta_descricao": (
                    resposta.pergunta.descricao if resposta.pergunta else "N/A"
                ),
            }
        )

    return {
        "usuario_id": current_user.id,
        "total_respostas": len(respostas),
        "respostas": resultado,
    }
