class DbOption {
  final String value;
  final String label;

  DbOption({required this.value, required this.label});

  factory DbOption.fromJson(Map<String, dynamic> json) =>
      DbOption(value: json['value'] as String, label: json['label'] as String);
}
