import 'package:flutter/material.dart';
import '/services/api_service.dart';

class PerfilPage extends StatefulWidget {
  final ApiService apiService;

  const PerfilPage({super.key, required this.apiService});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  late ApiService api;

  bool carregando = true;

  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final cargoController = TextEditingController();
  final idadeController = TextEditingController();
  final generoController = TextEditingController();
  final racaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    api = widget.apiService;
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    await api.fetchUserInfo();
    final user = api.userData;

    nomeController.text = user?["nome"] ?? "";
    emailController.text = user?["email"] ?? "";
    cargoController.text = user?["cargo"] ?? "";
    idadeController.text = user?["idade"]?.toString() ?? "";
    generoController.text = user?["genero"] ?? "";
    racaController.text = user?["raca"] ?? "";

    setState(() => carregando = false);
  }

  @override
  Widget build(BuildContext context) {
    if (carregando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 10),

            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEDEDED),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 70,
                    color: Colors.black,
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFCFA7FF),
                  ),
                  padding: const EdgeInsets.all(6),
                  child: const Icon(Icons.edit, size: 20),
                )
              ],
            ),

            const SizedBox(height: 10),

            Text(
              nomeController.text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              cargoController.text,
              style: const TextStyle(color: Colors.black54),
            ),

            const SizedBox(height: 30),

            _buildCampo("Nome", nomeController),
            const SizedBox(height: 15),

            _buildCampo("Email", emailController),
            const SizedBox(height: 15),

            _buildCampo("Cargo", cargoController),
            const SizedBox(height: 15),

            _buildCampo("Idade", idadeController),
            const SizedBox(height: 15),

            _buildCampo("Gênero", generoController),
            const SizedBox(height: 15),

            _buildCampo("Raça", racaController),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildCampo(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFCFA7FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: controller,
            enabled: false, 
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 14),
              border: InputBorder.none,
              suffixIcon: Icon(Icons.remove_red_eye_outlined, size: 20, color: Colors.black54),
            ),
          ),
        ),
      ],
    );
  }
}
