import 'package:newklikrkw/models/validation_error.dart';

class ValidationException implements Exception {
  final ValidationError validationError;

  ValidationException(this.validationError);

  @override
  String toString() {
    return validationError.message;
  }
}
