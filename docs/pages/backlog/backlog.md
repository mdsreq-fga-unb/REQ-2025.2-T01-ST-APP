# Backlog do Produto

## Backlog Geral

O backlog do produto é o artefato principal que consolida, de forma priorizada, todos os requisitos e demandas para a evolução de um sistema. Ele funciona como uma fonte única de verdade para a equipe, detalhando as funcionalidades, otimizações e correções a serem implementadas. Este backlog é um instrumento vivo, continuamente refinado para se adaptar às mudanças de escopo e aos novos insights que surgem ao longo do ciclo de vida do produto, mantendo a equipe sincronizada com os objetivos do projeto.

A maneira como os requisitos são documentados e detalhados é inspirada em metodologias ágeis. Em geral, os requisitos funcionais são aprofundados em etapas de planejamento, quando são convertidos em histórias de usuário, utilizando um formato padrão que descreve o agente, a ação desejada e o valor gerado por essa ação.

No núcleo do backlog estão as Histórias de Usuário, que traduzem as necessidades dos usuários em descrições simples e focadas em valor. Cada história é construída para responder a três questões essenciais: quem se beneficia, qual ação necessita realizar e qual o propósito dessa ação. Essa abordagem garante que o foco permaneça na perspectiva do usuário final.

O backlog geral contém todas as funcionalidades planejadas para o software, organizadas em Épicos e detalhadas como Histórias de Usuário (User Stories) para garantir uma visão clara do que será desenvolvido ao longo do projeto.

### Tema 1 - Experiência do Colaborador
#### ÉPICO 1: Engajamento e Coleta de Percepções 
*Foco na experiência do colaborador, garantindo um canal seguro e prático para feedback.*

| ID | História de Usuário (User Story) | Critérios de Aceitação |
| :--- | :--- | :--- |
| **US01** | Como um colaborador, eu quero responder a um questionário simples com perguntas de grau de concordância, para que eu possa compartilhar minha percepção sobre meu bem-estar no trabalho de forma rápida e anônima. (RF01)|- O questionário deve ser apresentado exibindo claramente a pergunta e as 5 opções de resposta de concordância.<br>- O sistema não deve exibir o nome do colaborador ou qualquer dado de identificação pessoal (como e-mail ou matrícula) em qualquer tela durante o preenchimento do questionário.<br>- O botão 'Enviar' deve permanecer desabilitado até que todas as perguntas obrigatórias do questionário tenham sido respondidas.<br>- Dado que o colaborador respondeu todas as perguntas, quando ele clica no botão 'Enviar', então uma mensagem de confirmação (ex: "Obrigado! Sua resposta anônima foi registrada.") é exibida e o questionário é removido da lista de pendências.<br>- Dado que o colaborador tenta enviar um questionário incompleto, quando ele clica em 'Enviar', então o sistema deve destacar visualmente as perguntas que faltam ser respondidas e não deve permitir o envio. |
| **US02** | Como um colaborador, quero receber notificações no meu celular, para ser lembrado de responder aos questionários pendentes e me manter engajado. (RF02) | - A notificação push deve ser disparada automaticamente para o dispositivo do colaborador no início do período configurado para resposta (ex: "Novo questionário de Bem-Estar disponível!").<br>- O clique na notificação deve direcionar para tela inicial do questionário pendente.<br>- Deve existir uma opção visível na tela de "Configurações" ou "Perfil" do aplicativo que permita ao colaborador ativar ou desativar o recebimento de "Notificações de Questionários". |
| **US03** | Como um colaborador, quero receber dicas de autocuidado baseadas nas minhas respostas, para que eu possa ter acesso a recursos práticos para meu bem-estar. (RF07) | - As dicas devem ser exibidas após a submissão do questionário.<br>- Dado que o sistema identifica que a dimensão com a pontuação mais baixa nas respostas do colaborador foi "Saúde Mental", quando o colaborador acessa a seção de dicas, então as dicas categorizadas como "Saúde Mental" devem ser exibidas com prioridade |

### Tema 2 - Gestão de indicadores
#### ÉPICO 2: Análise e Gestão de Indicadores Organizacionais
*Foco na experiência do Gestor e RH, entregando ferramentas para análise e tomada de decisão.*

