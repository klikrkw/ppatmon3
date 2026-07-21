import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newklikrkw/models/bukubesar.dart';

class BukubesarCard extends StatelessWidget {
  final Bukubesar item;
  final int index;
  final VoidCallback? onTap;

  const BukubesarCard({
    super.key,
    required this.item,
    required this.index,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    final dateFormat = DateFormat('dd MMM yyyy HH:mm', 'id');

    final bool isDebet = item.isDebet;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      elevation: 0,
      color: index.isEven ? Colors.white : Colors.grey.shade100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///==========================
              /// Header
              ///==========================
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: isDebet
                        ? Colors.green.shade100
                        : Colors.red.shade100,
                    child: Icon(
                      isDebet ? Icons.south_west : Icons.north_east,
                      color: isDebet ? Colors.green : Colors.red,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.namaAkun,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),

                        Text(
                          item.kodeAkun,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),

                  Text(
                    "#${item.noRut}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),

              const SizedBox(height: 12),

              ///==========================
              /// Uraian
              ///==========================
              Text(item.uraian, style: const TextStyle(fontSize: 15)),

              const SizedBox(height: 12),

              ///==========================
              /// Debet / Kredit
              ///==========================
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.jenisTransaksi,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),

                        const SizedBox(height: 4),

                        Text(
                          currency.format(item.jumlah),
                          style: TextStyle(
                            color: isDebet ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Saldo",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),

                      const SizedBox(height: 4),

                      Text(
                        currency.format(item.saldo),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),

              const Divider(height: 24),

              ///==========================
              /// Footer
              ///==========================
              Row(
                children: [
                  const Icon(Icons.schedule, size: 16),

                  const SizedBox(width: 6),

                  Expanded(
                    child: Text(
                      item.tanggal == null
                          ? "-"
                          : dateFormat.format(item.tanggal!),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),

                  Text(
                    item.kodeJenisakun,
                    style: Theme.of(context).textTheme.bodySmall,
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
