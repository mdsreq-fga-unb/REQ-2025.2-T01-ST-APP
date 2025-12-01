# Requisitos de Software

## Lista de Requisitos Funcionais (RF)

Requisitos funcionais são especificações que descrevem o que o sistema deve fazer. Eles definem as funções, comportamentos e processos que o software precisa executar para atender às necessidades do usuário ou do negócio. 


| ID | Requisito Funcional | Descrição |
| :--- | :--- | :--- |
| **RF01** | Responder Questionários | Permitir que colaboradores respondam a questionários periódicos sobre saúde física, mental, ergonomia e relações interpessoais. Para cada afirmação apresentada, o colaborador deve expressar seu nível de concordância utilizando uma escala Likert de 5 pontos. |
| **RF02** | Enviar Notificações de Lembrete | Notificar colaboradores sobre questionários que precisam ser respondidos. |
| **RF03** | Gerar Dashboards Interativos | Apresentar um dashboard principal que exiba uma visão geral e consolidada dos indicadores-chave de saúde ocupacional, como Qualidade de Vida no Trabalho e Nível de Engajamento. |
| **RF04** | Disponibilizar Relatório Gerencial | Permitir que gestores e consultores gerem relatórios estruturados a qualquer momento, contendo um resumo, análises detalhadas, tabelas e gráficos de um período selecionado. |
| **RF05** | Fornecer Comparativos de Períodos | Fornecer comparativos dos indicadores entre diferentes períodos ou setores da empresa. |
| **RF06** | Sugerir Planos de Ação | Sugerir um plano de ação prático com base nos dados coletados e analisados. |
| **RF07** | Oferecer Recomendações de Autocuidado | Oferecer recomendações de autocuidado personalizadas ao colaborador com base em suas respostas. |
| **RF08** | Acessar Relatórios de Diagnóstico | Permitir que consultores e psicólogos acessem um relatório estruturado para fundamentar diagnósticos técnicos. |
| **RF09** | Gerenciar Perfis de Acesso | Possibilitar o cadastro e login de diferentes perfis de acesso (gestores, RH, colaboradores, consultores), cada um com suas permissões específicas. |


## Lista de Requisitos Não Funcionais (RNF)

Requisitos não funcionais descrevem como o sistema do software deve operar, garantindo qualidade, usabilidade e desempenho adequados à experiência dos usuários e à administração eficiente da plataforma.

| ID | Descrição | Classificação |
| :--- | :--- | :--- |
| **RNF01** | A interface deve permitir que novos usuários realizem as principais ações (responder questionário e acessar dashboard) sem treinamento, com taxa mínima de sucesso de 95% em testes de usabilidade com 10 participantes, em no máximo 2 minutos. | Usability (Usabilidade) |
| **RNF02** | A aplicação deve se adaptar automaticamente a resoluções entre 360×640 e 1920×1080, mantendo legibilidade com contraste mínimo AA e sem distorções. Os testes devem incluir smartphones Android, iOS e tablets. | Usability (Usabilidade) |
| **RNF03** | Todas as comunicações cliente–servidor devem utilizar HTTPS com TLS 1.2 ou superior. A verificação deve ser feita via ferramenta SSL Labs e deve obter nota mínima |
| **RNF04** | Os dados pessoais devem ser anonimizados por hashing irreversível, antes de gravação. Nenhuma tabela pode armazenar identificadores diretos do colaborador. Deve ser aprovado em checklist LGPD baseado no art. 13 e 46.| Requisitos Externos (Legislativos / Éticos) |
| **RNF05** | O sistema deve suportar ao menos 20 empresas simultâneas, cada uma com mínimo de 200 colaboradores, mantendo tempo de resposta ≤ 3 segundos e consumo de CPU do servidor menor que 70%. | Restrições de Design |
| **RNF06** | O tempo de resposta da aplicação não deve exceder 3 segundos em operações comuns. | Performance (Desempenho) |
| **RNF07** | O sistema deve permitir a adição de novas instâncias da aplicação sem necessidade de downtime, suportando aumento de até 300% no volume de usuários com crescimento linear (menor que 20% degradação de performance).| Supportability (Suportabilidade) |
| **RNF08** | O sistema deve manter disponibilidade mínima de 99% ao mês. O monitoramento será feito com intervalo de verificação de 5 minutos.| Reliability (Confiabilidade) |
| **RNF09** |O sistema deve executar backup diário incremental e backup completo semanal. Os backups devem ser armazenados por 30 dias e restauráveis em menos de 5 minutos.| Requisitos Organizacionais (Operacionais) |
| **RNF10** |Todo código deve possuir cobertura mínima de testes automatizados de 80%, integração contínua configurada, e seguir padrões Flutter (frontend).| Requisitos Organizacionais (Desenvolvimento) |
| **RNF11** |O sistema deve permitir adicionar novos módulos (como novos questionários, relatórios ou métricas) sem necessidade de modificar funcionalidades já existentes, comprovado por testes de regressão que garantam que todas as funcionalidades anteriores continuam funcionando corretamente.| Supportability (Suportabilidade) |
| **RNF12** |O software deve seguir arquitetura modular (ex.: camadas + serviços separados), permitindo atualização individual de módulos sem impacto nos demais. Deve ser comprovado via inspeção arquitetural.| Restrições de Design |
| **RNF13** |O sistema deve registrar logs de autenticação, erros e ações críticas, armazenando-os por 90 dias, seguindo padrão JSON estruturado.| Requisitos Organizacionais (Operacionais) |
| **RNF14** |Os dados coletados devem ser processados em no máximo 10 segundos após envio para atualizar indicadores. Testes devem medir o tempo entre submissão e atualização no dashboard.| Requisitos Organizacionais (Operacionais) |

---


