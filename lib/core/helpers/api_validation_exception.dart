import 'package:newklikrkw/models/validation_error.dart';

class ApiValidationException implements Exception {
  final String message;
  final ValidationError validationError;

  const ApiValidationException({
    required this.message,
    required this.validationError,
  });

  @override
  String toString() {
    return 'ApiValidationException(message: $message)';
  }
}
