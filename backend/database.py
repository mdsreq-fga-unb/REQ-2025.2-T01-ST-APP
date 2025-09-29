from conexao_db import get_connection

def init_db():
    conexao = get_connection()
    cursor = conexao.cursor()

    # Tabela de usuários
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS usuarios (
            id SERIAL PRIMARY KEY,
            nome VARCHAR(100) NOT NULL,
            email VARCHAR(100) UNIQUE NOT NULL,
            senha VARCHAR(255) NOT NULL
        );
        ALTER TABLE usuarios ADD COLUMN tipo VARCHAR(20) NOT NULL DEFAULT 'contribuidor';
    """)

    # Nova tabela de espécies
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS especie (
            id SERIAL PRIMARY KEY,
            nome VARCHAR(100) UNIQUE NOT NULL
        );
    """)

    # Atualizando perguntas para ter chave estrangeira para espécie
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS perguntas (
            id SERIAL PRIMARY KEY,
            texto TEXT NOT NULL,
            id_especie INT REFERENCES especie(id) ON DELETE CASCADE
        );
        ALTER TABLE perguntas ADD COLUMN criterio_resposta VARCHAR(15) NOT NULL DEFAULT 'sim_positivo';
    """)

    # Respostas
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS respostas (
            id SERIAL PRIMARY KEY,
            usuario_id INT REFERENCES usuarios(id) ON DELETE CASCADE,
            pergunta_id INT REFERENCES perguntas(id) ON DELETE CASCADE,
            resposta TEXT NOT NULL
        );
    """)

    conexao.commit()
    cursor.close()
    conexao.close()
