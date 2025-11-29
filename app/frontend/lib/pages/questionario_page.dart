import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widget/custom_button.dart';
import '../widget/confirmation_dialog.dart'; 

class QuestionarioPage extends StatefulWidget {
  const QuestionarioPage({super.key});

  @override
  State<QuestionarioPage> createState() => _QuestionarioPageState();
}

class _QuestionarioPageState extends State<QuestionarioPage> {
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
    print("DEBUG - Iniciando carregamento de perguntas");
    print("DEBUG - AccessToken: ${apiService.accessToken}");
    print("DEBUG - UsuarioId: ${apiService.usuarioId}");
    
    List dados = await apiService.getPerguntas();
  
    
    setState(() {
      perguntas = dados;
      carregando = false;
    });
  } catch (e) {
    print("Erro ao carregar perguntas: $e");
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
    print("DEBUG - Nem todas as perguntas foram respondidas");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.red,
        content: Text("Por favor, responda todas as perguntas."),
      ),
    );
    return;
  }

  print("DEBUG - Todas as perguntas respondidas, respostas: $respostas");

  final bool? confirmar = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return const ConfirmationDialog(); 
    },
  );

  if (confirmar != true) {
    print("DEBUG - Usuário cancelou o envio");
    return;
  }

  try {
    print("DEBUG - Enviando respostas para o backend...");
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Enviando respostas..."),
            ],
          ),
        );
      },
    );

    bool sucesso = await apiService.enviarRespostas(respostas);
    
    if (mounted) Navigator.of(context).pop();

    print("DEBUG - Resultado do envio: $sucesso");
    
    if (sucesso && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green, 
          content: Text("Respostas enviadas com sucesso!"),
          duration: Duration(seconds: 2),
        ),
      );
      
      await Future.delayed(const Duration(seconds: 1));
      
      Navigator.pushNamedAndRemoveUntil(
        context, 
        "/home_colaborador", 
        (route) => false
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Algumas respostas não foram salvas. Verifique sua conexão."),
        ),
      );
    }
  } catch (e) {
    if (mounted) Navigator.of(context).pop();
    
    print("Erro envio: $e");
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Erro ao enviar respostas. Tente novamente."),
        ),
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    double progresso = 0;
    if (perguntas.isNotEmpty) {
      progresso = respostas.length / perguntas.length;
    }

    if (carregando) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(), 
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
      appBar: _buildAppBar(), 
      body: Column(
        children: [
          _buildProgressBar(progresso),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    decoration: BoxDecoration(
                      color: corLaranja, 
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
          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            color: Colors.white, 
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomButton(
                    title: "Anterior",
                    backgroundColor: corRoxaClara, 
                    textColor: Colors.black,
                    onTap: perguntaAtual > 0 ? () => setState(() => perguntaAtual--) : null,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: CustomButton(
                    title: isUltimaPergunta ? "Finalizar" : "Avançar",
                    backgroundColor: corRoxaClara, 
                    textColor: Colors.black,
                    onTap: isUltimaPergunta
                           ? concluirQuestionario
                           : () => setState(() => perguntaAtual++),
                  ),
                ),
              ],
            ),
          ),
          
          Container(
            height: 30, 
            color: corRoxaClara,
          )
        ],
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
    );
  }

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
            backgroundColor: corRoxaClara, 
            valueColor: AlwaysStoppedAnimation<Color>(corRoxaEscura), 
            minHeight: 15,
            borderRadius: BorderRadius.circular(10), 
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