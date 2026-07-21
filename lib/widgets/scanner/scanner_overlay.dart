import 'package:flutter/material.dart';

class ScannerOverlay extends StatefulWidget {
  const ScannerOverlay({super.key, this.scanSize = 280});

  final double scanSize;

  @override
  State<ScannerOverlay> createState() => _ScannerOverlayState();
}

class _ScannerOverlayState extends State<ScannerOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _animation = Tween(
      begin: 10.0,
      end: widget.scanSize - 12,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final left = (constraints.maxWidth - widget.scanSize) / 2;

        final top = (constraints.maxHeight - widget.scanSize) / 2;

        return Stack(
          children: [
            _buildShadow(left, top, constraints),

            Positioned(
              left: left,
              top: top,
              child: _ScannerFrame(
                size: widget.scanSize,
                animation: _animation,
              ),
            ),

            Positioned(
              left: 0,
              right: 0,
              bottom: 90,
              child: Column(
                children: [
                  const Icon(
                    Icons.qr_code_scanner,
                    color: Colors.white,
                    size: 40,
                  ),

                  const SizedBox(height: 12),

                  Text(
                    "Arahkan QR Code ke dalam area scan",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: .95),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "QR akan terbaca secara otomatis",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildShadow(double left, double top, BoxConstraints constraints) {
    return Stack(
      children: [
        Positioned(left: 0, right: 0, top: 0, height: top, child: _shadow()),

        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          top: top + widget.scanSize,
          child: _shadow(),
        ),

        Positioned(
          left: 0,
          top: top,
          width: left,
          height: widget.scanSize,
          child: _shadow(),
        ),

        Positioned(
          right: 0,
          top: top,
          width: left,
          height: widget.scanSize,
          child: _shadow(),
        ),
      ],
    );
  }

  Widget _shadow() {
    return Container(color: Colors.black.withValues(alpha: .65));
  }
}

class _ScannerFrame extends StatelessWidget {
  final double size;

  final Animation<double> animation;

  const _ScannerFrame({required this.size, required this.animation});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),

          _Corner(alignment: Alignment.topLeft),

          _Corner(alignment: Alignment.topRight),

          _Corner(alignment: Alignment.bottomLeft),

          _Corner(alignment: Alignment.bottomRight),

          AnimatedBuilder(
            animation: animation,
            builder: (_, _) {
              return Positioned(
                left: 8,
                right: 8,
                top: animation.value,
                child: Container(
                  height: 3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    gradient: const LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.greenAccent,
                        Colors.green,
                        Colors.greenAccent,
                        Colors.transparent,
                      ],
                    ),
                    boxShadow: const [
                      BoxShadow(color: Colors.green, blurRadius: 10),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _Corner extends StatelessWidget {
  final Alignment alignment;

  const _Corner({required this.alignment});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          border: Border(
            left:
                alignment == Alignment.topLeft ||
                    alignment == Alignment.bottomLeft
                ? const BorderSide(color: Colors.greenAccent, width: 5)
                : BorderSide.none,
            right:
                alignment == Alignment.topRight ||
                    alignment == Alignment.bottomRight
                ? const BorderSide(color: Colors.greenAccent, width: 5)
                : BorderSide.none,
            top:
                alignment == Alignment.topLeft ||
                    alignment == Alignment.topRight
                ? const BorderSide(color: Colors.greenAccent, width: 5)
                : BorderSide.none,
            bottom:
                alignment == Alignment.bottomLeft ||
                    alignment == Alignment.bottomRight
                ? const BorderSide(color: Colors.greenAccent, width: 5)
                : BorderSide.none,
          ),
        ),
      ),
    );
  }
}
