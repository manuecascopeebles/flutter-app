class UserConsentResult {
  final bool success;

  UserConsentResult(this.success);

  factory UserConsentResult.fromJson(Map<String, dynamic> json) =>
      UserConsentResult(
        json['success'],
      );

  @override
  String toString() => 'UserConsentResult: {success: $success}';
}
