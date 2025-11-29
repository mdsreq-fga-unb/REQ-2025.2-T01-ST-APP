import 'package:flutter/material.dart';
import '/services/api_service.dart';

class CadastroPage extends StatefulWidget {
  final String tipoUsuario;
  const CadastroPage({super.key, required this.tipoUsuario});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final empresaController = TextEditingController();
  final cargoController = TextEditingController();
  final senhaController = TextEditingController();
  final confirmaSenhaController = TextEditingController();
  
  String mensagem = "";
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _carregando = false;

  final apiService = ApiService();

  Future<void> fazerCadastro() async {
    // Validações básicas
    if (nomeController.text.isEmpty ||
        emailController.text.isEmpty ||
        empresaController.text.isEmpty ||
        cargoController.text.isEmpty ||
        senhaController.text.isEmpty ||
        confirmaSenhaController.text.isEmpty) {
      setState(() {
        mensagem = "Todos os campos são obrigatórios!";
      });
      return;
    }

    if (senhaController.text != confirmaSenhaController.text) {
      setState(() {
        mensagem = "As senhas não coincidem!";
      });
      return;
    }

    if (senhaController.text.length < 6) {
      setState(() {
        mensagem = "A senha deve ter no mínimo 6 caracteres!";
      });
      return;
    }

    setState(() {
      _carregando = true;
      mensagem = "";
    });

    bool sucesso = await apiService.cadastrarUsuario(
      nomeController.text,
      emailController.text,
      senhaController.text,
      empresaController.text,
      cargoController.text,
      widget.tipoUsuario,
    );

    setState(() {
      _carregando = false;
      if (sucesso) {
        mensagem = "Usuário cadastrado com sucesso!";
        // Aguarda um pouco e volta para a tela anterior
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pop(context);
        });
      } else {
        mensagem = "Erro ao cadastrar. Verifique os dados e tente novamente.";
      }
    });
  }

  @override
  void dispose() {
    nomeController.dispose();
    emailController.dispose();
    empresaController.dispose();
    cargoController.dispose();
    senhaController.dispose();
    confirmaSenhaController.dispose();
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
        title: const Text("Cadastro"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Estamos quase lá!!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFB74D),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "Com essas informações farei seu perfil",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 30),
            // Nome
            _buildInput("Nome Completo", nomeController),
            const SizedBox(height: 16),
            // Email
            _buildInput("Email", emailController, inputType: TextInputType.emailAddress),
            const SizedBox(height: 16),
            // Empresa
            _buildInput("Empresa", empresaController),
            const SizedBox(height: 16),
            // Cargo
            _buildInput("Cargo", cargoController),
            const SizedBox(height: 16),
            // Senha
            _buildPasswordInput("Senha", senhaController, _obscurePassword, (value) {
              setState(() {
                _obscurePassword = value;
              });
            }),
            const SizedBox(height: 16),
            // Confirmar Senha
            _buildPasswordInput("Confirmar Senha", confirmaSenhaController, _obscureConfirmPassword, (value) {
              setState(() {
                _obscureConfirmPassword = value;
              });
            }),
            const SizedBox(height: 30),
            // Botão Cadastrar
            _carregando
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFB74D),
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: fazerCadastro,
                    child: const Text(
                      "Cadastrar",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
            const SizedBox(height: 20),
            // Mensagem de feedback
            Text(
              mensagem,
              style: TextStyle(
                color: mensagem.contains("sucesso") ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(
    String label,
    TextEditingController controller, {
    TextInputType inputType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: const Color(0xFFCFA7FF),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildPasswordInput(
    String label,
    TextEditingController controller,
    bool obscure,
    Function(bool) onToggle,
  ) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: const Color(0xFFCFA7FF),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
          onPressed: () => onToggle(!obscure),
        ),
      ),
    );
  }
}
