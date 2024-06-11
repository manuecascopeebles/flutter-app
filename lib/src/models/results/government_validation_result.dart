class GovernmentValidationResult {
  final bool success;

  GovernmentValidationResult(this.success);

  factory GovernmentValidationResult.fromJson(Map<String, dynamic> json) =>
      GovernmentValidationResult(
        json['success'],
      );

  @override
  String toString() => 'GovernmentValidationResult: {success: $success}';
}
