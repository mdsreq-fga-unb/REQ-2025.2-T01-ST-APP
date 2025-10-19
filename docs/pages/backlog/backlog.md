# Backlog do Produto

## Backlog Geral

O backlog do produto é o artefato principal que consolida, de forma priorizada, todos os requisitos e demandas para a evolução de um sistema. Ele funciona como uma fonte única de verdade para a equipe, detalhando as funcionalidades, otimizações e correções a serem implementadas. Este backlog é um instrumento vivo, continuamente refinado para se adaptar às mudanças de escopo e aos novos insights que surgem ao longo do ciclo de vida do produto, mantendo a equipe sincronizada com os objetivos do projeto.

A maneira como os requisitos são documentados e detalhados é inspirada em metodologias ágeis. Em geral, os requisitos funcionais são aprofundados em etapas de planejamento, quando são convertidos em histórias de usuário, utilizando um formato padrão que descreve o agente, a ação desejada e o valor gerado por essa ação.

No núcleo do backlog estão as Histórias de Usuário, que traduzem as necessidades dos usuários em descrições simples e focadas em valor. Cada história é construída para responder a três questões essenciais: quem se beneficia, qual ação necessita realizar e qual o propósito dessa ação. Essa abordagem garante que o foco permaneça na perspectiva do usuário final.

### 9.1 Backlog Geral

O backlog geral contém todas as funcionalidades planejadas para o software, organizadas em Épicos e detalhadas como Histórias de Usuário (User Stories) para garantir uma visão clara do que será desenvolvido ao longo do projeto.

#### ÉPICO 1: Engajamento e Coleta de Percepções do Colaborador
*Foco na experiência do colaborador, garantindo um canal seguro e prático para feedback.*

| ID | História de Usuário (User Story) | Critérios de Aceitação |
| :--- | :--- | :--- |
| **US01** | Como um colaborador, quero responder a um questionário simples com perguntas de "sim" ou "não", para que eu possa compartilhar minha percepção de forma rápida e anônima. (RF01) | - O questionário deve ser acessível via aplicativo móvel.<br>- As respostas devem ser enviadas sem identificação pessoal.<br>- O tempo de resposta não deve exceder 2 minutos.<br>- O sistema deve confirmar o recebimento após o envio. |
| **US02** | Como um colaborador, quero receber notificações no meu celular, para ser lembrado de responder aos questionários pendentes e me manter engajado. (RF02) | - A notificação deve ser enviada no início do período de resposta.<br>- O clique na notificação deve direcionar para o questionário.<br>- Deve haver uma opção para desativar as notificações. |
| **US03** | Como um colaborador, quero receber dicas de autocuidado baseadas nas minhas respostas, para que eu possa ter acesso a recursos práticos para meu bem-estar. (RF07) | - As dicas devem ser exibidas após a submissão do questionário.<br>- O conteúdo das dicas deve ser relevante para as dimensões abordadas. |

#### ÉPICO 2: Análise e Gestão de Indicadores Organizacionais
*Foco na experiência do Gestor e RH, entregando ferramentas para análise e tomada de decisão.*

| ID | História de Usuário (User Story) | Critérios de Aceitação |
| :--- | :--- | :--- |
| **US04** | Como um gestor, quero visualizar um dashboard com os principais indicadores de saúde ocupacional, para monitorar o clima organizacional de forma consolidada. (RF03) | - O dashboard deve exibir gráficos consolidados por dimensão.<br>- Os dados devem ser atualizados em tempo real.<br>- O acesso deve ser restrito a perfis de Gestor e RH. |
| **US05** | Como um gestor, quero filtrar os dados do dashboard por período e setor, para comparar resultados e identificar tendências. (RF05) | - O dashboard deve conter filtros de data e setor.<br>- Os gráficos devem ser atualizados dinamicamente.<br>- O sistema deve exibir uma linha de tendência ao comparar períodos. |
| **US06** | Como um profissional de RH, quero exportar os dados do dashboard para um relatório em PDF, para apresentar os resultados em reuniões. (RF04) | - Deve haver um botão "Exportar PDF" visível na tela.<br>- O PDF gerado deve conter todos os gráficos e dados do painel. |
| **US07** | Como um gestor, quero receber sugestões de planos de ação com base nos indicadores mais críticos, para ter um ponto de partida para implementar melhorias. (RF06) | - O sistema deve destacar a dimensão com o pior desempenho.<br>- O sistema deve exibir de 2 a 3 sugestões de ações genéricas. |

#### ÉPICO 3: Administração e Acesso Especializado
*Cobre a gestão de usuários e funcionalidades para consultores externos.*

| ID | História de Usuário (User Story) | Critérios de Aceitação |
| :--- | :--- | :--- |
| **US08** | Como um administrador, quero cadastrar e gerenciar diferentes perfis de usuário (Colaborador, Gestor, etc.), para que cada um tenha acesso apenas ao seu papel. (RF09) | - O sistema deve ter uma tela de login que direcione o usuário corretamente.<br>- Colaboradores não podem acessar dashboards gerenciais.<br>- Apenas administradores podem criar ou editar perfis. |
| **US09** | Como um consultor, quero ter acesso aos relatórios e ao histórico de dados, para utilizar essas informações em diagnósticos técnicos. (RF08) | - O perfil "Consultor" deve ter permissão de visualização dos dashboards e relatórios.<br>- O acesso de um consultor deve ser concedido por um administrador da empresa. |





