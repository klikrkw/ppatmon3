import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SaldoKasbonCard extends StatelessWidget {
  final double saldo;

  final bool visible;

  final VoidCallback? onToggleVisibility;

  final VoidCallback? onTapSemuaKasbon;

  const SaldoKasbonCard({
    super.key,
    required this.saldo,
    required this.visible,
    this.onToggleVisibility,
    this.onTapSemuaKasbon,
  });

  String _formatCurrency(double value) {
    return NumberFormat.currency(
      locale: "id_ID",
      symbol: "Rp ",
      decimalDigits: 0,
    ).format(value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(
          colors: [Color(0xff1565C0), Color(0xff42A5F5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: .25),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet_outlined,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Text(
                    "Saldo Kasbon Kamu",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: onToggleVisibility,
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Icon(
                      visible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: visible
                  ? Text(
                      _formatCurrency(saldo),
                      key: const ValueKey("saldo"),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        letterSpacing: .5,
                      ),
                    )
                  : const Text(
                      "••••••••••",
                      key: ValueKey("hidden"),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),

            const SizedBox(height: 10),

            Text(
              visible
                  ? "Saldo kasbon yang masih tersedia"
                  : "Saldo disembunyikan",
              style: TextStyle(
                color: Colors.white.withValues(alpha: .85),
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 22),

            const Divider(color: Colors.white24, height: 1),

            InkWell(
              onTap: onTapSemuaKasbon,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.only(top: 14),
                child: Row(
                  children: [
                    const Icon(Icons.list_alt, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        "Lihat Semua Kasbon",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