| ID | História de Usuário (User Story) | Critérios de Aceitação |
| :--- | :--- | :--- |
| **US04** | Como um gestor, quero visualizar um dashboard com os principais indicadores de saúde ocupacional, para monitorar o clima organizacional de forma consolidada. (RF03) | -Ao acessar o dashboard, o gestor deve visualizar gráficos (ex: barras ou pizza) que mostram a distribuição percentual consolidada das respostas para cada dimensão principal (ex: "Qualidade de Vida", "Engajamento").<br>- Dado que novas respostas foram submetidas e processadas, quando um gestor acessa ou atualiza o dashboard, então os dados dessas novas respostas devem estar refletidos anonimamente nos gráficos consolidados.<br>- Dado que um usuário com perfil 'Colaborador' tenta acessar o dashboard, então o sistema deve exibir uma mensagem de "Acesso Negado" ou redirecioná-lo para sua tela inicial. |
| **US05** | Como um gestor, quero filtrar os dados do dashboard por período e setor, para comparar resultados e identificar tendências. (RF05) | - A interface do dashboard deve apresentar controles visíveis para filtrar por: Período (com opções pré-definidas e um seletor de data customizado) e Setor/Departamento.<br>- Dado que o gestor aplica um filtro de período (ex: "Último Mês"), quando os gráficos são atualizados, então eles devem exibir apenas os dados das respostas submetidas dentro daquele intervalo de datas.<br>- O sistema deve exibir uma linha de tendência ao comparar períodos. |
| **US06** | Como um profissional de RH, eu quero exportar os dados do dashboard para um relatório em PDF, para que eu possa apresentar os resultados em reuniões e disponibilizá-los para consultores. (RF04) | - Deve haver um botão "Exportar PDF" visível na tela.<br>- Dado que o usuário aplicou filtros no dashboard (ex: "Setor de TI", Período: "Últimos 3 meses"), quando ele clica em "Exportar PDF", então o PDF gerado deve conter apenas os dados e gráficos referentes aos filtros aplicados.<br>- O relatório PDF gerado deve incluir, em seu cabeçalho padrão da empresa com Logo e Título centralizado ou página de rosto, a quais filtros (setor, período) os dados se referem.<br>- O arquivo deve ser gerado obrigatoriamente no formato PDF .<br> - O nome do arquivo deve seguir o padrão: Relatorio_DATA_HORA.[extensão].<br> -O arquivo deve conter as seguintes colunas/campos, nesta ordem exata: Nome do Cliente (Texto), Data da Operação (Formato DD/MM/AAAA), Valor Total (Formato R$ 0,00) e Status (Ativo/Inativo).<br>- O rodapé deve exibir a soma total da coluna "Valor"|
| **US07** | Como um gestor, quero receber sugestões de planos de ação com base nos indicadores mais críticos, para ter um ponto de partida para implementar melhorias. (RF06) | - O sistema deve identificar e listar os 3 (três) indicadores com o desempenho mais crítico no período.<br>- Para cada indicador crítico identificado, o sistema deve sugerir pelo menos um curso relevante para a melhoria desse indicador.<br>- A sugestão de curso deve incluir Título do Curso, a Área de Foco (relacionada ao indicador crítico) e a previsão de oferta futura.<br>- O curso sugerido deve estar no catálogo de cursos futuros.<br>- O sistema não deve sugerir um curso que a equipe associada ao indicador crítico já tenha concluído recentemente (prazo a ser definido em Conversa).<br>- Caso não haja cursos relevantes para o indicador crítico, o sistema deve informar o gestor da ausência de sugestão e indicar o indicador em questão.|

### Tema 3 — Administração e Acesso
#### ÉPICO 3: Acesso Especializado
*Cobre a gestão de usuários e funcionalidades para consultores externos.*

