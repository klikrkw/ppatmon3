import 'package:flutter/material.dart';

class ScannerErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ScannerErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 80),
              const SizedBox(height: 20),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              FilledButton(onPressed: onRetry, child: const Text("Coba Lagi")),
            ],
          ),
        ),
      ),
    );
  }
}
