import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String baseUrl = "http://localhost:8000";

  int? usuarioId; 
  String? usuarioTipo; // <-- novo: tipo do usuário (contribuidor/gestor)

  Future<bool> cadastrarUsuario(String nome, String email, String senha) async {
    var url = Uri.parse("$baseUrl/cadastro");
    var resposta = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"nome": nome, "email": email, "senha": senha}),
    );

    if (resposta.statusCode == 201) {
      var body = jsonDecode(resposta.body);
      usuarioId = body["usuario_id"];
      usuarioTipo = body["tipo"]; // <-- salva o tipo retornado pelo backend
      return true;
    }
    return false;
  }

  Future<bool> loginUsuario(String email, String senha) async {
    var url = Uri.parse("$baseUrl/login");
    var resposta = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "senha": senha}),
    );

    if (resposta.statusCode == 200) {
      var body = jsonDecode(resposta.body);
      usuarioId = body["usuario_id"];
      usuarioTipo = body["tipo"]; // <-- salva o tipo retornado pelo backend
      return true;
    }
    return false;
  }

  Future<bool> enviarRespostas(Map<int, String> respostas) async {
    if (usuarioId == null) return false;

    var url = Uri.parse("$baseUrl/respostas");
    var resposta = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "usuario_id": usuarioId,
        "respostas": respostas,
      }),
    );

    return resposta.statusCode == 200;
  }
}
