# Requisitos de Software - Casos de Usos

![Diagrama de Casos de Uso ](../../assets/cdu.png)

# Especificação de Caso de Uso: Registrar Paciente

**1\. Nome do Caso de Uso** : Registrar Paciente

**1\.1 Breve Descrição:** Este caso de uso permite que um novo usuário realize seu cadastro no sistema, fornecendo informações pessoais e de saúde necessárias para acesso às funcionalidades disponíveis\. O sistema valida informações, registra os dados e cria um perfil de usuário com permissões iniciais\.

**1\.2 Atores**

- **Ator Principal:** Paciente 
- **Atores Secundários:** Administrador do Sistema \(em cenários de suporte ou validação manual\)

**2\. Fluxo de Eventos**

**2\.1 Fluxo Principal**

1. O caso de uso é iniciado quando o paciente solicita o cadastro no sistema\.\.
2. O sistema solicita informações pessoais básicas \(nome, CPF, data de nascimento, telefone, e\-mail\)\.
3. O paciente insere os dados solicitados\.
4. O sistema solicita informações complementares de saúde \(comorbidades, alergias, medicamentos\)
5. O paciente fornece as informações solicitadas\.
6. O sistema valida os dados inseridos\.
7. O sistema registra o paciente e cria o perfil no banco\.
8. O sistema apresenta mensagem de confirmação\.
9. O caso de uso é encerrado\.

**2\.2 Fluxos Alternativos**

- **\[FA01\] Importação de Dados de Saúde:**
    - No passo 4, o sistema pode oferecer a opção de importar dados de saúde de bases públicas, caso haja integração com sistemas de saúde\.
- **\[FA02\] Cadastro Assistido**
    - No passo 3, caso o paciente tenha dificuldades, o administrador pode realizar o cadastro em nome dele\.

**2\.3 Fluxos de Exceção**

- **\[FE01\] Dados Inválidos**
    - No passo 6, se os dados forem inválidos, o sistema exibe mensagem e retorna ao passo 2\.
- **\[FE02\] CPF Já Cadastrado**
    - No passo 6, se o CPF já existir, o sistema informa o erro e sugere recuperação de acesso\.

**3\. Requisitos Especiais**

- O sistema deve oferecer interface responsiva para dispositivos móveis\.
- O sistema deve criptografar dados sensíveis\.
- O sistema deve validar e\-mail e CPF automaticamente\.

**4\. Regras de Negócio**

- **\[RN01\] Unicidade de CPF:** Não é permitido cadastro duplicado\.
- **\[RN02\] Privacidade:** Informações devem ser armazenadas conforme normas de segurança\.

**5\. Precondições**

- O paciente deve ter acesso à internet\.
- O paciente deve aceitar os termos de uso\.

**6\. Pós\-condições**

- O paciente deve aceitar os termos de uso\.
- Dados de saúde armazenados e disponíveis\.

**7\. Pontos de Extensão**

- Pode ser estendido pelo caso de uso **Avaliar Atendimento**, para permitir coleta de dados iniciais\.



# Especificação de Caso de Uso: Agendar Exame

**1\. Nome do Caso de Uso** : Agendar Exame

**1\.1 Breve Descrição:** Permite que o paciente agende exames médicos em unidades de saúde disponíveis, consultando horários e profissões habilitadas, com registro automático e confirmação\.

**1\.2 Atores**

- **Ator Principal:** Paciente
- **Atores Secundários:** Profissional de Saúde

**2\. Fluxo de Eventos**

**2\.1 Fluxo Principal**

1. O paciente acessa a funcionalidade de agendamento de exame\.
2. O sistema solicita informações sobre o tipo de exame\.
3. O paciente seleciona o tipo de exame desejado\.
4. O sistema verifica disponibilidade de unidades e horários\.
5. O sistema apresenta opções disponíveis\.
6. O paciente seleciona a unidade e horário desejado\.
7. O sistema registra o agendamento\.
8. O sistema envia confirmação automática ao paciente\.
9. O caso de uso é encerrado\.

**2\.2 Fluxos Alternativos**

- **\[FA01\] Exame Domiciliar**
    - No passo 2, se o exame permitir modalidade domiciliar, o sistema oferece essa opção\.

**2\.3 Fluxos de Exceção**

- **\[FE01\] Sem Unidades Disponíveis**
    - No passo 4, se não houver unidades disponíveis, o sistema informa indisponibilidade\.
- **\[FE02\] Sem Horários Disponíveis**
    - No passo 5, se não houver horários, sugerir agenda futura\.

**3\. Requisitos Especiais**

- Sistema deve funcionar com baixa largura de banda\.

**4\. Regras de Negócio**

- **\[RN01\] Prioridade:** Exames de emergência devem ser priorizados\.
- **\[RN02\] Multiplas Unidades:** Permitir agendamento em unidades externas\.

**5\. Precondições**

- Paciente cadastrado e logado\.

**6\. Pós\-condições**

- Exame registrado e notificação enviada\.

**7\. Pontos de Extensão**

- Pode ser estendido pelo caso de uso **Cancelar Exame**\.



# Especificação de Caso de Uso: Registrar Atendimento

**1\. Nome do Caso de Uso** : Registrar Atendimento

**1\.1 Breve Descrição:** Permite que o profissional de saúde registre os dados de um atendimento realizado, incluindo queixas, diagnóstico, intervenções, e anexação de exames\.

