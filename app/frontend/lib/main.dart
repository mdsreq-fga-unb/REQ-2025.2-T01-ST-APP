import 'package:flutter/material.dart';
import 'pages/cadastro_page.dart';
import 'pages/home_colaborador_page.dart';
import 'pages/questionario_page.dart';
import 'pages/dashboard_page.dart';
import 'pages/tipo_usuario_page.dart';
import 'pages/home_gestor_page.dart';
import 'pages/inicio_page.dart';
import 'pages/pesquisa_sociodemografica_page.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const InicioPage(),

    // ROTAS ESTÁTICAS
    routes: {
      "/tipo_usuario": (context) => const TipoUsuarioPage(),
      "/home_colaborador": (context) => HomePageColaborador(),
      "/home_gestor": (context) => HomePageGestor(),
      "/questionario": (context) => const QuestionarioPage(),
      "/dashboard": (context) => const DashboardPage(),
    },

    // ROTAS DINÂMICAS
    onGenerateRoute: (settings) {
      switch (settings.name) {

        case "/cadastro":
          final tipoUsuario = settings.arguments as String?;
          if (tipoUsuario == null || tipoUsuario.isEmpty) {
            return _erroRota(
                "Tipo de usuário não informado ao abrir CadastroPage.");
          }
          return MaterialPageRoute(
            builder: (_) => CadastroPage(tipoUsuario: tipoUsuario),
          );

        case "/pesquisa_sociodemografica":
          final tipoUsuario = settings.arguments as String?;
          if (tipoUsuario == null || tipoUsuario.isEmpty) {
            return _erroRota(
                "Tipo de usuário não informado ao abrir Pesquisa Sociodemográfica.");
          }
          return MaterialPageRoute(
            builder: (_) => PesquisaSociodemograficaPage(
              tipoUsuario: tipoUsuario,
            ),
          );

        default:
          return null;
      }
    },
  ));
}

// ===== FUNÇÃO DE TELA DE ERRO PARA ROTAS MAL CHAMADAS =====

Route _erroRota(String msg) {
  return MaterialPageRoute(
    builder: (_) => Scaffold(
      appBar: AppBar(title: const Text("Erro de Rota")),
      body: Center(
        child: Text(
          msg,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, color: Colors.red),
        ),
      ),
    ),
  );
}
