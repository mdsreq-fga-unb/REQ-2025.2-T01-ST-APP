# Requisitos de Software - USM

![Diagrama de Casos de Uso ](../../assets/usmgeral.jpg)

# 🗺️ User Story Mapping (USM)

---

## ⚪ Persona: Usuário do Serviço (Lucas)

### 🟡 Atividade: Iniciar viagem
| 🔵 Passo do Usuário | 🟢 Histórias (MVP) | 🔴 Histórias (Release 2 / Backlog) |
| :--- | :--- | :--- |
| **Localizar veículo** | **Ver veículos próximos com distância e bateria**<br>_Como usuário, quero ver no mapa os veículos próximos com distância e nível de bateria, para escolher rapidamente o mais adequado._<br>📌 O app exibe ícones de veículos no mapa, mostrando distância, tipo e porcentagem de bateria.<br><br>**Filtrar por tipo e acessibilidade**<br>_Como usuário, quero filtrar os veículos por tipo e acessibilidade, para encontrar aquele que melhor atenda minhas necessidades._<br>📌 O usuário aplica filtros no mapa (tipo de veículo, autonomia mínima, acessibilidade). | **Salvar locais favoritos**<br>_Como usuário, quero salvar locais favoritos, para encontrar veículos mais rapidamente nos pontos que costumo utilizar._<br>📌 O app permite marcar locais como favoritos (ex.: casa, trabalho, universidade) e mostra veículos próximos. |

### 🟡 Atividade: Iniciar viagem (Continuação)
| 🔵 Passo do Usuário | 🟢 Histórias (MVP) | 🔴 Histórias (Release 2 / Backlog) |
| :--- | :--- | :--- |
| **Reservar e ir até o veículo** | **Reservar veículo por tempo limitado**<br>_Como usuário, quero reservar o veículo por alguns minutos, para garantir que ele esteja disponível quando eu chegar até ele._<br>📌 O sistema bloqueia o veículo por tempo determinado (ex.: 5 minutos) e exibe contagem regressiva.<br><br>**Receber contagem regressiva da reserva**<br>_Como usuário, quero visualizar uma contagem regressiva da reserva, para saber quanto tempo tenho._<br>📌 O app mostra o tempo restante em tela e envia aviso sonoro quando estiver próximo do fim. | **Receber alerta se o veículo reservado ficar indisponível**<br>_Como usuário, quero ser avisado se o veículo reservado ficar indisponível, para poder escolher outro rapidamente._<br>📌 O app envia uma notificação push informando que o veículo foi cancelado e sugere alternativas próximas. |
| **Desbloquear veículo** | **Desbloquear via QR code**<br>_Como usuário, quero desbloquear o veículo via QR code, para iniciar minha viagem de forma rápida e segura._<br>📌 O app ativa a câmera e, após ler o código, envia solicitação de desbloqueio ao servidor.<br><br>**Checklist rápido de segurança**<br>_Como usuário, quero visualizar um checklist de segurança antes de iniciar a viagem, para evitar problemas._<br>📌 O app mostra lista de verificação simples com pneus, freios e luzes. | **Autoteste do veículo via sensores**<br>_Como usuário, quero que o sistema realize um autoteste automático do veículo, para garantir que ele esteja em boas condições._<br>📌 O sistema coleta dados de telemetria (freios, motor, sensores) e libera o uso apenas se estiver tudo ok. |

### 🟡 Atividade: Encerrar e pagar viagem
| 🔵 Passo do Usuário | 🟢 Histórias (MVP) | 🔴 Histórias (Release 2 / Backlog) |
| :--- | :--- | :--- |
| **Encerrar uso** | **Finalizar viagem e confirmar devolução**<br>_Como usuário, quero encerrar a viagem e confirmar a devolução, para encerrar a cobrança corretamente._<br>📌 O app encerra o trajeto e calcula automaticamente o valor com base no tempo e distância. | **Validação automática de estacionamento**<br>_Como usuário, quero que o sistema valide automaticamente o local de devolução, para evitar multas._<br>📌 O app analisa a foto do local e verifica se o veículo foi deixado em área permitida. |
| **Confirmar pagamento** | **Exibir resumo e recibo da viagem**<br>_Como usuário, quero visualizar o resumo e recibo da viagem, para confirmar o valor cobrado._<br>📌 O app mostra tempo, distância, custo total e opção de enviar o recibo por e-mail. | **Histórico de viagens e reembolso**<br>_Como usuário, quero acessar o histórico de viagens e solicitar reembolso em caso de erro, para garantir transparência._<br>📌 Tela com viagens anteriores e botão para abrir solicitação de reembolso. |
| **Reportar problemas** | **Reportar defeito com foto e localização**<br>_Como usuário, quero reportar defeitos com foto e localização, para contribuir com a manutenção da frota._<br>📌 O app gera automaticamente um ticket para o operador, com data, hora, foto e localização. | **Acompanhar status do chamado**<br>_Como usuário, quero acompanhar o andamento do meu chamado, para saber quando o problema foi resolvido._<br>📌 A tela de suporte mostra o status do chamado (aberto, em andamento, resolvido). |

