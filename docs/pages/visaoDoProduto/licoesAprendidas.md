# LIÇÕES APRENDIDAS

## UNIDADE 1

Durante o momento de concepção inicial do aplicativo GenT, lições foram aprendidas, de forma moldar o seu desenvolvimento. Abaixo estão os desafios enfrentados e as ações de melhoria:

### Desafios Enfrentados


* Comunicação da equipe: a troca de informações foi, em alguns momentos, desorganizada, o que gerou atrasos. Como melhoria, foram definidos canais claros: WhatsApp para interações rápidas e Microsoft Teams para reuniões semanais mais estruturadas.


* Comunicação com a cliente: em alguns pontos houve divergências de entendimento sobre os requisitos. A equipe percebeu a importância de manter atas de reunião e validar constantemente as informações registradas, prática que será mantida ao longo do projeto.


* Tecnologias : no início do projeto, a equipe teve dúvidas sobre quais linguagens e ferramentas seriam mais adequadas. Após estudo comparativo, decidiu-se pelo uso de Python no backend, Flutter/Dart no frontend e PostgreSQL no banco de dados. Essa definição reduziu incertezas técnicas e deu segurança ao time.

---

## UNIDADE 2

Nesta unidade, a equipe aprofundou-se nas atividades centrais da Engenharia de Requisitos, desde a declaração e organização até a verificação e validação. O processo de transformar os requisitos iniciais em um backlog estruturado e definir um MVP claro trouxe desafios práticos e aprendizados importantes.

### Lições Aprendidas e Melhorias para o Processo

**Desafio na Estruturação do Backlog:**

* **Dificuldade:** A equipe inicialmente listou os Requisitos Funcionais (RFs) de forma direta, mas sentiu dificuldade em organizá-los de uma maneira que facilitasse o planejamento das Sprints e a visualização do fluxo de valor para o usuário.
* **Como foi superado:** A equipe estudou e aplicou a abordagem de Temas, Épicos e Histórias de Usuário. Os RFs foram reagrupados em Épicos que representam as jornadas dos principais usuários (Colaborador, Gestor). Em seguida, foram reescritos como Histórias de Usuário no formato "Como um..., eu quero..., para que...", o que tornou o valor de negócio de cada requisito muito mais explícito.
* **Ação de Melhoria:** A equipe adotará permanentemente a estrutura de Épicos e User Stories para todo o ciclo de vida do backlog, realizando sessões de grooming (refinamento) para garantir que as histórias estejam sempre bem detalhadas e alinhadas.

**Desafio na Definição do MVP:**

* **Dificuldade:** A equipe teve dificuldades em definir um escopo enxuto para o MVP. Havia uma tendência inicial de incluir funcionalidades importantes (Should Have) na primeira versão, o que tornaria o lançamento mais demorado e arriscado.
* **Como foi superado:** A técnica de priorização MoSCoW, já definida pela equipe, foi aplicada de forma rigorosa. A equipe realizou uma sessão de consenso para garantir que o MVP seria composto exclusivamente pelos itens classificados como MUST. Isso forçou uma reflexão sobre o ciclo de valor mínimo e essencial: coletar dados (US01), visualizar (US04), comparar (US05) e gerenciar acessos (US08).
* **Ação de Melhoria:** Para os próximos incrementos, a definição de escopo seguirá estritamente a priorização do backlog. Nenhuma funcionalidade será adicionada sem antes ser validada como MUST para o objetivo daquela entrega específica.

### Dificuldades e Ações para Superá-las

**Dificuldade na Verificação e Validação dos Requisitos:**

* **Dificuldade:** A equipe não tinha um método claro para garantir que os requisitos eram testáveis e que o entendimento era o mesmo entre todos (desenvolvedores, PO e cliente). Havia o risco de uma funcionalidade ser desenvolvida e não atender plenamente às expectativas.
* **Como foi superado:** A equipe implementou duas práticas abordadas nos materiais de estudo. Primeiro, a escrita de Critérios de Aceitação para cada História de Usuário, servindo como uma forma de validação antecipada. Segundo, a formalização dos conceitos de DoR e DoD como "portões de qualidade".
* **Ação de Melhoria:** A equipe se comprometeu a não iniciar o desenvolvimento de nenhuma história que não atenda à DoR, especialmente no que diz respeito à clareza de seus critérios de aceitação. Da mesma forma, nenhuma funcionalidade será considerada entregue sem cumprir todos os pontos da DoD, garantindo um processo de validação e verificação contínuo.

---