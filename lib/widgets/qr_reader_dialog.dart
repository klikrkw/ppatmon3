import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrReaderDialog extends StatefulWidget {
  const QrReaderDialog({super.key});

  static Future<String?> show(BuildContext context) async {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const QrReaderDialog(),
    );
  }

  @override
  State<QrReaderDialog> createState() => _QrReaderDialogState();
}

class _QrReaderDialogState extends State<QrReaderDialog> {
  late final MobileScannerController _controller;

  bool _isProcessing = false;
  final _scannerKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      facing: CameraFacing.back,
      detectionSpeed: DetectionSpeed.noDuplicates,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await _controller.stop();
        await Future.delayed(const Duration(milliseconds: 100));
        await _controller.start();
      } catch (_) {}
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _close([String? value]) async {
    try {
      await _controller.stop();
    } catch (_) {}

    if (mounted) {
      Navigator.pop(context, value);
    }
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_isProcessing) return;

    final barcode = capture.barcodes.firstOrNull;
    final value = barcode?.rawValue;

    if (value == null || value.isEmpty) return;

    _isProcessing = true;

    await _controller.stop();

    if (mounted) {
      // Navigator.pop(context, value);
      await _close(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.black,
      child: SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * .85,
        child: Stack(
          children: [
            /// Camera
            MobileScanner(
              key: _scannerKey,
              controller: _controller,
              onDetect: _onDetect,
            ),

            /// Overlay
            const ScannerOverlay(),

            /// Top Bar
            Positioned(
              top: 20,
              left: 12,
              right: 12,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () async {
                      // Navigator.pop(context, null);
                      await _close();
                    },
                  ),
                  const Expanded(
                    child: Text(
                      'Scan QR Code',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ValueListenableBuilder(
                    valueListenable: _controller,
                    builder: (_, state, _) {
                      return IconButton(
                        onPressed: _controller.toggleTorch,
                        icon: Icon(
                          state == TorchState.on
                              ? Icons.flash_on
                              : Icons.flash_off,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            /// Instruction
            Positioned(
              bottom: 80,
              left: 24,
              right: 24,
              child: Text(
                'Arahkan QR Code ke dalam area scan',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: .9),
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScannerOverlay extends StatelessWidget {
  const ScannerOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    const scanSize = 260.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        final left = (width - scanSize) / 2;
        final top = (height - scanSize) / 2;

        return Stack(
          children: [
            /// Area gelap atas
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              height: top,
              child: _shadow(),
            ),

            /// Area gelap bawah
            Positioned(
              left: 0,
              right: 0,
              top: top + scanSize,
              bottom: 0,
              child: _shadow(),
            ),

            /// Area gelap kiri
            Positioned(
              left: 0,
              top: top,
              width: left,
              height: scanSize,
              child: _shadow(),
            ),

            /// Area gelap kanan
            Positioned(
              right: 0,
              top: top,
              width: left,
              height: scanSize,
              child: _shadow(),
            ),

            /// Frame scan
            Positioned(
              left: left,
              top: top,
              child: Container(
                width: scanSize,
                height: scanSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),

            /// Corner kiri atas
            Positioned(
              left: left,
              top: top,
              child: const _Corner(top: true, left: true),
            ),

            /// Corner kanan atas
            Positioned(
              right: left,
              top: top,
              child: const _Corner(top: true, left: false),
            ),

            /// Corner kiri bawah
            Positioned(
              left: left,
              bottom: top,
              child: const _Corner(top: false, left: true),
            ),

            /// Corner kanan bawah
            Positioned(
              right: left,
              bottom: top,
              child: const _Corner(top: false, left: false),
            ),
          ],
        );
      },
    );
  }

  Widget _shadow() {
    return Container(color: Colors.black.withValues(alpha: 0.65));
  }
}

class _Corner extends StatelessWidget {
  final bool top;
  final bool left;

  const _Corner({required this.top, required this.left});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        border: Border(
          top: top
              ? const BorderSide(color: Colors.green, width: 5)
              : BorderSide.none,
          bottom: !top
              ? const BorderSide(color: Colors.green, width: 5)
              : BorderSide.none,
          left: left
              ? const BorderSide(color: Colors.green, width: 5)
              : BorderSide.none,
          right: !left
              ? const BorderSide(color: Colors.green, width: 5)
              : BorderSide.none,
        ),
      ),
    );
  }
}
