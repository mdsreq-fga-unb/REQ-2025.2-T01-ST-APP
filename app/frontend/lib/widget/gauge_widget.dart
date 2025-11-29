import 'package:flutter/material.dart';
import 'dart:math';

class GaugeWidget extends StatelessWidget {
  final double valor; 

  const GaugeWidget({super.key, required this.valor});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(180, 120),
      painter: _GaugePainter(valor),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double valor;

  _GaugePainter(this.valor);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.9);
    final radius = size.width * 0.75;

    final faixaEspessura = 22.0;

    final rect = Rect.fromCircle(center: center, radius: radius);

    
    final faixas = [
      Colors.red,
      const Color(0xFFF4D03F), 
      const Color(0xFF5DADE2), 
      const Color(0xFF2ECC71), 
    ];

    const sweep = pi / 4;

    for (int i = 0; i < 4; i++) {
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = faixaEspessura
        ..strokeCap = StrokeCap.butt
        ..color = faixas[i];

      final start = pi + (i * sweep);

      canvas.drawArc(rect, start, sweep, false, paint);
    }

    final ponteiroAngulo = pi + (valor * pi);

    final ponteiroComprimento = radius - 10;

    final ponta = Offset(
      center.dx + ponteiroComprimento * cos(ponteiroAngulo),
      center.dy + ponteiroComprimento * sin(ponteiroAngulo),
    );

    final ponteiroPaint = Paint()
      ..color = Colors.blueGrey.shade700
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(center, ponta, ponteiroPaint);

    canvas.drawCircle(
      center,
      12,
      Paint()..color = Colors.blueGrey.shade900,
    );
  }

  @override
  bool shouldRepaint(_GaugePainter oldDelegate) =>
      oldDelegate.valor != valor;
}
