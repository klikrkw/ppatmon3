class ValidationError {
  final String message;
  final Map<String, List<String>> errors;

  ValidationError({required this.message, required this.errors});

  factory ValidationError.fromJson(Map<String, dynamic> json) {
    return ValidationError(
      message: json['message'] ?? '',
      errors: (json['errors'] as Map<String, dynamic>? ?? {}).map(
        (key, value) => MapEntry(key, List<String>.from(value)),
      ),
    );
  }

  String? firstError(String field) {
    return errors[field]?.first;
  }

  List<String> fieldErrors(String field) {
    return errors[field] ?? [];
  }

  String get allErrors {
    return errors.values.expand((e) => e).join('\n');
  }
}
