class AppFailure implements Exception {
  const AppFailure({
    required this.code,
    required this.message,
    this.details,
  });

  final String code;
  final String message;
  final Map<String, dynamic>? details;

  @override
  String toString() {
    return 'AppFailure(code: $code, message: $message, details: $details)';
  }
}

