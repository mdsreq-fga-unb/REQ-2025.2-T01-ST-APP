import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String baseUrl = "http://localhost:8000";

  String? accessToken;  // Armazena JWT
  String? usuarioTipo;  // Tipo do usuário (Colaborador/Gestor)
  int? usuarioId;       // ID do usuário

  Future<bool> cadastrarUsuario(
    String nome,
    String email,
    String password,
    String empresa,
    String cargo,
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
          "role": "Colaborador",  // Default: Colaborador
        }),
      );

      if (resposta.statusCode == 200 || resposta.statusCode == 201) {
        var body = jsonDecode(resposta.body);
        usuarioId = body["id"];  // Backend retorna o User com id
        usuarioTipo = body["role"] ?? "Colaborador";
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
      // Backend espera OAuth2PasswordRequestForm (form-data)
      var resposta = await http.post(
        url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {
          "username": email,    // OAuth2 usa 'username' (é o email aqui)
          "password": password,
        },
      );

      if (resposta.statusCode == 200) {
        var body = jsonDecode(resposta.body);
        accessToken = body["access_token"];  // Salva JWT
        
        // Agora busca os dados do usuário usando GET /me
        bool userInfoObtida = await _fetchUserInfo();
        if (!userInfoObtida) {
          // Se falhar ao obter info do usuário, não falha o login
          // mas usa default
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

  Future<bool> _fetchUserInfo() async {
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
          "Authorization": "Bearer $accessToken",  // Envia JWT no header
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
  }
}
