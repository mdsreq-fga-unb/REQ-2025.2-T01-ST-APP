from .database import SessionLocal, engine
from . import models
import logging

# Configura um logging básico para ver o que está acontecendo
logging.basicConfig(level=logging.INFO)

# Lista estática de perguntas (como você forneceu)
perguntas_data = [
    # (Descricao, Tema)
    (
        "O nível de iluminação é suficiente para executar as atividades",
        "Condições de Trabalho",
    ),
    ("O espaço físico é satisfatório", "Condições de Trabalho"),
    (
        "O posto de trabalho é adequado para a realização das tarefas",
        "Condições de Trabalho",
    ),
    ("Na RFB as condições de trabalho são satisfatórias", "Condições de Trabalho"),
    ("O mobiliário existente no local de trabalho é adequado", "Condições de Trabalho"),
    ("A conexão com a internet no meu posto de trabalho é eficiente", "Informática"),
    (
        "Os equipamentos de informática (estação de trabalho, impressora, servidores, etc) que uso funcionam sem apresentar defeitos",
        "Informática",
    ),
    (
        "Os aplicativos que a RFB disponibiliza atendem minhas necessidades de comunicação no trabalho",
        "Informática",
    ),
    (
        "Na RFB disponho de tempo para executar o meu trabalho com zelo",
        "Práticas de gestão",
    ),
    ("Posso executar o meu trabalho sem sobrecarga de tarefas", "Práticas de gestão"),
    ("Faltam horários de pausa para descanso no trabalho", "Tempo e Sobrecarga"),
    ("Posso executar o meu trabalho sem pressão", "Práticas de gestão"),
    ("Na RFB existe forte cobrança por resultados", "Tempo e Sobrecarga"),
    ("É fácil o acesso à chefia imediata", "Práticas de gestão"),
    ("A convivência no trabalho é harmoniosa", "Práticas de gestão"),
    ("Há confiança entre os colegas", "Práticas de gestão"),
    ("A distribuição das tarefas é justa", "Práticas de gestão"),
    ("A comunicação entre funcionários é insatisfatória", "Práticas de gestão"),
    (
        "A RFB me dá a possibilidade de ser criativo(a) no trabalho",
        "Práticas de gestão",
    ),
    ("Na RFB as atividades que realizo são fonte de prazer", "Práticas de gestão"),
    ("Na RFB recebo incentivos de minha chefia", "Práticas de gestão"),
    ("Na RFB o resultado obtido com meu trabalho é reconhecido", "Práticas de gestão"),
    ("A sociedade reconhece a importância do meu trabalho", "Práticas de gestão"),
    ("A RFB oferece oportunidade de crescimento profissional", "Práticas de gestão"),
    ("O suporte técnico em informática na RFB é satisfatório", "Informática"),
    ("Os sistemas que uso no dia a dia estão sempre disponíveis", "Informática"),
    ("Tenho liberdade de ação no cumprimento das tarefas", "Práticas de gestão"),
    ("A chefia imediata demonstra interesse pela minha opinião", "Práticas de gestão"),
    ("O modo de gestão das tarefas é flexível", "Práticas de gestão"),
    ("A cooperação entre as pessoas é estimulada", "Práticas de gestão"),
    ("Participo das decisões sobre a organização das tarefas", "Práticas de gestão"),
    ("O modo de gestão supervaloriza a obediência à hierarquia", "Práticas de gestão"),
    ("É comum o trabalho ultrapassar o horário de expediente", "Tempo e Sobrecarga"),
    (
        "O trabalho prejudica o uso do meu tempo livre fora do CENSIPAM",
        "Tempo e Sobrecarga",
    ),
    ("O trabalho tem me levado ao esgotamento profissional", "Tempo e Sobrecarga"),
    ("Tenho me sentido cansado(a)", "Tempo e Sobrecarga"),
    ("Tenho trabalhado no limite de minha capacidade", "Tempo e Sobrecarga"),
]


def seed_database():
    """
    Garante que todas as empresas cadastradas tenham o conjunto
    básico de perguntas.
    """

    # Inicia a sessão com o banco
    db = SessionLocal()

    try:
        # 1. Busca todas as empresas do banco de dados
        todas_as_empresas = db.query(models.Empresa).all()

        if not todas_as_empresas:
            logging.warning("Nenhuma empresa encontrada no banco.")
            logging.warning("Cadastre uma empresa antes de rodar o seed.")
            return

        logging.info(
            f"Encontradas {len(todas_as_empresas)} empresas. Verificando perguntas..."
        )

        perguntas_adicionadas = 0

        # 2. Itera sobre cada empresa encontrada
        for empresa in todas_as_empresas:

            # 3. Verifica se esta empresa JÁ tem perguntas
            count = (
                db.query(models.Perguntas)
                .filter(models.Perguntas.empresa_id == empresa.id)
                .count()
            )

            if count > 0:
                logging.info(
                    f"Empresa '{empresa.nome}' (ID: {empresa.id}) já possui {count} perguntas. Pulando."
                )
                continue

            # 4. Se a empresa não tem perguntas, adiciona o conjunto padrão
            logging.info(
                f"Adicionando {len(perguntas_data)} perguntas para a empresa '{empresa.nome}' (ID: {empresa.id})..."
            )

            for texto_pergunta, tema_pergunta in perguntas_data:
                pergunta = models.Perguntas(
                    descricao=texto_pergunta,
                    tema=tema_pergunta,
                    empresa_id=empresa.id,  # Linka com a empresa do loop
                )
                db.add(pergunta)
                perguntas_adicionadas += 1

        # 5. Commita todas as adições de uma vez
        if perguntas_adicionadas > 0:
            db.commit()
            logging.info(
                f"Sucesso! {perguntas_adicionadas} novas perguntas foram adicionadas."
            )
        else:
            logging.info(
                "O banco de dados já estava atualizado. Nenhuma pergunta foi adicionada."
            )

    except Exception as e:
        logging.error(f"Ocorreu um erro durante o seed: {e}")
        db.rollback()  # Desfaz as mudanças em caso de erro
    finally:
        db.close()  # Sempre fecha a conexão


if __name__ == "__main__":
    logging.info("Iniciando script de povoamento (seed) das perguntas...")
    # Garante que as tabelas existem (embora Alembic seja o ideal)
    models.Base.metadata.create_all(bind=engine)
    seed_database()
