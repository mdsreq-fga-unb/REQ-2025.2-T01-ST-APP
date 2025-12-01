from sqlalchemy import func
from sqlalchemy.orm import Session
from . import models, schemas, security
from .models import UserRole 
from datetime import date
import os



def get_user_email(db: Session, email: str) -> models.User | None:

    return db.query(models.User).filter(models.User.email == email).first()


def get_empresa_nome(db: Session, nome: str) -> models.Empresa | None:

    return db.query(models.Empresa).filter(models.Empresa.nome == nome).first()


def create_empresa(db: Session, nome: str) -> models.Empresa:

    db_empresa = models.Empresa(nome=nome)
    db.add(db_empresa)
    db.commit()
    db.refresh(db_empresa)

    if os.getenv("TESTING") != "True":
        from .seed_data import seed_database
        try:
            seed_database()
        except Exception as e:
            print(f"Aviso: Seed automático falhou (esperado se banco vazio): {e}")

    return db_empresa


def get_or_create_empresa(db: Session, nome: str) -> models.Empresa:

    db_empresa = get_empresa_nome(db, nome=nome)

    if db_empresa:
        return db_empresa

    return create_empresa(db, nome=nome)


def create_user(db: Session, user: schemas.UserCreate, empresa_id: int):
    hashed_password = security.get_password_hash(user.password)

    try:
        role_enum = UserRole(user.role) if isinstance(user.role, str) else user.role
    except ValueError:
        role_enum = UserRole.Colaborador

    db_user = models.User(
        nome=user.nome,
        email=user.email,
        hashed_password=hashed_password,
        empresa_id=empresa_id,
        cargo=user.cargo,
        role=role_enum,
    )

    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user


def votar_ou_trocar_voto(
    db: Session, user_id: int, dados_voto: schemas.VotoCreate
) -> models.Respostas:

    print(
        f"DEBUG - votar_ou_trocar_voto: user_id={user_id}, pergunta_id={dados_voto.pergunta_id}, voto_valor={dados_voto.voto_valor}"
    )

    voto_existente = (
        db.query(models.Respostas)
        .filter(
            models.Respostas.user_id == user_id,
            models.Respostas.pergunta_id == dados_voto.pergunta_id,
        )
        .first()
    )

    if voto_existente:
        print(f"DEBUG - Voto existente encontrado, atualizando...")
        voto_existente.voto_valor = dados_voto.voto_valor
        db.commit()
        db.refresh(voto_existente)
        return voto_existente
    else:
        print(f"DEBUG - Criando novo voto...")
        novo_voto = models.Respostas(
            user_id=user_id,
            pergunta_id=dados_voto.pergunta_id,
            voto_valor=dados_voto.voto_valor,
        )
        db.add(novo_voto)
        db.commit()
        db.refresh(novo_voto)
        return novo_voto


def get_perguntas_por_tema(
    db: Session, empresa_id: int, tema: str
) -> list[models.Perguntas]:

    return (
        db.query(models.Perguntas)
        .filter(
            models.Perguntas.empresa_id == empresa_id, models.Perguntas.tema == tema
        )
        .all()
    )


def get_resultados_votacao(
    db: Session, 
    pergunta_id: int,
    data_inicio: date | None = None, 
    data_fim: date | None = None
) -> list[tuple[models.VotoValor, int]]:
    
    query = db.query(
            models.Respostas.voto_valor,
            func.count(models.Respostas.id).label("total_votos")
        ).filter(
            models.Respostas.pergunta_id == pergunta_id
        )

    if data_inicio:
        
        query = query.filter(func.date(models.Respostas.data_resposta) >= data_inicio)
    
    if data_fim:

        query = query.filter(func.date(models.Respostas.data_resposta) <= data_fim)
    

    resultados_db = query.group_by(models.Respostas.voto_valor).all()

    return [(models.VotoValor(row[0]), row[1]) for row in resultados_db]


def get_resultados_agregados_por_tema(
    db: Session, 
    empresa_id: int, 
    tema: str,
    data_inicio: date | None = None,
    data_fim: date | None = None
) -> list[tuple[models.VotoValor, int]]:
    
    query = db.query(
        models.Respostas.voto_valor,
        func.count(models.Respostas.id).label("total_votos")
    ).join(
        models.Perguntas, 
        models.Respostas.pergunta_id == models.Perguntas.id
    ).filter(
        models.Perguntas.tema == tema,
        models.Perguntas.empresa_id == empresa_id 
    )

    
    if data_inicio:
        query = query.filter(func.date(models.Respostas.data_resposta) >= data_inicio)
    
    if data_fim:
        query = query.filter(func.date(models.Respostas.data_resposta) <= data_fim)
        
    resultados_db = query.group_by(models.Respostas.voto_valor).all()

    return [(models.VotoValor(row[0]), row[1]) for row in resultados_db]

def create_pesquisa(
    db: Session, pesquisa: schemas.PesquisaSociodemograficaCreate, usuario_id: int
) -> models.PesquisaSociodemografica:

    db_pesquisa = models.PesquisaSociodemografica(
        usuario_id=usuario_id, **pesquisa.model_dump()
    )

    db.add(db_pesquisa)
    db.commit()
    db.refresh(db_pesquisa)

    return db_pesquisa


def get_pesquisa_by_user_id(
    db: Session, usuario_id: int
) -> models.PesquisaSociodemografica | None:

    return (
        db.query(models.PesquisaSociodemografica)
        .filter(models.PesquisaSociodemografica.usuario_id == usuario_id)
        .first()
    )


def update_pesquisa(
    db: Session,
    usuario_id: int,
    pesquisa_update: schemas.PesquisaSociodemograficaCreate,
) -> models.PesquisaSociodemografica | None:

    db_pesquisa = get_pesquisa_by_user_id(db, usuario_id)

    if not db_pesquisa:
        return None

    update_data = pesquisa_update.model_dump(exclude_unset=True)

    for key, value in update_data.items():
        setattr(db_pesquisa, key, value)

    db.add(db_pesquisa)
    db.commit()
    db.refresh(db_pesquisa)

    return db_pesquisa


def delete_pesquisa(db: Session, usuario_id: int) -> bool:

    db_pesquisa = get_pesquisa_by_user_id(db, usuario_id)

    if not db_pesquisa:
        return False

    db.delete(db_pesquisa)
    db.commit()

    return True
