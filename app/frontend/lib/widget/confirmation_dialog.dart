import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({super.key});

  final Color corRoxaClara = const Color(0xFFD4B4EB);
  final Color corLaranja = const Color(0xFFFEBB4C);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: corLaranja, // Fundo laranja do protótipo
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      title: const Center(
        child: Text(
          "Você confirma suas respostas?",
          style: TextStyle(
            color: Colors.white, // Texto branco para contraste
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          // Botão "Não"
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Retorna 'false'
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: corRoxaClara, // Roxo claro
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: const Text(
                "Não",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 15), // Espaçamento entre os botões
          // Botão "Sim"
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Retorna 'true'
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: corRoxaClara, // Roxo claro
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: const Text(
                "Sim",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      // Remover o actions padding padrão
      actionsPadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0), // Ajustar padding do conteúdo
    );
  }
}