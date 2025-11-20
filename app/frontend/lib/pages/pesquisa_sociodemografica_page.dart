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

  // ESTILO DOS CAMPOS
  InputDecoration fieldDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: const Color(0xFFE2B8FF), // Roxo claro igual ao cadastro
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide.none,
      ),
      labelStyle: const TextStyle(color: Colors.black87),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // FUNDO BRANCO
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // TÍTULO
              const Text(
                "Estamos quase lá!!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 14),

              // Caixinha amarela
              const DecoratedBox(
                decoration: BoxDecoration(
                  color: Color(0xFFFFB84D),
                  borderRadius: BorderRadius.all(Radius.circular(14)),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  child: Text(
                    "Com essas informações\nfarei seu perfil",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: fieldDecoration("Idade"),
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                          v == null || v.isEmpty ? "Obrigatório" : null,
                      onSaved: (v) => idade = int.tryParse(v!),
                    ),

                    const SizedBox(height: 15),

                    DropdownButtonFormField(
                      decoration: fieldDecoration("Gênero"),
                      dropdownColor: const Color(0xFFE2B8FF),
                      items: [
                        "Homem",
                        "Mulher",
                        "Outro",
                        "Prefiro não responder"
                      ]
                          .map((e) =>
                              DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (v) => genero = v,
                      validator: (v) => v == null ? "Obrigatório" : null,
                    ),

                    const SizedBox(height: 15),

                    DropdownButtonFormField(
                      decoration: fieldDecoration("Raça/Etnia"),
                      dropdownColor: const Color(0xFFE2B8FF),
                      items: ["Branco", "Amarelo", "Indígena", "Pardo", "Preto"]
                          .map((e) =>
                              DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (v) => raca = v,
                      validator: (v) => v == null ? "Obrigatório" : null,
                    ),

                    const SizedBox(height: 15),

                    DropdownButtonFormField(
                      decoration: fieldDecoration("Estado Civil"),
                      dropdownColor: const Color(0xFFE2B8FF),
                      items: [
                        "Solteiro(a)",
                        "Casado(a)",
                        "União Estável",
                        "Divorciado(a)",
                        "Viúvo(a)"
                      ]
                          .map((e) =>
                              DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (v) => estadoCivil = v,
                      validator: (v) => v == null ? "Obrigatório" : null,
                    ),

                    const SizedBox(height: 15),

                    DropdownButtonFormField<bool>(
                      decoration: fieldDecoration("Possui filhos?"),
                      dropdownColor: const Color(0xFFE2B8FF),
                      items: const [
                        DropdownMenuItem(value: false, child: Text("Não")),
                        DropdownMenuItem(value: true, child: Text("Sim")),
                      ],
                      onChanged: (v) => setState(() => possuiFilhos = v),
                      validator: (v) => v == null ? "Obrigatório" : null,
                    ),

                    if (possuiFilhos == true) ...[
                      const SizedBox(height: 15),
                      TextFormField(
                        decoration: fieldDecoration("Quantidade de filhos"),
                        keyboardType: TextInputType.number,
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
                    ],

                    const SizedBox(height: 15),

                    TextFormField(
                      decoration: fieldDecoration("Tempo de empresa (meses)"),
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                          v == null || v.isEmpty ? "Obrigatório" : null,
                      onSaved: (v) =>
                          tempoEmpresaMeses = int.tryParse(v!),
                    ),

                    const SizedBox(height: 15),

                    TextFormField(
                      decoration:
                          fieldDecoration("Tempo no cargo atual (meses)"),
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                          v == null || v.isEmpty ? "Obrigatório" : null,
                      onSaved: (v) => tempoCargoMeses = int.tryParse(v!),
                    ),

                    const SizedBox(height: 15),

                    DropdownButtonFormField(
                      decoration: fieldDecoration("Escolaridade"),
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
                        "Doutorado"
                      ]
                          .map((e) =>
                              DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (v) => escolaridade = v,
                      validator: (v) => v == null ? "Obrigatório" : null,
                    ),

                    const SizedBox(height: 35),

                    // BOTÃO ENVIAR
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFB84D),
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();

                            final api = ApiService();

                            bool sucesso =
                                await api.enviarPesquisaSociodemografica(
                              idade: idade!,
                              genero: genero!,
                              raca: raca!,
                              estadoCivil: estadoCivil!,
                              possuiFilhos: possuiFilhos!,
                              quantidadeFilhos: quantidadeFilhos,
                              tempoEmpresaMeses: tempoEmpresaMeses!,
                              tempoCargoMeses: tempoCargoMeses!,
                              escolaridade: escolaridade!,
                            );

                            if (!mounted) return;

                            if (sucesso) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      LoginPage(tipoUsuario: widget.tipoUsuario),
                                ),
                              );
                            }
                          }
                        },
                        child: const Text(
                          "Enviar",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