| ID | História de Usuário (User Story) | Critérios de Aceitação |
| :--- | :--- | :--- |
| **US08** | Como um administrador do sistema, eu quero cadastrar usuários definindo seus perfis de acesso (Colaborador, Gestor, RH, Consultor), para garantir que cada usuário tenha permissões adequadas ao seu papel. (RF09) | - O Administrador deve conseguir acessar a tela “Cadastrar Usuário".<br>- O formulário de cadastro deve exigir:Nome completo, E-mail profissional, Senha provisória e Seleção de apenas um dos perfis: Colaborador, Gestor, RH, Consultor.<br>- Após salvar, o sistema deve:Registrar o novo usuário e Enviar e-mail automático com instruções de primeiro acesso.<br>- O sistema deve impedir o cadastro de usuários com e-mail duplicado.<br>- A criação deve ser registrada com data, hora e identificador do administrador que realizou o cadastro.|
| **US09** | Como um administrador do sistema, eu quero gerenciar os usuários existentes (editar informações, alterar perfil e desativar contas), para manter o controle adequado dos acessos ao sistema. (RF09) | - O Administrador deve visualizar uma lista com todos os usuários do sistema.<br>- A lista deve permitir:Buscar por nome ou e-mail, Filtrar por perfil (Colaborador, Gestor, RH, Consultor) e Filtrar por status (Ativo / Inativo).<br>- O Administrador deve poder:Editar nome, e-mail e perfil do usuário, Desativar o usuário (o acesso deve ser imediatamente bloqueado) e Reativar o usuário, caso esteja inativo.<br>- O sistema deve impedir: Que o Administrador desative o próprio usuário logado e Alterar o perfil de um usuário sem confirmar a ação.<br>- Toda ação de edição, desativação ou reativação deve gerar registro de auditoria com:Data, Hora, Administrador responsável e Tipo de modificação.|
| **US10** | Como um consultor, eu quero acessar um relatório estruturado com análises consolidadas das respostas dos colaboradores, para utilizá-lo como base em diagnósticos técnicos. (RF08) | - O consultor só pode acessar relatórios das empresas às quais foi vinculado pelo Administrador..<br>- O consultor deve selecionar uma empresa antes de visualizar o relatório.<br>- O relatório deve conter, obrigatoriamente:Resumo Executivo(Quantidade de respondentes, Período analisado e Setores incluídos no relatório), Médias gerais por dimensão, incluindo(Saúde Mental, Física, Relacionamentos Interpessoais...), Ranking das 3 dimensões mais críticas(Menores médias e Porcentagem de discordância), Gráficos consolidados e Recomendações automáticas baseadas em padrões críticos(ex.: baixa nota em Saúde Mental gera recomendação “avaliar políticas de apoio psicológico”).|
| **US11** | Como um consultor, eu quero acessar o histórico temporal dos indicadores de bem-estar, para analisar a evolução das dimensões ao longo do tempo e identificar padrões críticos. (RF08) | - O consultor deve poder selecionar:Empresa, Período (ex.: últimos 3 meses, último ano, período personalizado) e Setor (opcional).<br>- O sistema deve exibir: Séries temporais (linha do tempo) para cada dimensão(ex: saúde mental,...), Variação percentual mês a mês e Marcadores de eventos organizacionais importantes(se cadastrados pelo RH, como campanhas de saúde ou ações internas).|



### Product Backlog Priorizado (MVP)

As funcionalidades do backlog foram priorizadas usando o método **MoSCoW** para definir o escopo do MVP (Minimum Viable Product) e guiar o planejamento das releases. A classificação de cada item é definida da seguinte forma, dentro do contexto da plataforma:

#### Definição da Prioridade (MoSCoW)

* **Must Have (M):**
    * Itens que formam o ciclo central da solução: coletar dados (OE1) e exibi-los (OE1, OE2), garantindo a segurança de acesso (OE3).
    * *Exemplos:* `Responder Questionários (US01)`, `Visualizar Dashboard (US04)`, `Filtrar Dashboard (US05)`,`VCadastrar Usuários (US08)`,`Gerenciar Perfis (US09)`.

* **Should Have (S):**
   
    * Funcionalidades que tornam os dados mais úteis e acionáveis (OE2, OE6) ou que melhoram o engajamento (OE5).
    * *Exemplos:* `Filtrar e Comparar Dados (US05)`, `Acesso de Consultores (US09)`.

