from fastapi import APIRouter, Depends, HTTPException
from database import get_db
from schemas import PesquisaSociodemograficaCreate
from dependencies import get_current_user

router = APIRouter(prefix="/pesquisa", tags=["Pesquisa Sociodemográfica"])

@router.post("/salvar")
def salvar_pesquisa(
    data: PesquisaSociodemograficaCreate,
    db = Depends(get_db),
    current_user = Depends(get_current_user)
):
    query = """
        INSERT INTO pesquisa_sociodemografica (
            usuario_id, idade, genero, raca, estado_civil,
            possui_filhos, quantidade_filhos,
            tempo_empresa_meses, tempo_cargo_meses,
            escolaridade
        )
        VALUES (
            %(usuario_id)s, %(idade)s, %(genero)s, %(raca)s, %(estado_civil)s,
            %(possui_filhos)s, %(quantidade_filhos)s,
            %(tempo_empresa_meses)s, %(tempo_cargo_meses)s,
            %(escolaridade)s
        )
        RETURNING id;
    """

    values = data.model_dump()
    values["usuario_id"] = current_user.id  

    cursor = db.cursor()
    cursor.execute(query, values)
    result = cursor.fetchone()
    db.commit()

    return {"id": result[0], "message": "Pesquisa salva com sucesso!"}
