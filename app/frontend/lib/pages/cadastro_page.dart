import 'package:flutter/material.dart';
import '/services/api_service.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  String mensagem = "";

  final apiService = ApiService();

  Future<void> fazerCadastro() async {
    bool sucesso = await apiService.cadastrarUsuario(
      nomeController.text,
      emailController.text,
      senhaController.text,
    );

    setState(() {
      mensagem = sucesso ? "Usuário cadastrado com sucesso." : "Erro ao cadastrar usuário.";
    });

    if (sucesso) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cadastro")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: nomeController, decoration: InputDecoration(labelText: "Nome")),
            TextField(controller: emailController, decoration: InputDecoration(labelText: "E-mail")),
            TextField(controller: senhaController, decoration: InputDecoration(labelText: "Senha"), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(onPressed: fazerCadastro, child: Text("Cadastrar")),
            SizedBox(height: 20),
            Text(mensagem, style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
