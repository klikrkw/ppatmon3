import 'package:flutter/material.dart';
import 'package:newklikrkw/models/transpermohonan.dart';
import 'package:newklikrkw/utils/utils.dart';

class CardTranspermohonan extends StatelessWidget {
  final Transpermohonan item;
  const CardTranspermohonan({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(item.noDaftar, style: Theme.of(context).textTheme.titleMedium),
            Text(item.tglDaftar, style: Theme.of(context).textTheme.titleSmall),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  item.namaPenerima,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                Text(
                  item.jenisPermohonan,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  item.alasHak,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const Spacer(),
                Text(
                  CommonUtils.truncate(item.letakObyek, 20),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  item.namaPelepas,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Spacer(),
                Text(
                  item.users.map((u) => u.name).join(', '),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
