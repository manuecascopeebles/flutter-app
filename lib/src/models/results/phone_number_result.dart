class PhoneNumberResult {
  final String phone;

  PhoneNumberResult(this.phone);

  factory PhoneNumberResult.fromJson(Map<String, dynamic> json) =>
      PhoneNumberResult(json['phone']);

  @override
  String toString() => 'PhoneNumberResult: {phone: $phone}';
}
