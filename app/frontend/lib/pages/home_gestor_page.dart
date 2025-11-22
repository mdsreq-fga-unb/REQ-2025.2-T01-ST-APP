import 'package:flutter/material.dart';
import '/services/api_service.dart';

class HomePageGestor extends StatefulWidget {
  final ApiService apiService;

  HomePageGestor({super.key, ApiService? apiService})
      : apiService = apiService ?? ApiService();

  @override
  State<HomePageGestor> createState() => _HomePageGestorState();
}

class _HomePageGestorState extends State<HomePageGestor> {
  late ApiService apiService;
  Map<String, dynamic>? userData;
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    apiService = widget.apiService;

    if (apiService.userData != null) {
      userData = apiService.userData;
      carregando = false;
    } else {
      _carregarUsuario();
    }
  }

  Future<void> _carregarUsuario() async {
    try {
      bool ok = await apiService.fetchUserInfo();
      if (ok) {
        setState(() {
          userData = apiService.userData;
          carregando = false;
        });
      } else {
        setState(() => carregando = false);
      }
    } catch (e) {
      print("Erro ao carregar usuário: $e");
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

    final nome = userData?["nome"] ?? "Gestor";
    final cargo = userData?["cargo"] ?? "Gestor";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Tela Principal - Gestor",
          style: TextStyle(color: Colors.black54, fontSize: 16),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 20,
                        backgroundColor: Color(0xFFEDEDED),
                        child: Icon(Icons.person, color: Colors.black),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nome,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            cargo,
                            style: const TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_none),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 🔸 Botões em 2 linhas de 2
            Expanded(
              child: Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 25, // espaço entre colunas
                  runSpacing: 25, // espaço entre linhas
                  children: [
                    _buildMenuButton("Minha equipe", onTap: () {}),
                    _buildMenuButton("Dashboard", onTap: () {}),
                    _buildMenuButton("Plano de ação", onTap: () {}),
                    _buildMenuButton("Biblioteca", onTap: () {}),
                  ],
                ),
              ),
            ),

            // Barra inferior
            Container(
              height: 20,
              width: double.infinity,
              color: const Color(0xFFCFA7FF),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(String label, {required VoidCallback onTap}) {
    return SizedBox(
      width: 150, // define largura fixa (faz quebrar em 2 colunas)
      height: 65,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFB74D),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(10),
          elevation: 0,
        ),
        onPressed: onTap,
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
