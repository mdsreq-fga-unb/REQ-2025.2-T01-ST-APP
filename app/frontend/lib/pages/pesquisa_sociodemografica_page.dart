import 'package:flutter/material.dart';
import '/services/api_service.dart';
import '/pages/login_page.dart';

class PesquisaSociodemograficaPage extends StatefulWidget {
  final String tipoUsuario;

  const PesquisaSociodemograficaPage({
    super.key,
    required this.tipoUsuario,
  });

  @override
  State<PesquisaSociodemograficaPage> createState() =>
      _PesquisaSociodemograficaPageState();
}

class _PesquisaSociodemograficaPageState
    extends State<PesquisaSociodemograficaPage> {
  final _formKey = GlobalKey<FormState>();

  int? idade;
  String? genero;
  String? raca;
  String? estadoCivil;
  bool? possuiFilhos;
  int? quantidadeFilhos;
  int? tempoEmpresaMeses;
  int? tempoCargoMeses;
  String? escolaridade;

  Widget tituloSecao(String texto) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 8),
      child: Text(
        texto,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  InputDecoration campoEstilo() {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFFE2B8FF),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),

                const Center(
                  child: Text(
                    "Estamos quase terminando!",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                tituloSecao("Idade"),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: campoEstilo(),
                  validator: (v) =>
                      v == null || v.isEmpty ? "Obrigatório" : null,
                  onSaved: (v) => idade = int.tryParse(v!),
                ),

                tituloSecao("Como você se identifica quanto a gênero?"),
                ...[
                  "Mulher",
                  "Homem",
                  "Outro",
                  "Prefiro não informar"
                ].map(
                  (e) => RadioListTile(
                    value: e,
                    groupValue: genero,
                    activeColor: Colors.black87,
                    onChanged: (v) => setState(() => genero = v),
                    title: Text(e),
                  ),
                ),

                tituloSecao("E quanto à raça?"),
                ...[
                  "Branco(a)",
                  "Pardo(a)",
                  "Indígena",
                  "Amarelo(a)",
                  "Preto(a)"
                ].map(
                  (e) => RadioListTile(
                    value: e,
                    groupValue: raca,
                    activeColor: Colors.black87,
                    onChanged: (v) => setState(() => raca = v),
                    title: Text(e),
                  ),
                ),

                tituloSecao("Qual é seu estado civil?"),
                ...[
                  "Solteiro(a)",
                  "Casado(a)",
                  "União estável",
                  "Divorciado(a)",
                  "Viúvo(a)"
                ].map(
                  (e) => RadioListTile(
                    value: e,
                    groupValue: estadoCivil,
                    activeColor: Colors.black87,
                    onChanged: (v) => setState(() => estadoCivil = v),
                    title: Text(e),
                  ),
                ),

                tituloSecao("Tem filhos?"),
                RadioListTile<bool>(
                  value: false,
                  groupValue: possuiFilhos,
                  activeColor: Colors.black87,
                  onChanged: (v) => setState(() => possuiFilhos = v),
                  title: const Text("Não tenho"),
                ),
                RadioListTile<bool>(
                  value: true,
                  groupValue: possuiFilhos,
                  activeColor: Colors.black87,
                  onChanged: (v) => setState(() => possuiFilhos = v),
                  title: const Text("Tenho. Quantos?"),
                ),

                if (possuiFilhos == true)
                  Padding(
                    padding: const EdgeInsets.only(left: 22, bottom: 12),
                    child: SizedBox(
                      width: 220,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: campoEstilo(),
                        validator: (v) {
                          if (possuiFilhos == true &&
                              (v == null || v.isEmpty)) {
                            return "Obrigatório";
                          }
                          return null;
                        },
                        onSaved: (v) =>
                            quantidadeFilhos = int.tryParse(v ?? "0"),
                      ),
                    ),
                  ),

                tituloSecao("Tempo de empresa (em meses)"),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: campoEstilo(),
                  validator: (v) =>
                      v == null || v.isEmpty ? "Obrigatório" : null,
                  onSaved: (v) => tempoEmpresaMeses = int.tryParse(v!),
                ),

                tituloSecao("Tempo no cargo atual (em meses)"),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: campoEstilo(),
                  validator: (v) =>
                      v == null || v.isEmpty ? "Obrigatório" : null,
                  onSaved: (v) => tempoCargoMeses = int.tryParse(v!),
                ),

                tituloSecao("Escolaridade"),
                DropdownButtonFormField(
                  decoration: campoEstilo(),
                  dropdownColor: const Color(0xFFE2B8FF),
                  items: [
                    "Ensino Fundamental incompleto",
                    "Ensino Fundamental completo",
                    "Ensino Médio incompleto",
                    "Ensino Médio completo",
                    "Superior incompleto",
                    "Superior completo",
                    "Pós-graduação",
                    "Mestrado",
                    "Doutorado",
                  ]
                      .map((e) =>
                          DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => escolaridade = v,
                  validator: (v) => v == null ? "Obrigatório" : null,
                ),

                const SizedBox(height: 40),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE2B8FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: enviarFormulario,
                    child: const Text(
                      "Enviar",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> enviarFormulario() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final estadoCivilMap = {
        "Solteiro(a)": "Solteiro",
        "Casado(a)": "Casado",
        "União estável": "Uniao_Estavel",
        "Divorciado(a)": "Divorciado",
        "Viúvo(a)": "Viúvo",
      };

      final escolaridadeMap = {
        "Ensino Fundamental incompleto": "Fundamental_incompleto",
        "Ensino Fundamental completo": "Fundamental_completo",
        "Ensino Médio incompleto": "Medio_incompleto",
        "Ensino Médio completo": "Medio_completo",
        "Superior incompleto": "Superior_incompleto",
        "Superior completo": "Superior_completo",
        "Pós-graduação": "Pos_graduacao",
        "Mestrado": "Mestrado",
        "Doutorado": "Doutorado",
      };

      
      final racaMap = {
        "Branco(a)": "Branco",
        "Pardo(a)": "Pardo",
        "Indígena": "Indigena",
        "Amarelo(a)": "Amarelo",
        "Preto(a)": "Preto",
      };

      final apiService = ApiService();

      bool sucesso = await apiService.enviarPesquisaSociodemografica(
        idade: idade!,
        genero: genero!,
        raca: racaMap[raca] ?? raca!,
        estadoCivil: estadoCivilMap[estadoCivil] ?? estadoCivil!,
        possuiFilhos: possuiFilhos!,
        quantidadeFilhos: quantidadeFilhos,
        tempoEmpresaMeses: tempoEmpresaMeses!,
        tempoCargoMeses: tempoCargoMeses!,
        escolaridade: escolaridadeMap[escolaridade] ?? escolaridade!,
      );

      if (!mounted) return;

      if (sucesso) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => LoginPage(tipoUsuario: widget.tipoUsuario),
          ),
        );
      }
    }
  }
}
