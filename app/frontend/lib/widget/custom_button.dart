import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final Color? backgroundColor; // Agora aceita cor de fundo opcional
  final Color? textColor;       // Agora aceita cor de texto opcional

  const CustomButton({
    super.key,
    required this.title,
    required this.onTap,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
