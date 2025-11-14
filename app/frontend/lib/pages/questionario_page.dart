import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '/services/api_service.dart';

class QuestionarioPage extends StatefulWidget {
  const QuestionarioPage({super.key});

  @override
  State<QuestionarioPage> createState() => _QuestionarioPageState();
}

class _QuestionarioPageState extends State<QuestionarioPage> {
  final apiService = ApiService();
  List perguntas = [];
  Map<int, String> respostas = {}; 
  bool carregando = true;
  int perguntaAtual = 0;

  @override
  void initState() {
    super.initState();
    carregarPerguntas();
  }

  Future<void> carregarPerguntas() async {
    try {
      var dio = Dio();
      var response = await dio.get('http://localhost:8000/perguntas');
      setState(() {
        perguntas = response.data;
        carregando = false;
      });
    } catch (e) {
      print("Erro ao carregar perguntas: $e");
      setState(() => carregando = false);
    }
  }

  void responder(String resposta) {
    var perguntaId = perguntas[perguntaAtual]['id'];
    setState(() {
      respostas[perguntaId] = resposta;
    });
  }

  bool todasRespondidas() {
    return respostas.length == perguntas.length;
  }

  Future<void> concluirQuestionario() async {
  if (!todasRespondidas()) return;

  try {
    var dio = Dio();

    // Converter as chaves para String
    final respostasConvertidas = respostas.map((k, v) => MapEntry(k.toString(), v));

    await dio.post('http://localhost:8000/respostas', data: {
      "usuario_id": 1, // depois troca pelo id real do usuário
      "respostas": respostasConvertidas,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Respostas enviadas com sucesso!")),
    );

    Navigator.pop(context);
  } catch (e) {
    print("Erro ao enviar respostas: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Erro ao enviar respostas.")),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    if (carregando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (perguntas.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("Nenhuma pergunta disponível.")),
      );
    }

    var pergunta = perguntas[perguntaAtual];

    return Scaffold(
      appBar: AppBar(title: const Text('Questionário')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      pergunta['pergunta'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () => responder("Sim"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: respostas[pergunta['id']] == "Sim"
                                ? Colors.green
                                : Colors.grey[300],
                            foregroundColor: Colors.black,
                          ),
                          child: const Text("Sim"),
                        ),
                        ElevatedButton(
                          onPressed: () => responder("Não"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: respostas[pergunta['id']] == "Não"
                                ? Colors.red
                                : Colors.grey[300],
                            foregroundColor: Colors.black,
                          ),
                          child: const Text("Não"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (perguntaAtual > 0)
                  IconButton(
                    icon: const Icon(Icons.arrow_back, size: 32),
                    onPressed: () {
                      setState(() {
                        perguntaAtual--;
                      });
                    },
                  ),
                const SizedBox(width: 30),
                if (perguntaAtual < perguntas.length - 1)
                  IconButton(
                    icon: const Icon(Icons.arrow_forward, size: 32),
                    onPressed: () {
                      setState(() {
                        perguntaAtual++;
                      });
                    },
                  ),
              ],
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: todasRespondidas() ? concluirQuestionario : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: todasRespondidas() ? Colors.blue : Colors.grey[400],
              ),
              child: const Text(
                "Concluir Questionário",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
