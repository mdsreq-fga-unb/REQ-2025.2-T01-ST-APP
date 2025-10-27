# REQ-2025.2-T02-ST-APP

![Python](https://img.shields.io/badge/Python-3.10+-blue.svg)
![FastAPI](https://img.shields.io/badge/FastAPI-informational.svg)
![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-14+-informational.svg)

Uma solução coleta de respostas de colaboradores e análise de resultados via dashboard, construída com FastAPI e Flutter.

---

## Índice

1.  [Sobre o Projeto](#1-sobre-o-projeto)
2.  [Arquitetura e Stack de Tecnologias](#2-arquitetura-e-stack-de-tecnologias)
3.  [Pré-requisitos de Ambiente](#3-pré-requisitos-de-ambiente)
4.  [Guia de Instalação e Configuração](#4-guia-de-instalação-e-configuração)
    * [A. Backend (Python + FastAPI)](#a-backend-python--fastapi)
    * [B. Frontend (Flutter + Dart)](#b-frontend-flutter--dart)
5.  [Como Executar a Aplicação](#5-como-executar-a-aplicação)

---

## 1. Sobre o Projeto

O **GenT** é uma aplicação cliente-servidor projetada para otimizar a coleta e análise de feedback interno em organizações. A solução é composta por:

* **API Backend**: Um servidor RESTful robusto que gerencia a lógica de negócios, autenticação de usuários e persistência de dados.
* **Aplicativo Frontend**: Um aplicativo móvel multiplatforma (iOS/Android) onde os colaboradores submetem suas respostas e visualizam dashboards.

## 2. Arquitetura e Stack de Tecnologias

O projeto adota uma arquitetura desacoplada, com o frontend (móvel) consumindo os dados da API backend.

| Componente | Tecnologia | Propósito |
| :--- | :--- | :--- |
| **Backend** | Python 3.10+, FastAPI | Servidor de API (lógica de negócios) |
| **Banco de Dados** | PostgreSQL 14+ | Persistência de dados relacionais |
| **ORM** | SQLAlchemy | Mapeamento Objeto-Relacional com o Python |
| **Migrações** | Alembic | Versionamento do *schema* do banco de dados |
| **Frontend** | Flutter 3.0+, Dart | Aplicação móvel para Android e iOS |

## 3. Pré-requisitos de Ambiente

Antes de começar, garanta que você tenha as seguintes ferramentas instaladas e configuradas em seu ambiente de desenvolvimento:

* [Python 3.10+](https://www.python.org/downloads/)
* [PostgreSQL 14+](https://www.postgresql.org/download/) (servidor deve estar em execução)
* [Flutter SDK 3.0+](https://flutter.dev/docs/get-started/install)
* [Postman](https://www.postman.com/) ou similar para testar a API.
* VSCode com plugins Dart/Flutter ou Android Studio

## 4. Guia de Instalação e Configuração

Siga os passos abaixo para configurar os dois lados do projeto.

Primeiro, clone o repositório:
```
git clone git@github.com:mdsreq-fga-unb/REQ-2025.2-T01-ST-APP.git
cd REQ-2025.2-T01-ST-APP
``` 
## A. Backend (Python + FastAPI)

Navegue até o diretório do backend (ex: `cd backend`).

### 1. Criar e Ativar Ambiente Virtual (venv)

```
# Criar o ambiente
python -m venv venv

# Ativar no Linux/Mac
source venv/bin/activate

# Ativar no Windows (PowerShell)
.\venv\Scripts\Activate.ps1
```
### 2. Instalar Dependências Python

Com o ambiente (venv) ativo, instale os pacotes do requirements.txt (que deve incluir fastapi, sqlalchemy, alembic, psycopg2-binary, etc.).

```
# Atualizar o pip 
pip install --upgrade pip

# Instalar todas as dependências
pip install -r requirements.txt
``` 

### 3. Configurar o Banco de Dados (PostgreSQL)


- Abra o psql

- Execute os seguintes comandos SQL:

```
-- 1. Crie o banco de dados
CREATE DATABASE db_flutter;

-- 2. Crie um usuário dedicado (substitua pela sua senha segura)
CREATE USER seu_usuario_postgres WITH PASSWORD 'sua_senha_postgres';

-- 3. Dê todas as permissões ao novo usuário no novo banco
GRANT ALL PRIVILEGES ON DATABASE db_flutter TO seu_usuario_postgres;
```
### 4. Configurar Variáveis de Ambiente (.env)

No diretório backend, copie o arquivo de exemplo:
```
# Linux/Mac
cp .env.example .env
# Windows
copy .env.example .env
``` 

Edite o arquivo .env com os dados reais do seu banco (criados no passo 3) e gere uma SECRET_KEY


### 5. Aplicar Migrações do Banco (Alembic)

O Alembic gerencia o esquema do banco de dados (criação e atualização de tabelas) com base nos seus models.py. Para aplicar todas as migrações e criar seu schema pela primeira vez, execute:
```
# Este comando aplica as migrações e cria todas as tabelas
alembic upgrade head
``` 

Esse comando lê a pasta alembic/ e aplica todas as alterações pendentes no banco de dados db_flutter

## B. Frontend (Flutter + Dart)

Navegue até o diretório do frontend (ex: cd ../frontend/frontend_st_app).

### 1. Instalar Dependências Dart/Flutter

Este comando lê o arquivo pubspec.yaml e baixa todos os pacotes necessários (http, provider, fl_chart, etc.).
```
flutter pub get
```

### 2. Gerar Código de Serialização (Build Runner)

Como o projeto usa json_serializable (definido no pubspec.yaml) para converter automaticamente JSON do FastAPI em objetos Dart, precisamos rodar o gerador de código.

```
# Executa o gerador de código uma vez
flutter pub run build_runner build
```

Dica: Use ```... watch``` ao invés de ```... build``` para que ele gere os arquivos automaticamente sempre que você salvar um "model".

### 3. Configurar URL da API (Importante!)

O aplicativo Flutter precisa saber onde o seu backend FastAPI está rodando.

1. Encontre o arquivo de configuração da API (ex: lib/services/api_service.dart).

2. Ajuste a URL base:

   - Se estiver usando um Emulador Android, o ``localhost`` da sua máquina é acessível pelo IP ``10.0.2.2``
   
        ``
         const String API_BASE_URL = "[http://10.0.2.2:8000](http://10.0.2.2:8000)";
        ``
    - Se estiver usando um Simulador iOS ou dispositivo físico na mesma rede Wi-Fi, use o IP da sua máquina na rede local (ex: ``192.168.1.10``).

## 5. Como Executar a Aplicação

Para desenvolver, você precisará de dois terminais abertos.

Terminal 1: Executar o Backend (FastAPI)
``` 
# Vá para a pasta /backend
# Certifique-se que o (venv) está ativo
uvicorn main:app --reload --host 0.0.0.0 --port 8000
``` 
`` --host 0.0.0.0`` é essencial para que o servidor seja acessível fora do localhost (pelo emulador).

Terminal 2: Executar o Frontend (Flutter)
``` 
# Vá para a pasta /frontend/frontend_st_app
# Certifique-se que um emulador está aberto ou um dispositivo conectado
flutter run
``` 


