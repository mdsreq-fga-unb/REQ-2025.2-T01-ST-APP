import 'package:flutter/material.dart';
import 'pages/cadastro_page.dart';
import 'pages/home_colaborador_page.dart';
import 'pages/questionario_page.dart';
import 'pages/dashboard_page.dart';
import 'pages/tipo_usuario_page.dart';
import 'pages/home_gestor_page.dart';
import 'pages/inicio_page.dart'; 

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const InicioPage(),
    routes: {
      "/tipo_usuario": (context) => const TipoUsuarioPage(),
      "/cadastro": (context) => const CadastroPage(),
      "/home_colaborador": (context) => HomePageColaborador(),
      "/home_gestor": (context) => HomePageGestor(),
      "/questionario": (context) => const QuestionarioPage(),
      "/dashboard": (context) => const DashboardPage(), 
    },
  ));
}
