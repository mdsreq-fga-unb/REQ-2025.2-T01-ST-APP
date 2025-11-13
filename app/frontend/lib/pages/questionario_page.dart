import 'package:flutter/material.dart';
import 'dart:convert'; // Para o jsonEncode se precisar
import '../services/api_service.dart';
import '../widget/custom_button.dart'; // Caminho corrigido (widget no singular)

class QuestionarioPage extends StatefulWidget {
  const QuestionarioPage({super.key});

  @override
  State<QuestionarioPage> createState() => _QuestionarioPageState();
}

class _QuestionarioPageState extends State<QuestionarioPage> {
  final Color corRoxaClara = const Color(0xFFCFA7FF);
  final Color corLaranja = const Color(0xFFFFB74D);

  final apiService = ApiService();
  List perguntas = [];
  
  // Mapa de respostas: ID da Pergunta (int) -> Valor Likert (int)
  Map<int, int> respostas = {}; 
  
  bool carregando = true;
  int perguntaAtual = 0;

  final List<Map<String, dynamic>> opcoesLikert = [
    {'texto': 'Concordo Totalmente', 'valor': 5, 'cor': Colors.green[700]},
    {'texto': 'Concordo Parcialmente', 'valor': 4, 'cor': Colors.lightGreen},
    {'texto': 'Nem Concordo Nem Discordo', 'valor': 3, 'cor': Colors.grey},
    {'texto': 'Discordo Parcialmente', 'valor': 2, 'cor': Colors.orangeAccent},
    {'texto': 'Discordo Totalmente', 'valor': 1, 'cor': Colors.redAccent},
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
    
    // Avança automaticamente se não for a última pergunta
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
            content: Text("Por favor, responda todas as perguntas antes de finalizar."),
          ),
       );
       return;
    }

    try {
      // Converte para o formato esperado pelo backend
      final respostasConvertidas = respostas.map((k, v) => MapEntry(k, v)); // Mantém int e int
      
      await apiService.enviarRespostas(respostasConvertidas);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(backgroundColor: Colors.green, content: Text("Questionário enviado com sucesso!")),
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
    if (carregando) {
      return Scaffold(backgroundColor: Colors.white, body: Center(child: CircularProgressIndicator(color: corLaranja)));
    }

    if (perguntas.isEmpty) {
      return Scaffold(appBar: _buildAppBar(), body: const Center(child: Text("Nenhuma pergunta disponível.")));
    }

    var pergunta = perguntas[perguntaAtual];
    var idPergunta = pergunta['id'];
    var respostaAtual = respostas[idPergunta];

    // Verifica se é a última pergunta para mostrar o botão de finalizar
    bool isUltimaPergunta = perguntaAtual == perguntas.length - 1;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Contador
            Text(
              "Questão ${perguntaAtual + 1} de ${perguntas.length}",
              style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Card da Pergunta
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: corRoxaClara, 
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                pergunta['descricao'] ?? "Sem descrição",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
            
            const SizedBox(height: 20),

            // Opções Likert
            ...opcoesLikert.map((opcao) {
              bool isSelected = respostaAtual == opcao['valor'];
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _buildLikertButton(
                  texto: opcao['texto'],
                  valor: opcao['valor'],
                  corBase: opcao['cor'],
                  isSelected: isSelected,
                ),
              );
            }).toList(),

            const SizedBox(height: 30),

            // --- ÁREA DE NAVEGAÇÃO ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Botão Voltar (Seta Esquerda)
                _buildNavButton(
                  icon: Icons.arrow_back,
                  // Só ativa se não for a primeira pergunta
                  onTap: perguntaAtual > 0 ? () => setState(() => perguntaAtual--) : null,
                ),

                // Texto indicador de progresso (opcional, ajuda visualmente)
                Text(
                  "${((respostas.length / perguntas.length) * 100).toInt()}% Completo",
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),

                // Botão Avançar (Seta Direita)
                // Só ativa se não for a última pergunta
                _buildNavButton(
                  icon: Icons.arrow_forward,
                  onTap: !isUltimaPergunta ? () => setState(() => perguntaAtual++) : null,
                ),
              ],
            ),

            const SizedBox(height: 30),

            // --- BOTÃO FINALIZAR (Só aparece na última pergunta) ---
            if (isUltimaPergunta)
              CustomButton(
                title: "Finalizar Questionário",
                // Se não respondeu tudo, fica cinza. Se respondeu, fica Laranja.
                backgroundColor: todasRespondidas() ? corLaranja : Colors.grey[300],
                textColor: todasRespondidas() ? Colors.black : Colors.grey[600],
                onTap: concluirQuestionario,
              ),
              
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: corRoxaClara,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text("Avaliação", style: TextStyle(color: Colors.black)),
    );
  }

  Widget _buildNavButton({required IconData icon, VoidCallback? onTap}) {
    // Se onTap for null, o botão fica visualmente desabilitado (cinza claro)
    bool isDisabled = onTap == null;
    
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: isDisabled ? Colors.grey[200] : corLaranja,
        foregroundColor: isDisabled ? Colors.grey[400] : Colors.black,
        elevation: isDisabled ? 0 : 2,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(16),
      ),
      child: Icon(icon, size: 30),
    );
  }

  Widget _buildLikertButton({
    required String texto, 
    required int valor, 
    required Color corBase, 
    required bool isSelected
  }) {
    return InkWell(
      onTap: () => responder(valor),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? corBase : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? corBase : Colors.grey[300]!,
            width: 2,
          ),
          boxShadow: isSelected ? [
            BoxShadow(color: corBase.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4))
          ] : [],
        ),
        child: Row(
          children: [
            Container(
              width: 16, height: 16,
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : corBase,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                texto,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
            ),
            if (isSelected) const Icon(Icons.check, color: Colors.white),
          ],
        ),
      ),
    );
  }
}