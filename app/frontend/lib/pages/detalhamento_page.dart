import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '/services/api_service.dart';

class DetalhamentoPage extends StatefulWidget {
  final String tema;
  final ApiService apiService;

  DetalhamentoPage({Key? key, required this.tema, ApiService? apiService})
      : apiService = apiService ?? ApiService(),
        super(key: key);

  @override
  State<DetalhamentoPage> createState() => _DetalhamentoPageState();
}

class _DetalhamentoPageState extends State<DetalhamentoPage> {
  bool carregando = true;
  List<int> valores = [0, 0, 0, 0, 0];
  List<double> percentuais = [0.0, 0.0, 0.0, 0.0, 0.0];
  List<String> labels = const [
    "Concordo totalmente",
    "Concordo parcialmente",
    "Nem concordo nem discordo",
    "Discordo parcialmente",
    "Discordo totalmente",
  ];
  double scorePercent = 0.0;
  int totalVotos = 0;

  @override
  void initState() {
    super.initState();
    _carregarResultados();
  }

  Future<void> _carregarResultados() async {
    try {
      final resultados = await widget.apiService.getResultadosPorTema(widget.tema);

    
      valores = [0, 0, 0, 0, 0];
      percentuais = [0.0, 0.0, 0.0, 0.0, 0.0];
      totalVotos = 0;
      int somaPonderada = 0;

      for (var r in resultados) {
        final voto = r['voto_valor'] is int ? r['voto_valor'] as int : int.parse(r['voto_valor'].toString());
        final total = r['total_votos'] as int;
        final index = 5 - voto;
        if (index >= 0 && index < valores.length) {
          valores[index] = total;
          totalVotos += total;
          somaPonderada += voto * total;
        }
      }

      if (totalVotos > 0) {
        for (int i = 0; i < percentuais.length; i++) {
          percentuais[i] = (valores[i] / totalVotos) * 100;
        }
        final mediaVotos = somaPonderada / totalVotos; 
        scorePercent = (mediaVotos / 5.0) * 100;
      }

      setState(() {
        carregando = false;
      });
    } catch (e) {
      print('Erro ao carregar resultados detalhados: $e');
      setState(() => carregando = false);
    }
  }
  @override
  Widget build(BuildContext context) {
    if (carregando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),

              const SizedBox(height: 8),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.tema,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text("${scorePercent.toStringAsFixed(1)}%"),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: LinearProgressIndicator(
                        value: scorePercent / 100.0,
                        minHeight: 10,
                        backgroundColor: Colors.grey.shade300,
                        color: scorePercent >= 75
                            ? Colors.green
                            : scorePercent >= 50
                                ? Colors.yellow[700]
                                : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              const Text(
                "Respostas por Categoria",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Container(
                height: 300,
                padding: const EdgeInsets.all(8),
                child: CategoriaBarChart(
                  values: percentuais,
                  labels: labels,
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                "Análise Completa",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Para a análise completa pergunta por pergunta por escrito em PDF",
                style: TextStyle(fontSize: 14),
              ),

              const SizedBox(height: 20),

              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffB7E34C),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 36, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () async {
                    try {
                      final path = await widget.apiService.downloadRelatorioPdf(widget.tema);
                      if (path != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('PDF salvo em: $path')),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Erro ao baixar PDF')),
                      );
                    }
                  },
                  child: const Text(
                    "Baixar",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}


class CategoriaBarChart extends StatelessWidget {
  final List<double> values;
  final List<String> labels;

  const CategoriaBarChart({
    super.key,
    required this.values,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    final maxValue =
        values.reduce((a, b) => a > b ? a : b) + 10; 

    return BarChart(
      BarChartData(
        maxY: maxValue,
        barTouchData: BarTouchData(enabled: true),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),

        titlesData: FlTitlesData(
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),

          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 38,
              interval: 20,
              getTitlesWidget: (value, meta) {
                return Text(
                  "${value.toInt()}%",
                  style: const TextStyle(fontSize: 10),
                );
              },
            ),
          ),

          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (index, meta) {
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Transform.rotate(
                    angle: -0.7,
                    child: Text(
                      labels[index.toInt()],
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 10),
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        barGroups: List.generate(values.length, (i) {
          final color = _getColor(i);

          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: values[i],
                width: 22,
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          );
        }),
      ),
    );
  }

  Color _getColor(int index) {
    switch (index) {
      case 0:
        return Colors.green.shade700;
      case 1:
        return Colors.green.shade500;
      case 2:
        return Colors.yellow.shade700;
      case 3:
        return Colors.orange.shade400;
      case 4:
        return Colors.red.shade400;
      default:
        return Colors.grey;
    }
  }
}