---

## ⚪ Persona: Operador de Frota (Carlos)

### 🟡 Atividade: Monitorar operação da frota
| 🔵 Passo do Usuário | 🟢 Histórias (MVP) | 🔴 Histórias (Release 2 / Backlog) |
| :--- | :--- | :--- |
| **Acompanhar status em tempo real** | **Ver mapa com veículos e status**<br>_Como operador, quero visualizar no mapa todos os veículos e seus status, para acompanhar a operação em tempo real._<br>📌 O painel mostra ícones coloridos com status: disponível, em uso, em manutenção, bateria baixa.<br><br>**Filtrar por tipo, bateria e região**<br>_Como operador, quero filtrar veículos por tipo, bateria e região, para localizar rapidamente os que precisam de atenção._<br>📌 O painel possui filtros dinâmicos por tipo de veículo, status e área geográfica. | |
| **Receber alertas** | **Alertas de falhas e bateria baixa**<br>_Como operador, quero receber alertas automáticos de falhas e bateria baixa, para agir com rapidez._<br>📌 Notificações são geradas automaticamente no painel e por e-mail. | **Configurar tipos de alerta**<br>_Como operador, quero configurar os tipos de alerta que recebo, para evitar excesso de notificações._<br>📌 O painel permite selecionar categorias de alerta e limites personalizados. |

### 🟡 Atividade: Gerenciar redistribuição e manutenção
| 🔵 Passo do Usuário | 🟢 Histórias (MVP) | 🔴 Histórias (Release 2 / Backlog) |
| :--- | :--- | :--- |
| **Identificar áreas com desequilíbrio** | **Painel de zonas com excesso/falta de veículos**<br>_Como operador, quero visualizar zonas com excesso ou falta de veículos, para equilibrar a frota._<br>📌 O mapa apresenta zonas coloridas indicando a densidade da frota em cada região. | |
| **Criar ordens de recolhimento/envio** | **Criar ordens de recolhimento/envio**<br>_Como operador, quero criar ordens de recolhimento e envio de veículos, para redistribuir conforme a demanda._<br>📌 O sistema permite criar ordens, definir origem, destino e motorista responsável. | |
| **Acompanhar execução das ordens** | **Acompanhar execução das ordens**<br>_Como operador, quero acompanhar o status das ordens, para garantir o cumprimento das redistribuições._<br>📌 Painel mostra status: pendente, em rota, concluída, com atualização em tempo real. | **Sugestões automáticas de rota**<br>_Como operador, quero receber sugestões automáticas de rota, para otimizar deslocamentos e reduzir custos._<br>📌 O sistema recomenda trajetos otimizados com base no trânsito e distância. |

---

## ⚪ Persona: Técnica de Manutenção (Marina)

