import 'dart:async';

// import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:newklikrkw/widgets/scanner/scanner_error_view.dart';
// import 'package:vibration/vibration.dart';

import '../widgets/scanner/scanner_overlay.dart';
import '../widgets/scanner/scanner_toolbar.dart';
// import 'package:vibration/vibration.dart';

class QrReaderPage extends StatefulWidget {
  const QrReaderPage({super.key});

  static Future<String?> show(BuildContext context) async {
    final result = Navigator.push<String>(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => const QrReaderPage(),
      ),
    );

    return result;
  }

  @override
  State<QrReaderPage> createState() => _QrReaderPageState();
}

class _QrReaderPageState extends State<QrReaderPage>
    with WidgetsBindingObserver {
  MobileScannerController? _controller;
  Key _scannerKey = UniqueKey();

  bool _processing = false;

  bool _startingCamera = true;

  bool _torch = false;

  CameraFacing _camera = CameraFacing.back;

  double _zoom = 0;

  double _baseZoom = 0;

  String? _errorMessage;
  Offset? _focusPoint;

  bool _showFocus = false;

  double _currentZoom = 1.0;

  Timer? _focusTimer;
  // final AudioPlayer _player = AudioPlayer();
  final bool _scanSuccess = false;
  String? _lastScannedCode;

  Future<void> _setZoom(double value) async {
    _zoom = value;

    await _controller?.setZoomScale(1 + (value * 4));

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _createController() async {
    // await _controller?.dispose();

    _controller = MobileScannerController(
      facing: CameraFacing.back,
      detectionSpeed: DetectionSpeed.noDuplicates,
      detectionTimeoutMs: 250,
    );

    _scannerKey = UniqueKey();

    _processing = false;
    _lastScannedCode = null;

    if (mounted) {
      setState(() {
        _startingCamera = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _createController();
  }

  Future<void> _restartCamera() async {
    await _createController();
  }

  // Future<void> _startCamera() async {
  //   setState(() {
  //     _startingCamera = true;
  //     _errorMessage = null;
  //   });

  //   try {
  //     if (!_processing) {
  //       try {
  //         await _controller?.start();
  //       } catch (_) {}
  //     }

  //     if (mounted) {
  //       setState(() {
  //         _startingCamera = false;
  //       });
  //     }
  //   } catch (e) {
  //     if (mounted) {
  //       setState(() {
  //         _startingCamera = false;
  //         _errorMessage = e.toString();
  //       });
  //     }
  //   }
  // }

  // Future<void> _stopCamera() async {
  //   try {
  //     await _controller?.stop();
  //   } catch (_) {}
  // }

  void _onScaleStart(ScaleStartDetails details) {
    _baseZoom = _currentZoom;
  }

  Future<void> _onScaleUpdate(ScaleUpdateDetails details) async {
    final zoom = (_baseZoom * details.scale).clamp(1.0, 5.0);

    _currentZoom = zoom;

    _zoom = (zoom - 1) / 4;

    await _controller?.setZoomScale(zoom);

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _doubleTapZoom() async {
    if (_currentZoom == 1) {
      _currentZoom = 2.5;
    } else {
      _currentZoom = 1;
    }

    _zoom = (_currentZoom - 1) / 4;

    await _controller?.setZoomScale(_currentZoom);

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _focus(TapDownDetails details) async {
    final box = context.findRenderObject() as RenderBox;

    final local = box.globalToLocal(details.globalPosition);

    final width = box.size.width;

    final height = box.size.height;

    _focusPoint = local;

    _showFocus = true;

    setState(() {});

    _focusTimer?.cancel();

    _focusTimer = Timer(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _showFocus = false;
        });
      }
    });

    try {
      await _controller?.setFocusPoint(
        Offset(local.dx / width, local.dy / height),
      );
    } catch (_) {}
  }

  // @override
  // void dispose() {
  //   WidgetsBinding.instance.removeObserver(this);

  //   _focusTimer?.cancel();
  //   _controller?.dispose();

  //   super.dispose();
  // }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (_controller == null) return;

    switch (state) {
      case AppLifecycleState.resumed:
        await _restartCamera();
        break;

      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
      case AppLifecycleState.inactive:
        await _controller?.stop();
        break;

      case AppLifecycleState.detached:
        break;
    }
  }

  // Future<void> _onDetect(BarcodeCapture capture) async {
  //   if (_processing) return;

  //   final barcode = capture.barcodes.firstOrNull;

  //   final value = barcode?.rawValue;

  //   if (value == null || value.isEmpty) {
  //     return;
  //   }

  //   if (await Vibration.hasVibrator()) {
  //     Vibration.vibrate(duration: 100);
  //   }
  //   setState(() {
  //     _scanSuccess = true;
  //   });

  //   // await _player.play(AssetSource("audio/beep.mp3"));
  //   _processing = true;

  //   await _stopCamera();
  //   await Future.delayed(const Duration(milliseconds: 100));

  //   if (!mounted) return;
  //   Navigator.pop(context, value);
  // }
  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_processing) return;

    final value = capture.barcodes.first.rawValue?.trim();

    // if (await Vibration.hasVibrator()) {
    //   Vibration.vibrate(duration: 100);
    // }

    if (_lastScannedCode == value) {
      return;
    }

    _processing = true;
    _lastScannedCode = value;

    if (!mounted) return;

    Navigator.pop(context, value);
  }

  Future<void> _toggleFlash() async {
    if (_controller == null) return;

    try {
      await _controller!.toggleTorch();

      if (mounted) {
        setState(() {
          _torch = !_torch;
        });
      }
    } catch (_) {}
  }

  Future<void> _switchCamera() async {
    await _controller?.switchCamera();

    setState(() {
      _camera = _camera == CameraFacing.back
          ? CameraFacing.front
          : CameraFacing.back;
    });
  }

  Future<void> _retry() async {
    await _restartCamera();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      backgroundColor: Colors.black,

      body: SafeArea(
        child: _errorMessage != null
            ? ScannerErrorView(message: _errorMessage!, onRetry: _retry)
            : _startingCamera
            ? const Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  if (_scanSuccess)
                    AnimatedOpacity(
                      opacity: _scanSuccess ? 1 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: const Center(
                        child: Icon(
                          Icons.check_circle,
                          size: 120,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  if (_showFocus && _focusPoint != null)
                    Positioned(
                      left: _focusPoint!.dx - 25,
                      top: _focusPoint!.dy - 25,
                      child: const _FocusView(),
                    ),
                  GestureDetector(
                    onScaleStart: _onScaleStart,

                    onScaleUpdate: _onScaleUpdate,

                    onDoubleTap: _doubleTapZoom,

                    onTapDown: _focus,

                    child: MobileScanner(
                      key: _scannerKey,
                      controller: _controller!,
                      onDetect: _onDetect,
                    ),
                  ),

                  const ScannerOverlay(),

                  ScannerToolbar(
                    torchEnabled: _torch,
                    zoom: _zoom,

                    onClose: () async {
                      // await _stopCamera();

                      if (context.mounted) {
                        setState(() {});
                        Navigator.pop(context);
                      }
                    },

                    onFlash: _toggleFlash,

                    onSwitchCamera: _switchCamera,

                    onZoomChanged: _setZoom,
                  ),
                ],
              ),
      ),
    );
  }
}

class _FocusView extends StatefulWidget {
  const _FocusView();

  @override
  State<_FocusView> createState() => _FocusViewState();
}

class _FocusViewState extends State<_FocusView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween(begin: 1.6, end: 1.0).animate(_controller),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.yellow, width: 2),
        ),
      ),
    );
  }
}
