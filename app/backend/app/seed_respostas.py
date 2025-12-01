import random
from datetime import datetime, timedelta
from sqlalchemy.orm import Session
from .database import SessionLocal
from . import models, schemas

# Configuração
EMPRESA_ID = 6  # ID da empresa que você está usando
NUM_USUARIOS = 10 # Quantos usuários falsos criar

def create_fake_data():
    db = SessionLocal()
    print("--- Iniciando Geração de Dados Falsos ---")

    try:
        # 1. Verifica se existem perguntas
        perguntas = db.query(models.Perguntas).filter(
            models.Perguntas.empresa_id == EMPRESA_ID
        ).all()

        if not perguntas:
            print("ERRO: Nenhuma pergunta encontrada. Rode o seed_perguntas_global.py primeiro.")
            return

        print(f"Encontradas {len(perguntas)} perguntas. Criando votos...")

        # 2. Loop para criar Usuários Fictícios
        for i in range(1, NUM_USUARIOS + 1):
            email = f"user_teste_{i}@empresa.com"
            
            # Verifica se usuário já existe
            user = db.query(models.User).filter(models.User.email == email).first()
            
            if not user:
                user = models.User(
                    nome=f"Colaborador Teste {i}",
                    email=email,
                    hashed_password="hash_generico", # Não serve para login real, só para constar
                    cargo="Analista",
                    role=models.UserRole.Colaborador,
                    empresa_id=EMPRESA_ID,
                    is_active=True
                )
                db.add(user)
                db.commit()
                db.refresh(user)
                print(f"Criado usuário: {email}")
            
            # 3. Gerar Votos para este usuário
            votos_criados = 0
            
            for pergunta in perguntas:
                # Verifica se já votou
                voto_existente = db.query(models.Respostas).filter(
                    models.Respostas.user_id == user.id,
                    models.Respostas.pergunta_id == pergunta.id
                ).first()

                if not voto_existente:
                    # --- A MÁGICA DA DATA ---
                    # Gera uma data aleatória nos últimos 90 dias
                    dias_atras = random.randint(0, 90)
                    data_aleatoria = datetime.now() - timedelta(days=dias_atras)
                    
                    # Gera um voto aleatório (1 a 5)
                    # Vamos enviesar um pouco para 4 e 5 para ficar bonito no gráfico
                    valor_voto = random.choices([1, 2, 3, 4, 5], weights=[5, 10, 15, 40, 30])[0]

                    novo_voto = models.Respostas(
                        user_id=user.id,
                        pergunta_id=pergunta.id,
                        voto_valor=valor_voto,
                        data_resposta=data_aleatoria # <--- Salvando data antiga
                    )
                    db.add(novo_voto)
                    votos_criados += 1
            
            # Commita os votos desse usuário
            db.commit()
            print(f"User {i}: Gerou {votos_criados} votos.")

        print("--- Sucesso! Dados gerados. ---")

    except Exception as e:
        print(f"Erro: {e}")
        db.rollback()
    finally:
        db.close()

if __name__ == "__main__":
    create_fake_data()