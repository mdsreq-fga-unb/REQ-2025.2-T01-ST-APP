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
| **RNF01** | A interface deve ser intuitiva e simples para usuários com diferentes níveis de familiaridade tecnológica. | Usability (Usabilidade) |
| **RNF02** | A aplicação deve ser responsiva, funcionando em smartphones e tablets. | Usability (Usabilidade) |
| **RNF03** | Todas as comunicações devem ser criptografadas (HTTPS/TLS). | Requisitos de Interface |
| **RNF04** | Os dados armazenados devem ser anonimizados em conformidade com a LGPD. | Requisitos Externos (Legislativos / Éticos) |
| **RNF05** | O sistema deve suportar múltiplas empresas simultaneamente, sem queda de desempenho. | Restrições de Design |
| **RNF06** | O tempo de resposta da aplicação não deve exceder 3 segundos em operações comuns. | Performance (Desempenho) |
| **RNF07** | A solução deve ser escalável horizontalmente para atender empresas de pequeno, médio e grande porte. | Supportability (Suportabilidade) |
| **RNF08** | O sistema deve ter disponibilidade mínima de 99% (SLA). | Reliability (Confiabilidade) |
| **RNF09** | Deve haver mecanismos de backup automático dos dados diariamente. | Requisitos Organizacionais (Operacionais) |
| **RNF10** | O código deve seguir boas práticas de desenvolvimento (testes, versionamento, documentação). | Requisitos Organizacionais (Desenvolvimento) |
| **RNF11** | O sistema deve permitir a inclusão de novos módulos sem impacto na operação existente. | Supportability (Suportabilidade) |
| **RNF12** | O software deve ser desenvolvido com arquitetura modular para facilitar atualizações e manutenção. | Restrições de Design |
| **RNF13** | Registrar logs de acesso e ações realizadas na plataforma. | Requisitos Organizacionais (Operacionais) |
| **RNF14** | Processar os dados coletados e transformá-los em indicadores objetivos. | Requisitos Organizacionais (Operacionais) |

---


