import 'bayarbiayaperm.dart';

class BayarbiayapermResponse {
  final bool success;

  final List<Bayarbiayaperm> data;

  final String message;

  const BayarbiayapermResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  factory BayarbiayapermResponse.fromJson(Map<String, dynamic> json) {
    return BayarbiayapermResponse(
      success: json['success'] ?? false,

      data: (json['data'] as List)
          .map((e) => Bayarbiayaperm.fromJson(e))
          .toList(),

      message: json['message'] ?? '',
    );
  }
}
