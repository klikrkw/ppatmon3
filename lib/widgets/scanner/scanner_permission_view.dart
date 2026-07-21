import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class ScannerPermissionView extends StatelessWidget {
  final VoidCallback onGranted;

  const ScannerPermissionView({super.key, required this.onGranted});

  Future<void> _requestPermission() async {
    final status = await Permission.camera.request();

    if (status.isGranted) {
      onGranted();
    } else {
      openAppSettings();
    }
  }

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
              const Icon(Icons.camera_alt, size: 80, color: Colors.white),
              const SizedBox(height: 20),
              const Text(
                "Izin Kamera Dibutuhkan",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                "Berikan izin kamera untuk melakukan scan QR Code.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 30),
              FilledButton(
                onPressed: _requestPermission,
                child: const Text("Berikan Izin"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
