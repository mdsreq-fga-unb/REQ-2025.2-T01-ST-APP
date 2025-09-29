import 'package:flutter/material.dart';
import '/services/api_service.dart';
import 'home_page.dart';
import 'dashboard_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  String mensagem = "";

  final apiService = ApiService();

  Future<void> fazerLogin() async {
    bool sucesso = await apiService.loginUsuario(emailController.text, senhaController.text);

    setState(() {
      mensagem = sucesso ? "Login bem-sucedido." : "Erro ao fazer login.";
    });

    if (sucesso) {
      if (apiService.usuarioTipo == "gestor") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardPage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: InputDecoration(labelText: "E-mail")),
            TextField(controller: senhaController, decoration: InputDecoration(labelText: "Senha"), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(onPressed: fazerLogin, child: Text("Entrar")),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, "/cadastro");
              },
              child: Text("Não tem conta? Cadastre-se"),
            ),
            SizedBox(height: 20),
            Text(mensagem, style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
