import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '/services/api_service.dart';
import 'package:intl/intl.dart';

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
    "Sempre",
    "Frequentemente",
    "Às vezes",
    "Raramente",
    "Nunca",
  ];
  double scorePercent = 0.0;
  int totalVotos = 0;

  DateTimeRange? _periodoSelecionado;

  @override
  void initState() {
    super.initState();
    _carregarResultados();
  }

  // --- MUDANÇA 1: Ao selecionar data, recarrega os dados ---
  Future<void> _selecionarData() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _periodoSelecionado,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xFFFFB74D),
            colorScheme: const ColorScheme.light(primary: Color(0xFFFFB74D)),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _periodoSelecionado) {
      setState(() {
        _periodoSelecionado = picked;
        carregando = true; // Mostra loading
      });
      // AQUI: Chama a função que busca no backend com o novo filtro
      await _carregarResultados();
    }
  }

  // --- MUDANÇA 2: Ao limpar, recarrega tudo ---
  void _limparFiltroData() {
    setState(() {
      _periodoSelecionado = null;
      carregando = true;
    });
    _carregarResultados();
  }

  // --- MUDANÇA 3: Passa as datas para a API ---
  Future<void> _carregarResultados() async {
    try {
      String? dataInicio;
      String? dataFim;

      // Se o usuário selecionou uma data, formatamos para enviar
      if (_periodoSelecionado != null) {
        dataInicio =
            DateFormat('yyyy-MM-dd').format(_periodoSelecionado!.start);
        dataFim = DateFormat('yyyy-MM-dd').format(_periodoSelecionado!.end);
      }

      // Chama a API passando as datas opcionais
      // Isso afetará os gráficos e o Score percentual
      final resultados = await widget.apiService.getResultadosPorTema(
        widget.tema,
        dataInicio: dataInicio,
        dataFim: dataFim,
      );

      valores = [0, 0, 0, 0, 0];
      percentuais = [0.0, 0.0, 0.0, 0.0, 0.0];
      totalVotos = 0;
      int somaPonderada = 0;

      for (var r in resultados) {
        final voto = r['voto_valor'] is int
            ? r['voto_valor'] as int
            : int.parse(r['voto_valor'].toString());
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
      } else {
        scorePercent = 0.0;
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

              // Card do Score
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
                    // Texto dinâmico
                    Text(
                      _periodoSelecionado == null
                          ? "${scorePercent.toStringAsFixed(1)}% (Histórico Geral)"
                          : "${scorePercent.toStringAsFixed(1)}% (Período Selecionado)",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800]
                      ),
                    ),
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

              const SizedBox(height: 20),

              // --- Seletor de Data ---
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_month, 
                        color: Colors.blueGrey, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Período de Análise",
                            style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _periodoSelecionado == null
                                ? "Todo o histórico"
                                : "${DateFormat('dd/MM/yy').format(_periodoSelecionado!.start)} - ${DateFormat('dd/MM/yy').format(_periodoSelecionado!.end)}",
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    if (_periodoSelecionado != null)
                      IconButton(
                        icon: const Icon(Icons.close,
                            color: Colors.grey, size: 20),
                        onPressed: _limparFiltroData,
                      ),
                    TextButton(
                      onPressed: _selecionarData,
                      child: Text(
                        "Alterar",
                        style: TextStyle(
                            color: Colors.orange[800],
                            fontWeight: FontWeight.bold),
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
                "Baixar relatório detalhado (respeita o filtro de data acima)",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 20),

              // --- Botão de Download ---
              Center(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffB7E34C),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 36, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  icon: const Icon(Icons.download),
                  onPressed: () async {
                    try {
                      String? dataInicio;
                      String? dataFim;

                      if (_periodoSelecionado != null) {
                        dataInicio = DateFormat('yyyy-MM-dd')
                            .format(_periodoSelecionado!.start);
                        dataFim = DateFormat('yyyy-MM-dd')
                            .format(_periodoSelecionado!.end);
                      }

                      final path = await widget.apiService.downloadRelatorioPdf(
                        widget.tema,
                        dataInicio: dataInicio,
                        dataFim: dataFim,
                      );

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
                  label: const Text(
                    "Baixar PDF",
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

// Widget do Gráfico (Mantido)
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
    final double maxValue = values.isEmpty 
        ? 100 
        : (values.reduce((a, b) => a > b ? a : b) + 10);

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
                if (index < 0 || index >= labels.length) return const SizedBox();
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