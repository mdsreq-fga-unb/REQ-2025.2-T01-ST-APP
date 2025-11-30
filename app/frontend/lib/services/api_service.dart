import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class ApiService {
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
        usuarioId = body["id"] ?? body["user_id"] ?? body["userId"];
        usuarioTipo = body["role"] ?? "Colaborador";
        userData = body;
        print("DEBUG - usuarioId extraído: $usuarioId");
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
  if (usuarioId == null || accessToken == null) {
    print("DEBUG - usuarioId ou accessToken é nulo");
    return false;
  }

  try {
    int respostasEnviadas = 0;
    int totalRespostas = respostas.length;

    print("DEBUG - Iniciando envio de $totalRespostas respostas");

    for (var entry in respostas.entries) {
      bool sucesso = await enviarRespostaIndividual(entry.key, entry.value);
      if (sucesso) {
        respostasEnviadas++;
        print("DEBUG - Resposta $respostasEnviadas/$totalRespostas enviada com sucesso");
      } else {
        print("DEBUG - Falha ao enviar resposta para pergunta ${entry.key}");
      }
    }

    print("DEBUG - Total de respostas processadas: $respostasEnviadas/$totalRespostas");
    
    return respostasEnviadas > 0;
    
  } catch (e) {
    print("Erro ao enviar respostas: $e");
    return false;
  }
}

Future<bool> enviarRespostaIndividual(int perguntaId, int valor) async {
  if (accessToken == null) {
    print("DEBUG - Access token é nulo");
    return false;
  }

  var url = Uri.parse("$baseUrl/api/responder");

  try {
    var resposta = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode({
        "pergunta_id": perguntaId,
        "voto_valor": valor,
      }),
    );

    print("DEBUG - Status code resposta individual: ${resposta.statusCode}");
    print("DEBUG - Response body: ${resposta.body}");
    
    if (resposta.statusCode == 200) {
      var responseBody = jsonDecode(resposta.body);
      if (responseBody["status"] == "Voto computado com sucesso!") {
        print("DEBUG - Resposta salva: pergunta_id=$perguntaId, valor=$valor");
        return true;
      }
    }
    
    print("DEBUG - Erro ao salvar resposta individual");
    return false;
    
  } catch (e) {
    print("Erro ao enviar resposta individual: $e");
    return false;
  }
}

  Future<List<dynamic>> getPerguntas() async {
  if (accessToken == null) {
    print("DEBUG - Access token é nulo!");
    throw Exception("Usuário não autenticado");
  }

  var url = Uri.parse("$baseUrl/perguntas");
  print("DEBUG - URL das perguntas: $url");

  try {
    var resposta = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );

    print("DEBUG - Status code: ${resposta.statusCode}");

    if (resposta.statusCode == 200) {
      var decoded = jsonDecode(resposta.body);
      return decoded;
    } else {
      throw Exception("Erro ${resposta.statusCode}: ${resposta.body}");
    }
  } catch (e) {
    print("Erro ao buscar perguntas: $e");
    rethrow;
  }
}

  Future<List<dynamic>> getResultadosPorTema(
    String tema, {
    String? dataInicio, // Ex: "2023-10-01"
    String? dataFim,    // Ex: "2023-10-31"
  }) async {
    if (accessToken == null) {
      throw Exception("Usuário não autenticado");
    }

    // 1. Monta os parâmetros de Query
    final Map<String, String> queryParams = {};
    if (dataInicio != null) queryParams['data_inicio'] = dataInicio;
    if (dataFim != null) queryParams['data_fim'] = dataFim;

    // 2. Cria a URL com os parâmetros
    var uri = Uri.parse("$baseUrl/api/respostas/${Uri.encodeComponent(tema)}")
        .replace(queryParameters: queryParams.isNotEmpty ? queryParams : null);

    try {
      var resposta = await http.get(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );

      if (resposta.statusCode == 200) {
        return jsonDecode(resposta.body);
      } else {
        throw Exception("Erro ${resposta.statusCode}: ${resposta.body}");
      }
    } catch (e) {
      print("Erro ao buscar resultados por tema: $e");
      rethrow;
    }
  }

  Future<String?> downloadRelatorioPdf(
    String tema, {
    String? dataInicio,
    String? dataFim,
  }) async {
    if (accessToken == null) throw Exception("Usuário não autenticado");

    // Monta os Query Parameters
    final Map<String, String> queryParams = {};
    if (dataInicio != null) queryParams['data_inicio'] = dataInicio;
    if (dataFim != null) queryParams['data_fim'] = dataFim;

    // Rota ajustada para /api/resultados/relatorio-pdf/ (Conforme o backend)
    var uri = Uri.parse("$baseUrl/api/relatorio-pdf/${Uri.encodeComponent(tema)}")
        .replace(queryParameters: queryParams.isNotEmpty ? queryParams : null);

    try {
      var resposta = await http.get(
        uri,
        headers: {
          "Authorization": "Bearer $accessToken",
        },
      );

      if (resposta.statusCode == 200) {
        final bytes = resposta.bodyBytes;
        final dir = await getTemporaryDirectory();
        
        // Limpa nome do arquivo
        final safeTema = tema.replaceAll(RegExp(r'[^\w\s]+'), '');
        final filePath = "${dir.path}/relatorio_${safeTema.replaceAll(' ', '_')}.pdf";
        
        final file = File(filePath);
        await file.writeAsBytes(bytes);

        try {
          await OpenFile.open(filePath);
        } catch (e) {
          print('Não foi possível abrir automaticamente: $e');
        }

        return filePath;
      } else {
        throw Exception("Erro ao gerar PDF: ${resposta.statusCode}");
      }
    } catch (e) {
      print("Erro ao baixar PDF: $e");
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