### 🟡 Atividade: Atender chamados de manutenção
| 🔵 Passo do Usuário | 🟢 Histórias (MVP) | 🔴 Histórias (Release 2 / Backlog) |
| :--- | :--- | :--- |
| **Receber e priorizar chamados** | **Ver lista de veículos com defeito e prioridade**<br>_Como técnica, quero visualizar chamados por ordem de prioridade, para atender primeiro os mais críticos._<br>📌 O painel lista veículos com defeito classificados por gravidade e tempo desde o reporte.<br><br>**Filtrar por tipo de problema e localização**<br>_Como técnica, quero filtrar os chamados por tipo de problema e localização, para otimizar meu deslocamento._<br>📌 O painel permite aplicar filtros como tipo de falha e bairro. | |
| **Realizar manutenção** | **Registrar tipo de conserto e tempo gasto**<br>_Como técnica, quero registrar o tipo de conserto e o tempo gasto, para manter o histórico de manutenção._<br>📌 Formulário com campos de tipo de reparo, peças utilizadas e duração.<br><br>**Atualizar status para “disponível”**<br>_Como técnica, quero atualizar o status do veículo para “disponível”, para devolvê-lo à frota._<br>📌 O status muda no painel geral e o veículo reaparece no mapa do operador. | **Anexar fotos antes/depois**<br>_Como técnica, quero anexar fotos antes e depois do reparo, para comprovar o serviço realizado._<br>📌 Upload de imagens direto no ticket de manutenção. |
| **Gerenciar peças e estoque** | **Solicitar peças para reposição**<br>_Como técnica, quero solicitar peças quando necessário, para que o trabalho não seja interrompido._<br>📌 O sistema gera automaticamente uma solicitação para o estoque. | **Planejar manutenção preventiva**<br>_Como técnica, quero planejar manutenções preventivas com base no uso dos veículos, para reduzir falhas futuras._<br>📌 O sistema sugere revisões programadas conforme quilometragem e tempo de uso. |

---

## ⚪ Persona: Motorista de Apoio (Rogério)

### 🟡 Atividade: Executar recolhimentos e entregas
| 🔵 Passo do Usuário | 🟢 Histórias (MVP) | 🔴 Histórias (Release 2 / Backlog) |
| :--- | :--- | :--- |
| **Receber ordens de recolhimento** | **Ver lista de veículos e destinos**<br>_Como motorista, quero ver a lista de veículos e destinos, para organizar meu roteiro._<br>📌 O app mostra ordens com endereços, prioridade e tipo de veículo. | |
| **Navegar até os veículos** | **Navegar com rota otimizada**<br>_Como motorista, quero navegar com rota otimizada, para economizar tempo e combustível._<br>📌 O app gera sequência ideal considerando trânsito e distância. | **Replanejar rota conforme trânsito**<br>_Como motorista, quero replanejar minha rota em caso de congestionamento, para evitar atrasos._<br>📌 O sistema recalcula o trajeto em tempo real conforme o trânsito. |
| **Registrar conclusão** | **Confirmar recolhimento com foto**<br>_Como motorista, quero confirmar recolhimento com foto, para comprovar o serviço._<br>📌 O app solicita foto no local antes de atualizar o status.<br><br>**Confirmar entrega na oficina**<br>_Como motorista, quero confirmar a entrega na oficina, para encerrar a ordem._<br>📌 Após a entrega, o status do veículo muda para “em manutenção”. | |

---

## ⚪ Persona: Gestora Municipal (Fernanda)

### 🟡 Atividade: Monitorar dados e segurança pública
| 🔵 Passo do Usuário | 🟢 Histórias (MVP) | 🔴 Histórias (Release 2 / Backlog) |
| :--- | :--- | :--- |
| **Consultar uso e indicadores** | **Ver relatórios de uso por região e período**<br>_Como gestora, quero visualizar relatórios de uso por região e horário, para compreender padrões de mobilidade urbana._<br>📌 Painel mostra volume de viagens, veículos ativos e regiões mais utilizadas.<br><br>**Ver indicadores ambientais e de segurança**<br>_Como gestora, quero ver indicadores ambientais e de segurança, para avaliar o impacto do serviço._<br>📌 Exibe gráficos de CO₂ evitado, incidentes e tempo médio de resposta. | **Exportar relatórios padronizados**<br>_Como gestora, quero exportar relatórios padronizados, para compartilhar com órgãos públicos._<br>📌 Permite exportar relatórios em PDF e CSV conforme modelo institucional. |
| **Acompanhar incidentes** | | **Receber alertas de incidentes graves**<br>_Como gestora, quero receber alertas automáticos de incidentes graves, para agir rapidamente._<br>📌 O sistema envia notificações em caso de falhas ou acidentes. |

<iframe width="768" height="432" src="https://miro.com/app/live-embed/uXjVJxCJDVY=/?embedMode=view_only_without_ui&moveToViewport=-2307,-12873,7312,7312&embedId=574551876476" frameborder="0" scrolling="no" allow="fullscreen; clipboard-read; clipboard-write" allowfullscreen></iframe>