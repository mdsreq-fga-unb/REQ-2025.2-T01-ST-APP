import 'package:flutter/material.dart';
import '/services/api_service.dart';

class HomePageColaborador extends StatefulWidget {
  final ApiService apiService;

  HomePageColaborador({super.key, ApiService? apiService})
      : apiService = apiService ?? ApiService();

  @override
  State<HomePageColaborador> createState() => _HomePageState();
}

class _HomePageState extends State<HomePageColaborador> {
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

    final nome = userData?["nome"] ?? "Usuário";
    final cargo = userData?["cargo"] ?? "Colaborador";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/pagina_usuario");
                    },
                    child: Row(
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
                              style:
                                  const TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications_none),
                        onPressed: () {},
                      ),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildMenuButton(
                      label: "Questionário\nDiagnóstico",
                      onTap: () {
                        Navigator.pushNamed(context, "/questionario");
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildMenuButton(
                      label: "Biblioteca",
                      onTap: () {},
                    ),
                    const SizedBox(height: 20),
                    _buildMenuButton(
                      label: "Recomendações\npersonalizadas",
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),

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

  Widget _buildMenuButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: 200,
      height: 80,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFB74D),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          elevation: 0,
        ),
        onPressed: onTap,
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
