from conexao_db import get_connection

# ---------------------------
# Criação e população de base
# ---------------------------

def criar_tabelas():
    conn = get_connection()
    cur = conn.cursor()

    # usuários
    cur.execute("""
        CREATE TABLE IF NOT EXISTS usuarios (
            id SERIAL PRIMARY KEY,
            nome VARCHAR(100) NOT NULL,
            email VARCHAR(100) UNIQUE NOT NULL,
            senha VARCHAR(255) NOT NULL
        );
    """)

    # espécie (categoria) de pergunta
    cur.execute("""
        CREATE TABLE IF NOT EXISTS especie (
            id SERIAL PRIMARY KEY,
            nome VARCHAR(100) UNIQUE NOT NULL
        );
    """)

    # perguntas
    cur.execute("""
        CREATE TABLE IF NOT EXISTS perguntas (
            id SERIAL PRIMARY KEY,
            texto TEXT NOT NULL,
            id_especie INT REFERENCES especie(id) ON DELETE CASCADE,
            criterio_resposta VARCHAR(20) NOT NULL DEFAULT 'sim_positivo',
            CONSTRAINT perguntas_criterio_ck CHECK (criterio_resposta IN ('sim_positivo','nao_positivo')),
            CONSTRAINT uq_perguntas_texto_especie UNIQUE (texto, id_especie)
        );
    """)


    # respostas com restrição única para upsert
    cur.execute("""
        CREATE TABLE IF NOT EXISTS respostas (
            id SERIAL PRIMARY KEY,
            usuario_id INT REFERENCES usuarios(id) ON DELETE CASCADE,
            pergunta_id INT REFERENCES perguntas(id) ON DELETE CASCADE,
            resposta TEXT NOT NULL,
            CONSTRAINT uq_resposta UNIQUE (usuario_id, pergunta_id)
        );
    """)

    conn.commit()
    cur.close()
    conn.close()


def popular_especies_e_perguntas():
    especies = [
        "Condições de Trabalho",
        "Informática",
        "Práticas de gestão",
        "Tempo e Sobrecarga"
    ]

    perguntas = [
        ("O nível de iluminação é suficiente para executar as atividades", "Condições de Trabalho", "sim_positivo"),
        ("O espaço físico é satisfatório", "Condições de Trabalho", "sim_positivo"),
        ("O posto de trabalho é adequado para a realização das tarefas", "Condições de Trabalho", "sim_positivo"),
        ("Na RFB as condições de trabalho são satisfatórias", "Condições de Trabalho", "sim_positivo"),
        ("O mobiliário existente no local de trabalho é adequado", "Condições de Trabalho", "sim_positivo"),

        ("A conexão com a internet no meu posto de trabalho é eficiente", "Informática", "sim_positivo"),
        ("Os equipamentos de informática (estação de trabalho, impressora, servidores, etc) que uso funcionam sem apresentar defeitos", "Informática", "sim_positivo"),
        ("Os aplicativos que a RFB disponibiliza atendem minhas necessidades de comunicação no trabalho", "Informática", "sim_positivo"),
        ("O suporte técnico em informática na RFB é satisfatório", "Informática", "sim_positivo"),
        ("Os sistemas que uso no dia a dia estão sempre disponíveis", "Informática", "sim_positivo"),

        ("Na RFB disponho de tempo para executar o meu trabalho com zelo", "Práticas de gestão", "sim_positivo"),
        ("Posso executar o meu trabalho sem sobrecarga de tarefas", "Práticas de gestão", "sim_positivo"),
        ("Posso executar o meu trabalho sem pressão", "Práticas de gestão", "sim_positivo"),
        ("É fácil o acesso à chefia imediata", "Práticas de gestão", "sim_positivo"),
        ("A convivência no trabalho é harmoniosa", "Práticas de gestão", "sim_positivo"),
        ("Há confiança entre os colegas", "Práticas de gestão", "sim_positivo"),
        ("A distribuição das tarefas é justa", "Práticas de gestão", "sim_positivo"),
        ("A comunicação entre funcionários é insatisfatória", "Práticas de gestão", "nao_positivo"),
        ("A RFB me dá a possibilidade de ser criativo(a) no trabalho", "Práticas de gestão", "sim_positivo"),
        ("Na RFB as atividades que realizo são fonte de prazer", "Práticas de gestão", "sim_positivo"),
        ("Na RFB recebo incentivos de minha chefia", "Práticas de gestão", "sim_positivo"),
        ("Na RFB o resultado obtido com meu trabalho é reconhecido", "Práticas de gestão", "sim_positivo"),
        ("A sociedade reconhece a importância do meu trabalho", "Práticas de gestão", "sim_positivo"),
        ("A RFB oferece oportunidade de crescimento profissional", "Práticas de gestão", "sim_positivo"),
        ("Tenho liberdade de ação no cumprimento das tarefas", "Práticas de gestão", "sim_positivo"),
        ("A chefia imediata demonstra interesse pela minha opinião", "Práticas de gestão", "sim_positivo"),
        ("O modo de gestão das tarefas é flexível", "Práticas de gestão", "sim_positivo"),
        ("A cooperação entre as pessoas é estimulada", "Práticas de gestão", "sim_positivo"),
        ("Participo das decisões sobre a organização das tarefas", "Práticas de gestão", "sim_positivo"),
        ("O modo de gestão supervaloriza a obediência à hierarquia", "Práticas de gestão", "nao_positivo"),

        ("É comum o trabalho ultrapassar o horário de expediente", "Tempo e Sobrecarga", "nao_positivo"),
        ("O trabalho prejudica o uso do meu tempo livre fora do CENSIPAM", "Tempo e Sobrecarga", "nao_positivo"),
        ("O trabalho tem me levado ao esgotamento profissional", "Tempo e Sobrecarga", "nao_positivo"),
        ("Tenho me sentido cansado(a)", "Tempo e Sobrecarga", "nao_positivo"),
        ("Tenho trabalhado no limite de minha capacidade", "Tempo e Sobrecarga", "nao_positivo"),
        ("Na RFB existe forte cobrança por resultados", "Tempo e Sobrecarga", "nao_positivo"),
        ("Faltam horários de pausa para descanso no trabalho", "Tempo e Sobrecarga", "nao_positivo"),
    ]

    conn = get_connection()
    cur = conn.cursor()

    # Insere espécies (idempotente)
    for nome in especies:
        cur.execute("""
            INSERT INTO especie (nome) VALUES (%s)
            ON CONFLICT (nome) DO NOTHING;
        """, (nome,))
    conn.commit()

    # Mapa nome->id
    cur.execute("SELECT id, nome FROM especie;")
    especie_ids = {row["nome"]: row["id"] for row in cur.fetchall()}

    
    for texto, especie_nome, criterio in perguntas:
        cur.execute("""
            SELECT id FROM perguntas WHERE texto = %s AND id_especie = %s;
        """, (texto, especie_ids[especie_nome]))
        exists = cur.fetchone()
        if not exists:
            cur.execute("""
                INSERT INTO perguntas (texto, id_especie, criterio_resposta)
                VALUES (%s, %s, %s)
                ON CONFLICT DO NOTHING;
            """, (texto, especie_ids[especie_nome], criterio))


    conn.commit()
    cur.close()
    conn.close()

