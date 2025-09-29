import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/cadastro_page.dart';
import 'pages/home_page.dart';
import 'pages/questionario_page.dart';
import 'pages/dashboard_page.dart'; // <-- novo

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const LoginPage(),
    routes: {
      "/cadastro": (context) => const CadastroPage(),
      "/home": (context) => const HomePage(),
      "/questionario": (context) => const QuestionarioPage(),
      "/dashboard": (context) => const DashboardPage(), // <-- nova rota
    },
  ));
}
