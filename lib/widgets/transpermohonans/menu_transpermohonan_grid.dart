import 'package:flutter/material.dart';

class MenuTranspermohonanGrid extends StatelessWidget {
  final VoidCallback? onGetLokasi;

  final VoidCallback? onProses;

  final VoidCallback? onPengeluaran;

  final VoidCallback? onBiaya;

  const MenuTranspermohonanGrid({
    super.key,
    this.onGetLokasi,
    this.onProses,
    this.onPengeluaran,
    this.onBiaya,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _MenuItem(
            title: "Lokasi Berkas",
            icon: Icons.pin_drop_outlined,
            color: Colors.blue,
            onTap: onGetLokasi,
          ),
          _MenuItem(
            title: "Proses Berkas",
            icon: Icons.assignment_outlined,
            color: Colors.green,
            onTap: onProses,
          ),
          _MenuItem(
            title: "Biaya Permohonan",
            icon: Icons.account_balance_wallet_outlined,
            color: Colors.orange,
            onTap: onBiaya,
          ),
          _MenuItem(
            title: "Pengeluaran",
            icon: Icons.receipt_long_outlined,
            color: Colors.redAccent,
            onTap: onPengeluaran,
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final String title;

  final IconData icon;

  final Color color;

  final VoidCallback? onTap;

  const _MenuItem({
    required this.title,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: SizedBox(
        width: 72,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: color.withValues(alpha: .10),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(icon, color: color, size: 34),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