### Product Backlog Priorizado (MVP)

As funcionalidades do backlog foram priorizadas usando o método **MoSCoW** para definir o escopo do MVP (Minimum Viable Product) e guiar o planejamento das releases. A classificação de cada item é definida da seguinte forma, dentro do contexto da plataforma:

#### Definição da Prioridade (MoSCoW)

* **Must Have (M):**
    * Itens que formam o ciclo central da solução: coletar dados (OE1) e exibi-los (OE1), garantindo a segurança de acesso (OE3).
    * *Exemplos:* `Responder Questionários (US01)`, `Visualizar Dashboard (US04)`, `Gerenciar Perfis (US08)`.

* **Should Have (S):**
   
    * Funcionalidades que tornam os dados mais úteis e acionáveis (OE2, OE6) ou que melhoram o engajamento (OE5).
    * *Exemplos:* `Filtrar e Comparar Dados (US05)`, `Acesso de Consultores (US09)`.

* **Could Have (C):**

    * Itens que representam um nível a mais de inteligência ou automação, mas que podem ser substituídos por processos manuais em um primeiro momento (OE4).
    * *Exemplo:* `Sugerir Planos de Ação (US07)`.


A coluna **Valor x Complexidade** na tabela abaixo utiliza uma matriz de priorização que classifica cada funcionalidade com base nas seguintes definições de "Valor" e "Complexidade":

#### Definição de Valor (Impacto no Projeto)

Mede o impacto direto da funcionalidade nos objetivos de negócio (OEs), na garantia da segurança (LGPD) e na usabilidade para os perfis-chave (Gestor, Colaborador, RH).

* **Alto Valor (Quadrantes 1 e 2):** Funcionalidades essenciais para a proposta central do produto.
    * *Exemplos:* Coleta de dados (OE1), geração de dashboards para gestores (OE1, OE2), e garantia de anonimato e perfis de acesso (OE3).
* **Baixo Valor (Quadrantes 3 e 4):** Funcionalidades de suporte que melhoram a experiência, mas não são vitais para o ciclo principal de coleta e análise.
    * *Exemplos:* Recursos de engajamento secundário (OE5), como notificações ou dicas de autocuidado.

#### Definição de Complexidade (Esforço de Implementação)

Mede o esforço, o tempo e o risco técnico necessários para implementar a funcionalidade, considerando os desafios do projeto (LGPD, processamento de dados, múltiplos perfis).

* **Baixa Complexidade (aprox. 1 Sprint):** Funcionalidades com lógica direta ou que reutilizam componentes existentes.
    * *Exemplos:* Implementação do questionário (US01), gerenciamento de perfis (US08), ou adição de filtros a um dashboard existente (US05).
* **Alta Complexidade (aprox. 2+ Sprints):** Funcionalidades que exigem novas arquiteturas, regras de negócio complexas, lógica de agregação de dados ou garantia rigorosa de segurança.
    * *Exemplos:* Criação do primeiro módulo de dashboard interativo (US04), sistemas de exportação de PDF (US06) ou lógicas de recomendação (US03).


| ID | Requisito Associado | Objetivo Específico | Descrição | Prioridade (MoSCoW) | Valor x Complexidade | MVP |
| :--- | :--- | :--- | :--- | :--- | :-- | :-- |
| US01 | RF01 | OE1 | Responder Questionários | Must have |Quadrante 1 | X |
| US02 | RF02 | OE5 | Receber Notificações de Lembrete | Should have | Quadrante 3 | |
| US03 | RF07 | OE5 | Receber Dicas de Autocuidado | Should have | Quadrante 4 | |
| US04 | RF03 | OE1 | Visualizar Dashboard de Indicadores | Must have | Quadrante 2| X |
| US05 | RF05 | OE2 | Filtrar e Comparar Dados no Dashboard | Should have | Quadrante 1 | X |
| US06 | RF04 | OE6 | Exportar Relatório em PDF | Should have | Quadrante 2 | |
| US07 | RF06 | OE4 | Sugerir Planos de Ação | Could have |Quadrante 2 | |
| US08 | RF09 | OE3 | Gerenciar Perfis de Acesso | Must have | Quadrante 1 | X |
| US09 | RF08 | OE6 | Acesso para Diagnóstico de Consultores | Should have | Quadrante 2 | X |



<iframe width="768" height="496" src="https://miro.com/app/live-embed/uXjVJPIJUrQ=/?focusWidget=3458764644122969405&embedMode=view_only_without_ui&embedId=945139011306" frameborder="0" scrolling="no" allow="fullscreen; clipboard-read; clipboard-write" allowfullscreen></iframe>


---
## Histórico de Versão:
| Data     | Versão | Descrição                                      | Autor      |
| -------- | ------ | ---------------------------------------------- | ---------- |
| 13/10/25 | 1.0    | Criação do Documento e adição do Backlog Geral | Pablo Cunha|
