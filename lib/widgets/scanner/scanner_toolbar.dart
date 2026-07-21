import 'package:flutter/material.dart';

class ScannerToolbar extends StatelessWidget {
  final bool torchEnabled;

  final double zoom;

  final VoidCallback onClose;

  final VoidCallback onFlash;

  final VoidCallback onSwitchCamera;

  final ValueChanged<double>? onZoomChanged;

  const ScannerToolbar({
    super.key,
    required this.torchEnabled,
    required this.zoom,
    required this.onClose,
    required this.onFlash,
    required this.onSwitchCamera,
    this.onZoomChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _buildTopBar(context),

          const Spacer(),

          _buildBottomBar(context),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _ToolbarButton(icon: Icons.close, onTap: onClose),

          const Spacer(),

          const Text(
            "Scan QR Code",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),

          const Spacer(),

          _ToolbarButton(
            icon: torchEnabled ? Icons.flash_on : Icons.flash_off,
            color: torchEnabled ? Colors.amber : Colors.white,
            onTap: onFlash,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(18),
          color: Colors.black54,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(Icons.zoom_out, color: Colors.white),

                  Expanded(
                    child: Slider(
                      value: zoom,
                      min: 0,
                      max: 1,
                      onChanged: onZoomChanged,
                    ),
                  ),

                  const Icon(Icons.zoom_in, color: Colors.white),
                ],
              ),

              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ActionButton(
                    icon: Icons.cameraswitch,
                    label: "Kamera",
                    onTap: onSwitchCamera,
                  ),

                  _ActionButton(
                    icon: torchEnabled ? Icons.flash_on : Icons.flash_off,
                    label: "Flash",
                    onTap: onFlash,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ToolbarButton extends StatelessWidget {
  final IconData icon;

  final Color color;

  final VoidCallback onTap;

  const _ToolbarButton({
    required this.icon,
    required this.onTap,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: onTap,
      child: Ink(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.black54,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;

  final String label;

  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white),

            const SizedBox(height: 6),

            Text(label, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