**1\.2 Atores**

- **Ator Principal:** Profissional da Saúde
- **Atores Secundários:** Paciente

**2\. Fluxo de Eventos**

**2\.1 Fluxo Principal**

1. O profissional acessa a funcionalidade &quot;Registrar Atendimento&quot;\.
2. O sistema apresenta lista de pacientes com consulta agendada\.
3. O profissional seleciona o paciente\.
4. O profissional insere dados do atendimento\.
5. O profissional pode anexar exames e registros adicionais\.
6. O sistema salva o atendimento\.
7. O sistema atualiza o histórico médico\.
8. O caso de uso é encerrado\.

**2\.2 Fluxos Alternativos**

- **\[FA01\] Atendimento Sem Consulta Agendada**
    - No passo 2, o profissional pode buscar pacientes sem agendamento prévio\.

**2\.3 Fluxos de Exceção**

- **\[FE01\] Falha de Upload de Exame** 
    - No passo 5, se falhar upload, o sistema solicita nova tentativa\.

**3\. Requisitos Especiais**

- Sistema deve proteger dados sensíveis\.
- Sistema deve funcionar offline para coleta local\.

**4\. Regras de Negócio**

- **\[RN01\] Sigilo Médico:** Acesso restrito a profissionais autorizados\.
- **\[RN02\] Imutabilidade:** Registros não podem ser apagados\.

**5\. Precondições**

- Profissional autenticado\.

**6\. Pós\-condições**

- Atendimento registrado e histórico atualizado\.

**7\. Pontos de Extensão**

- Pode ser estendido pelo caso de uso **Anexar Exames**



# Especificação de Caso de Uso: Gerenciar Agenda

**1\. Nome do Caso de Uso** : Gerenciar Agenda

**1\.1 Breve Descrição:** Este caso de uso permite que o profissional de saúde gerencie sua agenda de atendimentos e exames, realizando ações como visualizar horários, bloquear horários indisponíveis, reagendar atendimentos e consultar o status dos agendamentos existentes\. O sistema atualiza automaticamente a disponibilidade para pacientes e outros atores\.

**1\.2 Atores**

- **Ator Principal:** Profissional de Saúde
- **Atores Secundários:** Paciente \(indiretamente afetado\), Sistema

**2\. Fluxo de Eventos**

**2\.1 Fluxo Principal**

1. O profissional acessa a funcionalidade &quot;Gerenciar Agenda&quot;\.
2. O sistema exibe a agenda atual com horários ocupados, livres e pendentes\.
3. O profissional seleciona a data desejada para visualização\.
4. O sistema apresenta os atendimentos agendados naquela data\.
5. O profissional realiza uma ação, como:
    - bloquear horário
    - liberar horário
    - reagendar atendimento
    - confirmar presença de paciente
6. O sistema valida a ação solicitada\.
7. O sistema atualiza a agenda conforme a alteração\.
8. O sistema notifica automaticamente o paciente, quando aplicável\.
9. O caso de uso é encerrado\.

**2\.2 Fluxos Alternativos**

- **\[FA01\] Inserir Intervalos de Atendimento**
    - No passo 5, o profissional pode cadastrar intervalos fixos \(almoço, reuniões, plantões\)\.
- **\[FA02\] Reagendamento Manual pelo Profissional**
    - No passo 5, se um paciente for remanejado, o profissional seleciona novo horário disponível e confirma a alteração\.

**2\.3 Fluxos de Exceção**

- **\[FE01\] Horário Conflitante**
    - No passo 6, se o horário solicitado conflitar com outra atividade, o sistema exibe mensagem e impede alteração\.
- **\[FE02\] Agenda Bloqueada**
    - No passo 6, se a agenda estiver bloqueada por política institucional, o sistema exibe erro e sugere contato com administrador\.

**3\. Requisitos Especiais**

- O sistema deve apresentar visualização diária, semanal e mensal\.
- O sistema deve permitir operação em dispositivos móveis\.
- O sistema deve sincronizar alterações em tempo real\.

**4\. Regras de Negócio**

- **\[RN01\] Bloqueios Automáticos:**  O sistema deve bloquear automaticamente horários ocupados por outros atendimentos\.
- **\[RN02\] Notificação Automática:** Qualquer alteração que impacte o paciente deve gerar notificação automática\.
- **\[RN03\] Limite de Reagendamentos:** O paciente não pode ter mais de 2 reagendamentos no mesmo período sem justificativa válida\.

**5\. Precondições**

- Profissional deve estar autenticado\.
- Agenda do profissional deve existir no sistema\.

**6\. Pós\-condições**

- Agenda atualizada conforme ações realizadas\.
- Paciente notificado quando houver impacto no atendimento\.
- Alterações registradas para auditoria\.

**7\. Pontos de Extensão**

- Pode ser estendido pelo caso de uso **Cancelar Consulta** ou **Cancelar Exame**\.
- Pode ser estendido por **Registrar Atendimento** para atualização automática após o atendimento\.



<iframe width="768" height="432" src="https://miro.com/app/live-embed/uXjVJm4iAps=/?embedMode=view_only_without_ui&moveToViewport=-1810,-813,3664,1917&embedId=480725351151" frameborder="0" scrolling="no" allow="fullscreen; clipboard-read; clipboard-write" allowfullscreen></iframe>