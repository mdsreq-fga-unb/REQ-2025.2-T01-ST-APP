from .database import SessionLocal, engine
from . import models
import logging

logging.basicConfig(level=logging.INFO)

perguntas_data = [
    # (Descricao, Tema)
    ("A luminosidade do ambiente é adequada para as tarefas que tenho que executar.", "Ambiente de trabalho"),
    ("O espaço físico disponível no local atende às minhas demandas do trabalho.", "Ambiente de trabalho"),
    ("Meu posto de trabalho é apropriado para cumprir minhas funções.", "Ambiente de trabalho"),
    ("A mobília que utilizo é adequada às atividades que realizo.", "Ambiente de trabalho"),
    ("Os equipamentos de informática que utilizo atendem às minhas necessidades.", "Ambiente de trabalho"),
    ("Os sistemas e softwares que utilizo são apropriados para minhas funções.", "Ambiente de trabalho"),
    ("Os materiais disponíveis permitem realizar minhas funções de forma adequada.","Ambiente de trabalho"),
    ("As condições de trabalho atendem às minhas necessidades.", "Ambiente de trabalho"),
    ("As relações no meu trabalho são harmoniosas.", "Ambiente de trabalho"),
    ("Os colegas confiam uns nos outros.", "Ambiente de trabalho"),
    ("Minha supervisão direta se interessa em resolver as demandas apresentadas.", "Ambiente de trabalho"),
    ("A comunicação com a minha supervisão direta é eficiente.", "Ambiente de trabalho"),
    ("Recebo suporte frequente do meu supervisor imediato.", "Ambiente de trabalho"),


    ("As tarefas que recebo estão claramente definidas.", "Rotina e organização do trabalho"),
    ("Recebo instruções precisas sobre como realizar minhas atividades.", "Rotina e organização do trabalho"),
    ("Tenho liberdade para organizar meu trabalho da forma que considero melhor.", "Rotina e organização do trabalho"),
    ("O ritmo das atividades é adequado.", "Rotina e organização do trabalho"),
    ("Os prazos permitem que eu execute minhas tarefas sem pressa.", "Rotina e organização do trabalho"),
    ("Há justiça na distribuição das tarefas.","Rotina e organização do trabalho"),
    ("A equipe é suficiente para dar conta da demanda de trabalho.", "Rotina e organização do trabalho"),
    ("Os trabalhadores têm participação nas decisões relacionadas ao trabalho.", "Rotina e organização do trabalho"),
    ("Sinto-me sobrecarregado pelo trabalho.", "Rotina e organização do trabalho"),
    ("Minhas tarefas se acumulam devido à distribuição inadequada do trabalho.", "Rotina e organização do trabalho"),



    ("A competência e habilidade dos colaboradores são reconhecidas.", "Bem-estar e reconhecimento"),
    ("A inovação e novas ideias são valorizadas.", "Bem-estar e reconhecimento"),
    ("Meu trabalho é reconhecido e valorizado pela gestão.", "Bem-estar e reconhecimento"),
    ("A gestão incentiva os profissionais a buscar novos desafios.", "Bem-estar e reconhecimento"),
    ("Existem oportunidades de crescimento iguais para todas as pessoas.", "Bem-estar e reconhecimento"),
    ("A organização oferece boas oportunidades de desenvolvimento para mim.", "Bem-estar e reconhecimento"),
    ("A organização oferece boas oportunidades de desenvolvimento para a equipe.", "Bem-estar e reconhecimento"),
    ("Meu trabalho me deixa exausto.", "Bem-estar e reconhecimento"),
    ("Tenho problemas com minha saúde mental por causa do meu trabalho.", "Bem-estar e reconhecimento"),
    ("Tenho problemas com minha saúde física por causa do meu trabalho.", "Bem-estar e reconhecimento"),
    ("Há violência psicológica no ambiente de trabalho.", "Bem-estar e reconhecimento"),
    ("Há discriminação de gênero no ambiente de trabalho.", "Bem-estar e reconhecimento"),
    ("Há discriminação étnica/racial no ambiente de trabalho.", "Bem-estar e reconhecimento"),
    ("Tenho sido exposto a ameaças de violência no trabalho.", "Bem-estar e reconhecimento"),
    ("Há violência física no ambiente de trabalho.", "Bem-estar e reconhecimento"),


    ("Meu trabalho tem significado para mim.", "Significado do trabalho e vida pessoal"),
    ("Sinto que minhas atividades profissionais são importantes.", "Significado do trabalho e vida pessoal"),
    ("Há oportunidade de pausas regulares para descanso.", "Significado do trabalho e vida pessoal"),
    ("Minhas relações pessoais são prejudicadas pelo trabalho.", "Significado do trabalho e vida pessoal"),
    ("Experimento conflitos familiares relacionados ao trabalho.", "Significado do trabalho e vida pessoal"),
    ("Meu trabalho exige tanta energia que prejudica minha vida pessoal.", "Significado do trabalho e vida pessoal"),
]


def seed_database():
   
    db = SessionLocal()
    try:
        todas_as_empresas = db.query(models.Empresa).all()

        if not todas_as_empresas:
            logging.warning("Nenhuma empresa encontrada no banco.")
            return

        logging.info(
            f"Encontradas {len(todas_as_empresas)} empresas. Verificando perguntas..."
        )

        for emp in todas_as_empresas:
            logging.info(f" - Empresa: {emp.nome} (ID: {emp.id})")

        perguntas_adicionadas = 0
        empresas_processadas = 0

        for empresa in todas_as_empresas:
            empresas_processadas += 1

            count = (
                db.query(models.Perguntas)
                .filter(models.Perguntas.empresa_id == empresa.id)
                .count()
            )

            if count >= len(perguntas_data):
                logging.info(
                    f"Empresa '{empresa.nome}' (ID: {empresa.id}) já possui {count} perguntas. Pulando."
                )
                continue

            if count > 0:
                logging.info(
                    f"Empresa '{empresa.nome}' (ID: {empresa.id}) tem apenas {count} de {len(perguntas_data)} perguntas. Adicionando as restantes."
                )
            else:
                logging.info(
                    f"Adicionando {len(perguntas_data)} perguntas para a empresa '{empresa.nome}' (ID: {empresa.id})..."
                )

            perguntas_existentes = (
                db.query(models.Perguntas.descricao)
                .filter(models.Perguntas.empresa_id == empresa.id)
                .all()
            )
            descricoes_existentes = {p[0] for p in perguntas_existentes}

            for texto_pergunta, tema_pergunta in perguntas_data:
                if texto_pergunta not in descricoes_existentes:
                    pergunta = models.Perguntas(
                        descricao=texto_pergunta,
                        tema=tema_pergunta,
                        empresa_id=empresa.id,
                    )
                    db.add(pergunta)
                    perguntas_adicionadas += 1

        if perguntas_adicionadas > 0:
            db.commit()
            logging.info(
                f"✅ Sucesso! {perguntas_adicionadas} novas perguntas foram adicionadas para {empresas_processadas} empresas."
            )
        else:
            logging.info(
                "📊 Banco já estava atualizado. Nenhuma pergunta foi adicionada."
            )

    except Exception as e:
        logging.error(f"❌ Erro durante o seed: {e}")
        db.rollback()
        raise
    finally:
        db.close()


if __name__ == "__main__":
    logging.info("Iniciando script de povoamento (seed) das perguntas...")
    models.Base.metadata.create_all(bind=engine)
    seed_database()
