import 'package:flutter/material.dart';
import '/services/api_service.dart';
import 'cadastro_page.dart';
import 'home_colaborador_page.dart';
import 'home_gestor_page.dart';

class LoginPage extends StatefulWidget {
  final String tipoUsuario;
  const LoginPage({super.key, required this.tipoUsuario});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final apiService = ApiService();
  String mensagem = "";
  bool _obscurePassword = true;
  bool _carregando = false;

  Future<void> fazerLogin() async {
    if (emailController.text.isEmpty || senhaController.text.isEmpty) {
      setState(() {
        mensagem = "Email e senha são obrigatórios!";
      });
      return;
    }

    setState(() {
      _carregando = true;
      mensagem = "";
    });

    bool sucesso = await apiService.loginUsuario(
      emailController.text,
      senhaController.text,
    );

    setState(() {
      _carregando = false;
      mensagem = sucesso ? "Login bem-sucedido." : "Email ou senha incorretos.";
    });

    if (sucesso) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (widget.tipoUsuario == "gestor") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => HomePageGestor(apiService: apiService)),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => HomePageColaborador(apiService: apiService)),
          );
        }
      });
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFCFA7FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
        child: Column(
          children: [
            const Text(
              "GenT",
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              "Entre na sua conta",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 30),
            _buildTextField("Insira seu e-mail:", emailController, TextInputType.emailAddress),
            const SizedBox(height: 16),
            _buildPasswordField("Insira sua senha:", senhaController),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
              },
              child: const Text("Esqueceu sua senha?"),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CadastroPage()),
                );
              },
              child: const Text("Ainda não possui conta?"),
            ),
            const SizedBox(height: 20),
            _carregando
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFB74D),
                      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: fazerLogin,
                    child: const Text(
                      "Entrar",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
            const SizedBox(height: 20),
            Text(
              mensagem,
              style: TextStyle(
                color: mensagem.contains("bem-sucedido") ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    TextInputType inputType,
  ) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black),
        filled: true,
        fillColor: const Color(0xFFCFA7FF),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildPasswordField(
    String label,
    TextEditingController controller,
  ) {
    return TextField(
      controller: controller,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black),
        filled: true,
        fillColor: const Color(0xFFCFA7FF),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
      ),
    );
  }
}
