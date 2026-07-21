import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:newklikrkw/models/postingjurnal.dart';
import 'package:newklikrkw/utils/dio.dart';

class PostingjurnalCard extends StatelessWidget {
  final Postingjurnal item;

  final int index;

  final VoidCallback? onTap;

  final VoidCallback? onEdit;

  final VoidCallback? onDelete;

  const PostingjurnalCard({
    super.key,
    required this.item,
    required this.index,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(
      locale: "id",
      symbol: "Rp ",
      decimalDigits: 0,
    );

    final dateFormat = DateFormat("dd MMM yyyy HH:mm", "id");

    final background = index.isEven
        ? Theme.of(context).colorScheme.surface
        : Theme.of(context).colorScheme.surfaceContainerLowest;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      color: background,
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///==========================
              /// IMAGE
              ///==========================
              Container(
                width: 60,
                height: 60,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: item.hasImage
                    ? Image.network(
                        "$myBaseUrl${item.image}",
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) =>
                            const Icon(Icons.image_not_supported),
                      )
                    : const Icon(Icons.receipt_long, size: 32),
              ),

              const SizedBox(width: 12),

              ///==========================
              /// CONTENT
              ///==========================
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.uraian,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      currency.format(item.jumlah),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text("User : ${item.user?.name ?? "-"}"),

                    // const SizedBox(height: 4),

                    // Text("Debet : ${item.akunDebet}"),

                    // Text("Kredit : ${item.akunKredit}"),
                    const SizedBox(height: 8),

                    Text(
                      item.createdAt == null
                          ? "-"
                          : dateFormat.format(item.createdAt!),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),

              ///==========================
              /// MENU
              ///==========================
              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case "edit":
                      onEdit?.call();
                      break;

                    case "delete":
                      onDelete?.call();
                      break;
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(
                    value: "edit",
                    child: Row(
                      children: [
                        Icon(Icons.edit),

                        SizedBox(width: 8),

                        Text("Edit"),
                      ],
                    ),
                  ),

                  PopupMenuItem(
                    value: "delete",
                    child: Row(
                      children: [
                        Icon(Icons.delete),

                        SizedBox(width: 8),

                        Text("Hapus"),
                      ],
                    ),
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
