class ApiValidationExtException implements Exception {
  final String message;

  final Map<String, List<String>> errors;

  const ApiValidationExtException({
    required this.message,
    required this.errors,
  });

  factory ApiValidationExtException.fromJson(Map<String, dynamic> json) {
    final Map<String, List<String>> validationErrors = {};

    if (json["errors"] != null) {
      final errors = json["errors"] as Map<String, dynamic>;

      for (final entry in errors.entries) {
        validationErrors[entry.key] = List<String>.from(entry.value);
      }
    }

    return ApiValidationExtException(
      message: json["message"] ?? "Validation Error",
      errors: validationErrors,
    );
  }

  String? firstError(String field) {
    if (!errors.containsKey(field)) {
      return null;
    }

    final fieldErrors = errors[field];

    if (fieldErrors == null || fieldErrors.isEmpty) {
      return null;
    }

    return fieldErrors.first;
  }

  @override
  String toString() {
    return message;
  }
}
