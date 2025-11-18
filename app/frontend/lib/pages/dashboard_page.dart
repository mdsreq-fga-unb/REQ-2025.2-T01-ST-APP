import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Map<String, dynamic> dashboard = {};
  bool carregando = true;

  // EXEMPLO → depois você integra com o sistema de autenticação
  final String userRole = "GESTOR"; // ou "RH"

  @override
  void initState() {
    super.initState();
    carregarDashboard();
  }

  Future<void> carregarDashboard() async {
    try {
      var dio = Dio();
      var response = await dio.get("http://localhost:8000/dashboard");

      setState(() {
        dashboard = response.data;
        carregando = false;
      });
    } catch (e) {
      print("Erro ao carregar dashboard: $e");
      setState(() => carregando = false);
    }
  }

  bool get userHasPermission =>
      userRole.toUpperCase() == "GESTOR" || userRole.toUpperCase() == "RH";

  @override
  Widget build(BuildContext context) {
    // 1 — Loading customizado
    if (carregando) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 12),
              Text("Carregando dados do dashboard..."),
            ],
          ),
        ),
      );
    }

    // 2 — Permissão
    if (!userHasPermission) {
      return const Scaffold(
        body: Center(
          child: Text(
            "Você não tem permissão para visualizar este dashboard.",
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    // 3 — Sem dados
    if (dashboard.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("Nenhum dado disponível.")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard do Gestor")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildResumoCard(),
            const SizedBox(height: 20),
            _buildBarChartCard(),
            const SizedBox(height: 20),
            _buildPieChartCard(),
            const SizedBox(height: 20),
            _buildListaDimensoes(),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // RESUMO GERAL
  // ============================================================

  Widget _buildResumoCard() {
    int totalPositivos = 0;
    int totalNegativos = 0;

    for (var item in dashboard.values) {
      totalPositivos += (item["positivo"] as num).toInt();
      totalNegativos += (item["negativo"] as num).toInt();

    }

    int total = totalPositivos + totalNegativos;
    double porcentagemPositiva = total == 0 ? 0 : (totalPositivos / total) * 100;

    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Visão Geral",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Total de respostas analisadas: $total",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 6),
            Text(
              "Favorabilidade geral: ${porcentagemPositiva.toStringAsFixed(1)}%",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // GRÁFICO DE BARRAS
  // ============================================================

  Widget _buildBarChartCard() {
    List<BarChartGroupData> barras = [];
    List<String> labels = dashboard.keys.toList();

    for (int i = 0; i < labels.length; i++) {
      var item = dashboard[labels[i]];
      int pos = item["positivo"];
      int neg = item["negativo"];
      double total = (pos + neg).toDouble();
      if (total == 0) total = 1;


      double porcentPos = (pos / total) * 100;

      barras.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: porcentPos,
              color: Colors.green,
              width: 24,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      );
    }

    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Distribuição por Dimensão (Barras)",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  maxY: 100,
                  gridData: FlGridData(show: true),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          int index = value.toInt();
                          if (index < 0 || index >= labels.length) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(labels[index]),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                  ),
                  barGroups: barras,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // GRÁFICO DE PIZZA
  // ============================================================

  Widget _buildPieChartCard() {
    int totalPositivos = 0;
    int totalNegativos = 0;

    for (var item in dashboard.values) {
      totalPositivos += (item["positivo"] as num).toInt();
      totalNegativos += (item["negativo"] as num).toInt();

    }

    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Distribuição Geral (Pizza)",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 220,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: [
                    PieChartSectionData(
                      color: Colors.green,
                      value: totalPositivos.toDouble(),
                      title: "${totalPositivos}P",
                    ),
                    PieChartSectionData(
                      color: Colors.red,
                      value: totalNegativos.toDouble(),
                      title: "${totalNegativos}N",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // LISTA DETALHADA (cards individuais)
  // ============================================================

  Widget _buildListaDimensoes() {
    return Column(
      children: dashboard.entries.map((entry) {
        String especie = entry.key;
        int positivo = entry.value["positivo"] ?? 0;
        int negativo = entry.value["negativo"] ?? 0;

        int total = positivo + negativo == 0 ? 1 : positivo + negativo;

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 10),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  especie,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text("Positivo: $positivo"),
                LinearProgressIndicator(
                  value: positivo / total,
                  color: Colors.green,
                  minHeight: 10,
                ),
                const SizedBox(height: 10),
                Text("Negativo: $negativo"),
                LinearProgressIndicator(
                  value: negativo / total,
                  color: Colors.red,
                  minHeight: 10,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
