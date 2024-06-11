class AddEmailResult {
  final String? email;

  AddEmailResult(this.email);

  factory AddEmailResult.fromJson(Map<String, dynamic> json) =>
      AddEmailResult(
        json['email'],
      );

  @override
  String toString() =>
      'AddEmailResult: {email: $email}';
}
