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
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final apiService = ApiService();

  String mensagem = "";
  bool _obscurePassword = true;
  bool _carregando = false;

  Future<void> fazerLogin() async {
    if (emailController.text.isEmpty || senhaController.text.isEmpty) {
      setState(() => mensagem = "Email e senha são obrigatórios!");
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
        if (!mounted) return;

        if (widget.tipoUsuario == "Gestor") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => HomePageGestor(apiService: apiService),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => HomePageColaborador(apiService: apiService),
            ),
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
    const fieldSpacing = SizedBox(height: 18);

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

            _labelledTextField(
              label: "Insira seu e-mail:",
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
            ),

            fieldSpacing,

            _labelledPasswordField(
              label: "Insira sua senha:",
              controller: senhaController,
            ),

            const SizedBox(height: 20),

            TextButton(
              onPressed: () {},
              child: const Text("Esqueceu sua senha?"),
            ),

            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CadastroPage(tipoUsuario: widget.tipoUsuario),
                  ),
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
                      padding:
                          const EdgeInsets.symmetric(horizontal: 80, vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: fazerLogin,
                    child: const Text(
                      "Entrar",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

            const SizedBox(height: 20),

            Text(
              mensagem,
              style: TextStyle(
                color: mensagem.contains("bem") ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _labelledTextField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            filled: true,
            fillColor: const Color(0xFFCFA7FF),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _labelledPasswordField({
    required String label,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
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
        ),
      ],
    );
  }
}