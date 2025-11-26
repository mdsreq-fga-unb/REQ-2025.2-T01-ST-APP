import 'package:flutter/material.dart';
import 'dart:convert';
import '../services/api_service.dart';
import '../widget/custom_button.dart';
import '../widget/confirmation_dialog.dart'; // Importar o diálogo

class QuestionarioPage extends StatefulWidget {
  const QuestionarioPage({super.key});

  @override
  State<QuestionarioPage> createState() => _QuestionarioPageState();
}

class _QuestionarioPageState extends State<QuestionarioPage> {
  // Cores baseadas no novo protótipo
  final Color corRoxaClara = const Color(0xFFD4A0FA);
  final Color corLaranja = const Color(0xFFFEBB4C);
  final Color corRoxaEscura = const Color(0xFFA550E2); 

  final apiService = ApiService();
  List perguntas = [];
  Map<int, int> respostas = {};
  bool carregando = true;
  int perguntaAtual = 0;

  final List<Map<String, dynamic>> opcoesLikert = [
    {'texto': 'Concordo totalmente', 'valor': 5},
    {'texto': 'Concordo parcialmente', 'valor': 4},
    {'texto': 'Nem concordo, nem discordo', 'valor': 3},
    {'texto': 'Discordo parcialmente', 'valor': 2},
    {'texto': 'Discordo totalmente', 'valor': 1},
  ];

  @override
  void initState() {
    super.initState();
    carregarPerguntas();
  }

  Future<void> carregarPerguntas() async {
    try {
      List dados = await apiService.getPerguntas();
      setState(() {
        perguntas = dados;
        carregando = false;
      });
    } catch (e) {
      print("Erro: $e");
      setState(() => carregando = false);
    }
  }

  void responder(int valor) {
    var perguntaId = perguntas[perguntaAtual]['id'];
    setState(() {
      respostas[perguntaId] = valor;
    });

    if (perguntaAtual < perguntas.length - 1) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) setState(() => perguntaAtual++);
      });
    }
  }

  bool todasRespondidas() {
    if (perguntas.isEmpty) return false;
    return respostas.length == perguntas.length;
  }

  Future<void> concluirQuestionario() async {
    if (!todasRespondidas()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Por favor, responda todas as perguntas."),
        ),
      );
      return;
    }

    // O pop-up laranja com botões roxos
    final bool? confirmar = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return const ConfirmationDialog(); 
      },
    );

    if (confirmar != true) return;

    try {
      final respostasConvertidas = respostas.map((k, v) => MapEntry(k, v));
      await apiService.enviarRespostas(respostasConvertidas);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(backgroundColor: Colors.green, content: Text("Enviado com sucesso!")),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      print("Erro envio: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erro ao enviar respostas.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double progresso = 0;
    if (perguntas.isNotEmpty) {
      // Progresso baseado nas perguntas respondidas, não na atual
      progresso = respostas.length / perguntas.length;
    }

    if (carregando) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(), // AppBar roxa simples
        body: Center(child: CircularProgressIndicator(color: corLaranja)),
      );
    }

    if (perguntas.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(),
        body: const Center(child: Text("Nenhuma pergunta disponível.")),
      );
    }

    var pergunta = perguntas[perguntaAtual];
    var idPergunta = pergunta['id'];
    var respostaAtual = respostas[idPergunta];
    bool isUltimaPergunta = perguntaAtual == perguntas.length - 1;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(), // Cabeçalho Roxo Simples
      body: Column(
        children: [
          // --- MUDANÇA 1: Barra de Progresso separada ---
          _buildProgressBar(progresso),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Card da Pergunta Laranja
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    decoration: BoxDecoration(
                      color: corLaranja, // Laranja como no protótipo
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Questão ${perguntaAtual + 1}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          pergunta['descricao'] ?? "Sem descrição",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Opções Likert (com bolinha roxa)
                  ...opcoesLikert.map((opcao) {
                    bool isSelected = respostaAtual == opcao['valor'];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _buildLikertButton(
                        texto: opcao['texto'],
                        valor: opcao['valor'],
                        isSelected: isSelected,
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
          
          // --- MUDANÇA 2: Botões do Rodapé (Roxos) ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            color: Colors.white, // Fundo branco
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomButton(
                    title: "Anterior",
                    backgroundColor: corRoxaClara, // Roxo
                    textColor: Colors.black,
                    onTap: perguntaAtual > 0 ? () => setState(() => perguntaAtual--) : null,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: CustomButton(
                    title: isUltimaPergunta ? "Finalizar" : "Avançar",
                    backgroundColor: corRoxaClara, // Roxo
                    textColor: Colors.black,
                    onTap: isUltimaPergunta
                           ? concluirQuestionario
                           : () => setState(() => perguntaAtual++),
                  ),
                ),
              ],
            ),
          ),
          
          // --- MUDANÇA 3: Barra Inferior Fixa (Roxa) ---
          Container(
            height: 30, // Altura da barra inferior
            color: corRoxaClara,
          )
        ],
      ),
    );
  }

  // --- MUDANÇA 4: AppBar simples (só a barra roxa) ---
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: corRoxaClara,
      elevation: 0,
      // Deixamos o botão de voltar padrão para o usuário não ficar preso
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      // Removemos o título e o 'bottom'
    );
  }

  // --- MUDANÇA 5: Widget da Barra de Progresso ---
  Widget _buildProgressBar(double progresso) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${(progresso * 100).toInt()}% Concluído",
            style: const TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progresso,
            backgroundColor: corRoxaClara, // Fundo roxo claro
            valueColor: AlwaysStoppedAnimation<Color>(corRoxaEscura), // Progresso roxo escuro
            minHeight: 15,
            borderRadius: BorderRadius.circular(10), // Arredondado como no protótipo
          ),
        ],
      ),
    );
  }


  Widget _buildLikertButton({
    required String texto, 
    required int valor, 
    required bool isSelected
  }) {
    // Este widget já estava correto (com a bolinha roxa)
    return InkWell(
      onTap: () => responder(valor),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? corRoxaEscura : Colors.grey[300]!,
            width: 2,
          ),
          boxShadow: isSelected ? [
            BoxShadow(color: corRoxaEscura.withOpacity(0.3), blurRadius: 6, offset: const Offset(0, 2))
          ] : [],
        ),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: isSelected ? corRoxaEscura : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: corRoxaEscura,
                  width: 2,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                texto,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? corRoxaEscura : Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}