class MLConsentResult {
  final bool success;

  MLConsentResult(this.success);

  factory MLConsentResult.fromJson(Map<String, dynamic> json) =>
      MLConsentResult(
        json['success'],
      );

  @override
  String toString() => 'MLConsentResult: {success: $success}';
}
