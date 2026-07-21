import 'package:flutter/material.dart';
import 'package:newklikrkw/models/posisiberkas.dart';
import 'package:newklikrkw/models/tempatberkas.dart';

class RakGridWidget extends StatelessWidget {
  final Tempatberkas tempatberkas;
  final Posisiberkas? posisiberkas;
  final bool editing;

  final Function(int row, int col)? onTapCell;

  const RakGridWidget({
    super.key,
    required this.tempatberkas,
    this.posisiberkas,
    this.editing = false,
    this.onTapCell,
  });

  @override
  Widget build(BuildContext context) {
    final rowCount = tempatberkas.rowCount;
    final colCount = tempatberkas.colCount;

    return Column(
      children: List.generate(rowCount, (rowIndex) {
        return Row(
          children: List.generate(colCount, (colIndex) {
            final row = rowIndex + 1;

            final col = colIndex + 1;
            String code = '${String.fromCharCode(64 + row)}$col';

            final isCurrent =
                posisiberkas != null &&
                posisiberkas!.tempatberkas.id == tempatberkas.id &&
                posisiberkas!.row == row &&
                posisiberkas!.col == col;

            return Expanded(
              child: InkWell(
                onTap: () => editing ? onTapCell?.call(row, col) : null,
                child: Container(
                  margin: const EdgeInsets.all(4),

                  height: 70,

                  decoration: BoxDecoration(
                    color: isCurrent ? Colors.green : Colors.grey.shade200,

                    border: Border.all(),

                    borderRadius: BorderRadius.circular(8),
                  ),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isCurrent)
                        const Icon(Icons.folder, color: Colors.white),
                      Text(
                        code,
                        style: TextStyle(
                          color: isCurrent ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      }),
    );
  }
}
