import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  // Singleton instance so pages share the same ApiService state (usuarioId, tokens, etc.)
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();
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
        print("DEBUG - Resposta do cadastro: $body");
        // Tenta extrair ID de múltiplas chaves possíveis
        usuarioId = body["id"] ?? body["user_id"] ?? body["userId"];
        usuarioTipo = body["role"] ?? "Colaborador";
        userData = body;
        print("DEBUG - usuarioId extraído: $usuarioId");
        // Tenta logar automaticamente para obter token (necessário para enviar a pesquisa)
        try {
          await loginUsuario(email, password);
        } catch (e) {
          print("Aviso: login automático após cadastro falhou: $e");
        }
        return true;
      }
      print("Erro cadastro: ${resposta.statusCode} - ${resposta.body}");
      return false;
    } catch (e) {
      print("Erro ao cadastrar: $e");
      return false;
    }
  }

  Future<bool> enviarPesquisaSociodemografica({
    required int idade,
    required String genero,
    required String raca,
    required String estadoCivil,
    required bool possuiFilhos,
    required int? quantidadeFilhos,
    required int tempoEmpresaMeses,
    required int tempoCargoMeses,
    required String escolaridade,
  }) async {
    if (usuarioId == null) {
      print("Erro: usuárioId está nulo. Cadastro não armazenou ID.");
      return false;
    }

    // Endpoint correto no backend: /api/pesquisa/salvar
    var url = Uri.parse("$baseUrl/api/pesquisa/salvar");

    final bodyMap = {
      "idade": idade,
      "genero": genero,
      "raca": raca,
      "estado_civil": estadoCivil,
      "possui_filhos": possuiFilhos,
      "quantidade_filhos": quantidadeFilhos,
      "tempo_empresa_meses": tempoEmpresaMeses,
      "tempo_cargo_meses": tempoCargoMeses,
      "escolaridade": escolaridade,
    };

    try {
      final headers = {"Content-Type": "application/json"};
      if (accessToken != null) {
        headers["Authorization"] = "Bearer $accessToken";
      }

      var resposta = await http.post(
        url,
        headers: headers,
        body: jsonEncode(bodyMap),
      );

      print("Tentativa POST /api/pesquisa/salvar -> ${resposta.statusCode} ${resposta.body}");
      return resposta.statusCode == 200 || resposta.statusCode == 201;
    } catch (e) {
      print("Erro ao enviar pesquisa: $e");
      return false;
    }
  }

  Future<bool> loginUsuario(String email, String password) async {
    var url = Uri.parse("$baseUrl/auth/token");

    try {
      // FastAPI OAuth2 espera form-data, não JSON
      var resposta = await http.post(
        url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: "username=$email&password=$password",
      );

      if (resposta.statusCode == 200) {
        var body = jsonDecode(resposta.body);
        accessToken = body["access_token"];
        print("DEBUG - Login sucesso, token obtido");

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

  Future<bool> enviarRespostas(Map<int, int> respostas) async {
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

  Future<List<dynamic>> getPerguntas() async {
    if (accessToken == null) {
      throw Exception("Usuário não autenticado");
    }

    // Usa a baseUrl inteligente que configuramos antes
    var url = Uri.parse("$baseUrl/perguntas");

    try {
      var resposta = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken", // <--- O SEGREDO ESTÁ AQUI
        },
      );

      if (resposta.statusCode == 200) {
        return jsonDecode(resposta.body);
      } else {
        throw Exception("Erro ${resposta.statusCode}: ${resposta.body}");
      }
    } catch (e) {
      print("Erro ao buscar perguntas: $e");
      rethrow;
    }
  }

  void logout() {
    accessToken = null;
    usuarioId = null;
    usuarioTipo = null;
    userData = null;
  }
}