* **Could Have (C):**

    * Itens que representam um nível a mais de inteligência, recomendações ou automação, mas que podem ser substituídos por processos manuais em um primeiro momento (OE4, OE6).
    * *Exemplo:* `Dicas de Autocuidado (US03)`, `Sugerir Planos de Ação (US07)`, `Relatório Consolidado para Consultores (US10)`,`Histórico Temporal (US11)`.


A coluna **Valor x Complexidade** na tabela abaixo utiliza uma matriz de priorização que classifica cada funcionalidade com base nas seguintes definições de "Valor" e "Complexidade":

#### Definição de Valor (Impacto no Projeto)

Mede o impacto direto da funcionalidade nos objetivos de negócio (OEs), na garantia da segurança (LGPD) e na usabilidade para os perfis-chave (Gestor, Colaborador, RH).

* **Alto Valor (Quadrantes 1 e 2):** Funcionalidades essenciais para a proposta central do produto.
    * *Exemplos:* Coleta de dados (OE1), geração de dashboards para gestores (OE1, OE2), e garantia de anonimato e perfis de acesso (OE3).
* **Baixo Valor (Quadrantes 3 e 4):** Funcionalidades de suporte que melhoram a experiência, mas não são vitais para o ciclo principal de coleta e análise.
    * *Exemplos:* Recursos de engajamento secundário (OE5), como notificações ou dicas de autocuidado.

#### Definição de Complexidade (Esforço de Implementação)

Mede o esforço, o tempo e o risco técnico necessários para implementar a funcionalidade, considerando os desafios do projeto (LGPD, processamento de dados, múltiplos perfis).

* **Baixa Complexidade (aprox. 0.5 Sprint):** Funcionalidades com lógica direta ou que reutilizam componentes existentes.
   
* **Alta Complexidade (aprox. 1 Sprint):** Funcionalidades que exigem novas arquiteturas, regras de negócio complexas, lógica de agregação de dados ou garantia rigorosa de segurança.
   


| ID | Requisito Associado | Objetivo Específico | Descrição | Prioridade (MoSCoW) | Valor x Complexidade | MVP |
| :--- | :--- | :--- | :--- | :--- | :-- | :-- |
| US01 | RF01 | OE1 | Responder Questionários | Must have |Quadrante 1 | X |
| US02 | RF02 | OE5 | Notificações de Lembrete | Should have | Quadrante 3 | |
| US03 | RF07 | OE5 | Dicas de Autocuidado | Should have | Quadrante 4 | |
| US04 | RF03 | OE1 | Visualizar Dashboard de Indicadores | Must have | Quadrante 1| X |
| US05 | RF05 | OE2 | Filtrar e Comparar Dados no Dashboard | Must have | Quadrante 1 | X |
| US06 | RF04 | OE6 | Exportar Relatório em PDF | Should have | Quadrante 2 | |
| US07 | RF06 | OE4 | Planos de Ação | Could have |Quadrante 2 | |
| US08 | RF09 | OE3 | Cadastrar Usuários | Must have | Quadrante 1 | X |
| US09 | RF09 | OE3 | Gerenciar Usuários | Must have| Quadrante 1 | X |
| US10 | RF08 | OE6 | Relatório para Consultor | Could have | Quadrante 2 |  |
| US11 | RF08 | OE6 | Acesso para Diagnóstico de Consultores | Could have| Quadrante 4 |  |



<iframe width="768" height="496" src="https://miro.com/app/live-embed/uXjVJPIJUrQ=/?focusWidget=3458764644122969405&embedMode=view_only_without_ui&embedId=945139011306" frameborder="0" scrolling="no" allow="fullscreen; clipboard-read; clipboard-write" allowfullscreen></iframe>


---
## Histórico de Versão:
| Data     | Versão | Descrição                                      | Autor      |
| -------- | ------ | ---------------------------------------------- | ---------- |
| 13/10/25 | 1.0    | Criação do Documento e adição do Backlog Geral | Pablo Cunha|
| 01/12/25 | 1.0    | Atualizações do Backlog | Ingrid Alves|

