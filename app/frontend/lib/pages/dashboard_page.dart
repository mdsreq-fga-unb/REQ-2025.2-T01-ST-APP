import 'package:flutter/material.dart';
import '/services/api_service.dart';
import 'detalhamento_page.dart';

class DashboardPage extends StatefulWidget {
  final ApiService apiService;

  DashboardPage({Key? key, ApiService? apiService})
      : apiService = apiService ?? ApiService(),
        super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final List<Map<String, dynamic>> indicadores = [];
  bool carregando = true;
  double _scoreGeral = 0.0;

  @override
  void initState() {
    super.initState();
    _carregarTemas();
  }

  Future<void> _carregarTemas() async {
    try {
      final perguntas = await widget.apiService.getPerguntas();

      final temas = <String>{};
      for (var p in perguntas) {
        if (p is Map && p.containsKey('tema')) temas.add(p['tema']);
      }

      final List<Map<String, dynamic>> novos = [];
      double somaTotal = 0.0;

      for (var tema in temas) {
        try {
          final resultados = await widget.apiService.getResultadosPorTema(tema);

          int totalVotos = 0;
          int somaPonderada = 0;

          for (var r in resultados) {
            final voto = r['voto_valor'] is int
                ? r['voto_valor'] as int
                : int.parse(r['voto_valor'].toString());
            final total = r['total_votos'] as int;

            totalVotos += total;
            somaPonderada += voto * total;
          }

          double valor = 0.0;
          if (totalVotos > 0) {
            final avg = somaPonderada / totalVotos;
            valor = avg / 5.0;
          }

          somaTotal += valor;
          novos.add({"titulo": tema, "valor": valor});
        } catch (e) {
          print('Erro ao calcular tema $tema: $e');
        }
      }

      setState(() {
        indicadores.clear();
        indicadores.addAll(novos);
        _scoreGeral = novos.isEmpty ? 0.0 : somaTotal / novos.length;
        carregando = false;
      });
    } catch (e) {
      print('Erro ao carregar temas: $e');
      setState(() => carregando = false);
    }
  }

  Color _corPorValor(double valor) {
    if (valor >= 0.75) return Colors.green;
    if (valor >= 0.50) return Colors.yellow[700]!;
    return Colors.red;
  }

  String _classificacaoPorValor(double valor) {
    if (valor >= 0.80) return "Excelente";
    if (valor >= 0.60) return "Bom";
    if (valor >= 0.40) return "Regular";
    return "Necessita Atenção";
  }

  @override
  Widget build(BuildContext context) {
    if (carregando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),

                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back, color: Colors.black),
                ),

                const SizedBox(height: 20),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Score Geral",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${(_scoreGeral * 100).round()}% - ${_classificacaoPorValor(_scoreGeral)}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: _scoreGeral,
                        minHeight: 14,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _corPorValor(_scoreGeral),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                Column(
                  children: indicadores
                      .map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetalhamentoPage(
                                    tema: item['titulo'],
                                    apiService: widget.apiService,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item["titulo"],
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "${(item["valor"] * 100).round()}%",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: _corPorValor(item["valor"]),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 8),

                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: LinearProgressIndicator(
                                      value: item["valor"],
                                      minHeight: 8,
                                      backgroundColor: Colors.grey.shade300,
                                      valueColor:
                                          AlwaysStoppedAnimation<Color>(
                                        _corPorValor(item["valor"]),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
