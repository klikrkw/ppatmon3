import 'package:newklikrkw/models/tempatberkas.dart';

class Posisiberkas {
  final String id;
  final Tempatberkas tempatberkas;
  final int row;
  final int col;

  const Posisiberkas({
    required this.id,
    required this.tempatberkas,
    required this.row,
    required this.col,
  });

  factory Posisiberkas.fromJson(Map<String, dynamic> json) {
    return Posisiberkas(
      id: json['id']?.toString() ?? '',

      tempatberkas: Tempatberkas.fromJson(
        json['tempatberkas'] ?? json['tempatberkas_id'] ?? {},
      ),

      row: json['row'] ?? 0,

      col: json['col'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,

      'tempatberkas': tempatberkas.toJson(),

      'row': row,

      'col': col,
    };
  }

  Posisiberkas copyWith({
    String? id,
    Tempatberkas? tempatberkas,
    int? row,
    int? col,
  }) {
    return Posisiberkas(
      id: id ?? this.id,
      tempatberkas: tempatberkas ?? this.tempatberkas,
      row: row ?? this.row,
      col: col ?? this.col,
    );
  }

  @override
  String toString() {
    return 'Posisiberkas(id: $id, row: $row, col: $col)';
  }
}
