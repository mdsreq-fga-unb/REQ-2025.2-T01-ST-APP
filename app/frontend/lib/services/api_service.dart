import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String baseUrl = "http://localhost:8000";

  String? accessToken;  
  String? usuarioTipo;   
  int? usuarioId;        
  Map<String, dynamic>? userData; 

  Future<bool> cadastrarUsuario(
    String nome,
    String email,
    String password,
    String empresa,
    String cargo,
    String role,
  ) async {
    var url = Uri.parse("$baseUrl/auth/users");

    try {
      var resposta = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "nome": nome,
          "email": email,
          "password": password,
          "empresa": empresa,
          "cargo": cargo,
          "role": role,
        }),
      );

      if (resposta.statusCode == 200 || resposta.statusCode == 201) {
        var body = jsonDecode(resposta.body);
        usuarioId = body["id"];
        usuarioTipo = body["role"];
        userData = body;
        return true;
      }
      print("Erro cadastro: ${resposta.statusCode} - ${resposta.body}");
      return false;
    } catch (e) {
      print("Erro ao cadastrar: $e");
      return false;
    }
  }

  Future<bool> loginUsuario(String email, String password) async {
    var url = Uri.parse("$baseUrl/auth/token");

    try {
      var resposta = await http.post(
        url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {
          "username": email, 
          "password": password,
        },
      );

      if (resposta.statusCode == 200) {
        var body = jsonDecode(resposta.body);
        accessToken = body["access_token"];

        bool userInfoObtida = await fetchUserInfo();
        if (!userInfoObtida) {
          usuarioTipo ??= "Colaborador";
        }
        return true;
      }

      print("Erro login: ${resposta.statusCode} - ${resposta.body}");
      return false;
    } catch (e) {
      print("Erro ao fazer login: $e");
      return false;
    }
  }

  
  Future<bool> fetchUserInfo() async {
    if (accessToken == null) return false;

    var url = Uri.parse("$baseUrl/auth/me");

    try {
      var resposta = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $accessToken",
        },
      );

      if (resposta.statusCode == 200) {
        var user = jsonDecode(resposta.body);
        usuarioId = user["id"];
        usuarioTipo = user["role"] ?? "Colaborador";
        userData = user; 
        return true;
      }

      print("Erro ao buscar usuário: ${resposta.statusCode}");
      return false;
    } catch (e) {
      print("Erro ao buscar informações do usuário: $e");
      return false;
    }
  }

  Future<bool> enviarRespostas(Map<int, String> respostas) async {
    if (usuarioId == null || accessToken == null) return false;

    var url = Uri.parse("$baseUrl/respostas");

    try {
      var resposta = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
        body: jsonEncode({
          "usuario_id": usuarioId,
          "respostas": respostas,
        }),
      );

      return resposta.statusCode == 200 || resposta.statusCode == 201;
    } catch (e) {
      print("Erro ao enviar respostas: $e");
      return false;
    }
  }

  void logout() {
    accessToken = null;
    usuarioId = null;
    usuarioTipo = null;
    userData = null;
  }
}