# ---------------------------
# Operações de negócio
# ---------------------------

def cadastrar_usuario(nome: str, email: str, senha: str):
    conn = get_connection()
    cur = conn.cursor()
    cur.execute("SELECT id FROM usuarios WHERE email = %s;", (email,))
    if cur.fetchone():
        cur.close()
        conn.close()
        return {"erro": "Já existe um usuário com esse e-mail."}

    cur.execute("""
        INSERT INTO usuarios (nome, email, senha)
        VALUES (%s, %s, %s)
        RETURNING id;
    """, (nome, email, senha))
    uid = cur.fetchone()["id"]
    conn.commit()
    cur.close()
    conn.close()
    return {"mensagem": "Usuário cadastrado com sucesso.", "usuario_id": uid}

def verificar_login(email: str, senha: str):
    conn = get_connection()
    cur = conn.cursor()
    cur.execute("""
        SELECT id, nome, senha FROM usuarios WHERE email = %s;
    """, (email,))
    row = cur.fetchone()
    cur.close()
    conn.close()

    if not row:
        return {"erro": "Não existe cadastro para este e-mail."}
    if row["senha"] != senha:
        return {"erro": "Senha incorreta."}

    return {"mensagem": "Login bem-sucedido.", "usuario_id": row["id"], "nome": row["nome"]}

def buscar_perguntas():
    conn = get_connection()
    cur = conn.cursor()
    cur.execute("""
        SELECT p.id, p.texto AS pergunta
        FROM perguntas p
        JOIN especie e ON e.id = p.id_especie
        ORDER BY e.nome, p.id;
    """)
    rows = cur.fetchall()
    cur.close()
    conn.close()
    # já vem como dicts (RealDictCursor). Campos: id, pergunta
    return rows

def salvar_respostas_bulk(usuario_id: int, respostas_map: dict):
    """
    respostas_map: { pergunta_id (int): "Sim"/"Não" }
    Faz UPSERT por (usuario_id, pergunta_id).
    """
    conn = get_connection()
    cur = conn.cursor()
    for pid_str, resp in respostas_map.items():
        pid = int(pid_str)
        cur.execute("""
            INSERT INTO respostas (usuario_id, pergunta_id, resposta)
            VALUES (%s, %s, %s)
            ON CONFLICT (usuario_id, pergunta_id)
            DO UPDATE SET resposta = EXCLUDED.resposta;
        """, (usuario_id, pid, resp))
    conn.commit()
    cur.close()
    conn.close()
    return {"mensagem": "Respostas salvas com sucesso."}

def gerar_dashboard():
    conn = get_connection()
    cur = conn.cursor()

    cur.execute("""
        SELECT 
            e.nome AS especie,
            p.criterio_resposta,
            r.resposta,
            COUNT(*) as total
        FROM respostas r
        JOIN perguntas p ON p.id = r.pergunta_id
        JOIN especie e ON e.id = p.id_especie
        GROUP BY e.nome, p.criterio_resposta, r.resposta
        ORDER BY e.nome;
    """)

    dados = cur.fetchall()
    cur.close()
    conn.close()

    # Processa em visão positiva/negativa
    resultado = {}
    for row in dados:
        especie = row["especie"]
        criterio = row["criterio_resposta"]
        resposta = row["resposta"].lower()
        total = row["total"]

        if especie not in resultado:
            resultado[especie] = {"positivo": 0, "negativo": 0}

        if criterio == "sim_positivo":
            if resposta == "sim":
                resultado[especie]["positivo"] += total
            else:
                resultado[especie]["negativo"] += total
        elif criterio == "nao_positivo":
            if resposta == "não":
                resultado[especie]["positivo"] += total
            else:
                resultado[especie]["negativo"] += total

    return resultado

