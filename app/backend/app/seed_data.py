from database import SessionLocal, engine
from app import models

models.Base.metadata.create_all(bind=engine)

db = SessionLocal()

# Espécies
especies_data = [
    "Condições de Trabalho",
    "Informática",
    "Práticas de gestão",
    "Tempo e Sobrecarga",
]

especies = {}
for nome in especies_data:
    especie = models.Especie(nome=nome)
    db.add(especie)
    db.commit()
    db.refresh(especie)
    especies[nome] = especie.id

# Perguntas
perguntas_data = [
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

for texto, especie_nome in perguntas_data:
    pergunta = models.Pergunta(texto=texto, id_especie=especies[especie_nome])
    db.add(pergunta)

db.commit()
db.close()

print("Banco de dados populado com sucesso!")
