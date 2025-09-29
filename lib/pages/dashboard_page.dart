import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Map<String, dynamic> dashboard = {};
  bool carregando = true;

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

  @override
  Widget build(BuildContext context) {
    if (carregando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (dashboard.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("Nenhum dado disponível.")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard do Gestor")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: dashboard.entries.map((entry) {
          String especie = entry.key;
          int positivo = entry.value["positivo"] ?? 0;
          int negativo = entry.value["negativo"] ?? 0;

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 10),
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
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text("Positivo: $positivo"),
                            LinearProgressIndicator(
                              value: positivo / (positivo + negativo == 0 ? 1 : positivo + negativo),
                              color: Colors.green,
                              minHeight: 10,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          children: [
                            Text("Negativo: $negativo"),
                            LinearProgressIndicator(
                              value: negativo / (positivo + negativo == 0 ? 1 : positivo + negativo),
                              color: Colors.red,
                              minHeight: 10,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
