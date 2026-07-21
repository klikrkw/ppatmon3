import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newklikrkw/models/dkeluarbiayapermuser.dart';
import 'package:newklikrkw/utils/dio.dart';
import 'package:newklikrkw/widgets/image_preview_dialog.dart';

class DkeluarbiayapermuserCard extends StatelessWidget {
  final Dkeluarbiayapermuser item;

  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool? withTranspermohonan;

  const DkeluarbiayapermuserCard({
    super.key,
    required this.item,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.withTranspermohonan = true,
  });

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    final dateFormat = DateFormat('dd MMM yyyy HH:mm', 'id');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///==============================
              /// Gambar
              ///==============================
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                clipBehavior: Clip.antiAlias,
                child: GestureDetector(
                  onTap: item.hasImage
                      ? () {
                          showDialog(
                            context: context,
                            barrierColor: Colors.black87,
                            builder: (_) => ImagePreviewDialog(
                              imageUrl:
                                  '$myBaseUrl${item.imageDkeluarbiayapermuser}',
                              heroTag: item.id,
                            ),
                          );
                        }
                      : null,
                  child: item.hasImage
                      ? Hero(
                          tag: item.id,
                          child: Container(
                            width: 60,
                            height: 60,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Image.network(
                              '$myBaseUrl${item.imageDkeluarbiayapermuser}',
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : const Icon(
                          Icons.receipt_long,
                          color: Colors.grey,
                          size: 36,
                        ),
                ),
              ),

              const SizedBox(width: 12),

              ///==============================
              /// Informasi
              ///==============================
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.itemkegiatan?.namaItemkegiatan ?? "-",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      currency.format(item.jumlahBiaya),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    if (item.ketBiaya.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          item.ketBiaya,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    const SizedBox(height: 8),
                    if (withTranspermohonan == true)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Wrap(
                          children: [
                            Text(
                              item.transpermohonan!.noDaftar,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Text(" | "),
                            Text(
                              item.transpermohonan!.namaPenerima,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Text(" | "),
                            Text(
                              item.transpermohonan!.alasHak,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Text(" | "),
                            Text(
                              item.transpermohonan!.letakObyek,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
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

              ///==============================
              /// Menu
              ///==============================
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
                  // PopupMenuItem(
                  //   value: "edit",
                  //   child: Row(
                  //     children: [
                  //       Icon(Icons.edit),
                  //       SizedBox(width: 8),
                  //       Text("Edit"),
                  //     ],
                  //   ),
                  // ),
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
