# Backlog do Produto

## Backlog Geral

O backlog do produto é o artefato principal que consolida, de forma priorizada, todos os requisitos e demandas para a evolução de um sistema. Ele funciona como uma fonte única de verdade para a equipe, detalhando as funcionalidades, otimizações e correções a serem implementadas. Este backlog é um instrumento vivo, continuamente refinado para se adaptar às mudanças de escopo e aos novos insights que surgem ao longo do ciclo de vida do produto, mantendo a equipe sincronizada com os objetivos do projeto.

A maneira como os requisitos são documentados e detalhados é inspirada em metodologias ágeis. Em geral, os requisitos funcionais são aprofundados em etapas de planejamento, quando são convertidos em histórias de usuário, utilizando um formato padrão que descreve o agente, a ação desejada e o valor gerado por essa ação.

No núcleo do backlog estão as Histórias de Usuário, que traduzem as necessidades dos usuários em descrições simples e focadas em valor. Cada história é construída para responder a três questões essenciais: quem se beneficia, qual ação necessita realizar e qual o propósito dessa ação. Essa abordagem garante que o foco permaneça na perspectiva do usuário final.



#### Tabela de Priorização dos Requisitos

### Requisitos Funcionais


| ID   | Título                             | Descrição                                                                                                                                                                 | MoSCoW | MVP |
| :--- | :--------------------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | :----- | :-- |
| RF01 | Responder Questionários Binários   | Permitir que colaboradores respondam a questionários semanais e/ou quinzenais sobre saúde física, mental, ergonomia e relações interpessoais.                               | MUST   | SIM |
| RF02 | Enviar Notificações de Lembrete    | Enviar notificações automáticas para lembrar os colaboradores de responder aos questionários.                                                                             | SHOULD | NÃO |
| RF03 | Gerar Dashboards Interativos       | Gerar dashboards interativos que permitam a filtragem por períodos e por tipo de indicadores com métricas de qualidade de vida, engajamento e histórico.                  | MUST   | SIM |
| RF04 | Disponibilizar Relatório Gerencial | Disponibilizar relatório gerencial sob demanda do gestor, sobre todos os aspectos presentes nos questionários com exportação em PDF.                                        | SHOULD | NÃO |
| RF05 | Fornecer Comparativos de Períodos  | Fornecer comparativos entre diferentes períodos (quinzenal, mensal e anual) e setores da empresa.                                                                           | SHOULD | SIM |
| RF06 | Sugerir Planos de Ação             | Sugerir automaticamente planos de ação práticos com base nos dados coletados para apoiar a implementação de melhorias.                                                        | COULD  | NÃO |
| RF07 | Oferecer Recomendações de Autocuidado | Oferecer recomendações de autocuidado personalizadas aos colaboradores, geradas a partir das respostas dos questionários.                                                     | SHOULD | NÃO |
| RF08 | Acessar Relatórios de Diagnóstico  | Permitir que consultores e psicólogos acessem relatórios estruturados para fundamentar diagnósticos, mediante autorização dos gestores.                                       | SHOULD | NÃO |
| RF09 | Gerenciar Perfis de Acesso         | Possibilitar o cadastro e login de usuários em diferentes perfis (gestores, RH, etc.), garantindo que cada perfil visualize apenas as informações pertinentes ao seu papel. | MUST   | SIM |

### Requisitos Não Funcionais

| ID    | Título                                | Descrição                                                                                                                                      | MoSCoW | MVP |
| :---- | :------------------------------------ | :--------------------------------------------------------------------------------------------------------------------------------------------- | :----- | :-- |
| RNF01 | Usabilidade da Interface              | A interface do sistema deve ser projetada de forma intuitiva, com usabilidade simples e clara para todos os perfis de usuários.                  | Must   | SIM |
| RNF02 | Design Responsivo                     | A aplicação deve ser responsiva, garantindo adaptação automática a diferentes dispositivos mobile.                                             | Must   | SIM |
| RNF03 | Segurança da Comunicação              | Todas as comunicações devem ser criptografadas (HTTPS/TLS), assegurando a confidencialidade e integridade dos dados.                             | Must   | SIM |
| RNF04 | Privacidade e Conformidade com a LGPD | Os dados armazenados devem estar de acordo com as diretrizes da LGPD, contemplando gestão de consentimento e direitos de acesso/exclusão.        | Must   | SIM |
| RNF05 | Capacidade Multi-empresa              | A solução deve ser capaz de suportar múltiplas empresas (pequeno, médio e grande porte) de forma simultânea, com isolamento lógico dos dados.   | Should | NÃO |
| RNF06 | Desempenho e Tempo de Resposta        | O tempo de resposta da aplicação não deve ultrapassar 3 segundos em operações comuns (carregamento de dashboards, submissão de questionários).   | Could  | NÃO |
| RNF07 | Disponibilidade e Confiabilidade      | O sistema deve oferecer disponibilidade mínima de 99% ao mês (SLA), de forma monitorada e documentada.                                          | Could  | NÃO |
| RNF08 | Backup e Recuperação de Dados         | Deve haver mecanismos de backup automático dos dados diariamente, com processos de recuperação que garantam a restauração após falhas.           | Could  | NÃO |
| RNF09 | Padrões de Desenvolvimento            | O desenvolvimento deve seguir boas práticas de engenharia de software (versionamento, testes automatizados, documentação).                      | Must   | SIM |
| RNF10 | Extensibilidade do Sistema            | O sistema deve permitir a inclusão de novos módulos (ex.: novos tipos de questionários, métricas) sem impacto na operação existente.             | Should | NÃO |
| RNF11 | Arquitetura Modular                   | A solução deve adotar arquitetura modular, possibilitando a fácil substituição ou evolução de componentes individuais.                         | Should | NÃO |
| RNF12 | Registro de Logs                      | Registrar logs de acesso e ações realizadas na plataforma.                                                                                     | Must   | NÃO |
| RNF13 | Processamento Automático de Dados     | O sistema deve processar automaticamente os dados coletados, transformando-os em indicadores objetivos (positivo ou negativo).               | Must   | SIM |
| RNF14 | Anonimato das Respostas               | Garantir que as respostas aos questionários sejam anônimas, sem possibilidade de rastreamento individual.                                      | Must   | SIM |



<iframe width="768" height="496" src="https://miro.com/app/live-embed/uXjVJPIJUrQ=/?focusWidget=3458764644122969405&embedMode=view_only_without_ui&embedId=945139011306" frameborder="0" scrolling="no" allow="fullscreen; clipboard-read; clipboard-write" allowfullscreen></iframe>


---
## Histórico de Versão:
| Data     | Versão | Descrição                                      | Autor      |
| -------- | ------ | ---------------------------------------------- | ---------- |
| 13/10/25 | 1.0    | Criação do Documento e adição do Backlog Geral | Pablo Cunha|
