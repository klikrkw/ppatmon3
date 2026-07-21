import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newklikrkw/models/keluarbiayapermuser.dart';

class KeluarbiayapermuserCard extends StatelessWidget {
  final Keluarbiayapermuser keluarbiayapermuser;

  final VoidCallback? onTap;

  const KeluarbiayapermuserCard({
    super.key,
    required this.keluarbiayapermuser,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(
      locale: "id_ID",
      symbol: "Rp ",
      decimalDigits: 0,
    );

    final dateFormat = DateFormat("dd MMM yyyy HH:mm", "id_ID");

    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              Row(
                children: [
                  Expanded(
                    child: Text(
                      keluarbiayapermuser.id,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  _statusChip(),
                ],
              ),

              const SizedBox(height: 12),

              const Divider(),

              _infoRow(Icons.person, "User", keluarbiayapermuser.user.name),

              _infoRow(
                Icons.account_balance_wallet,
                "Metode",
                keluarbiayapermuser.metodebayar.namaMetodebayar,
              ),

              _infoRow(
                Icons.business,
                "Instansi",
                keluarbiayapermuser.instansi.namaInstansi,
              ),

              const SizedBox(height: 12),

              const Divider(),

              _moneyRow(
                "Saldo Awal",
                currency.format(keluarbiayapermuser.saldoAwal),
              ),

              _moneyRow(
                "Jumlah Biaya",
                currency.format(keluarbiayapermuser.jumlahBiaya),
              ),

              _moneyRow(
                "Saldo Akhir",
                currency.format(keluarbiayapermuser.saldoAkhir),
                bold: true,
              ),

              const SizedBox(height: 16),

              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  dateFormat.format(keluarbiayapermuser.createdAt),
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusChip() {
    Color color;
    String text;

    switch (keluarbiayapermuser.statusKeluarbiayapermuser) {
      case "approved":
        color = Colors.green;
        text = "APPROVED";
        break;

      case "wait_approval":
        color = Colors.orange;
        text = "WAIT APPROVAL";
        break;

      case "rejected":
        color = Colors.red;
        text = "REJECTED";
        break;

      default:
        color = Colors.grey;
        text = keluarbiayapermuser.statusKeluarbiayapermuser;
    }

    return Chip(
      label: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
      backgroundColor: color,
    );
  }

  Widget _infoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18),

          const SizedBox(width: 8),

          SizedBox(
            width: 70,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),

          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _moneyRow(String title, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(title)),

          Text(
            value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
