class GeoLocationResult {
  final String? city;
  final String? colony;
  final String? postalCode;
  final String? state;
  final String? street;

  GeoLocationResult(
    this.city,
    this.colony,
    this.postalCode,
    this.state,
    this.street,
  );

  factory GeoLocationResult.fromJson(Map<String, dynamic> json) =>
      GeoLocationResult(
        json['city'],
        json['colony'],
        json['postalCode'],
        json['state'],
        json['street'],
      );

  @override
  String toString() =>
      'GeoLocationResult: {city: $city, colony: $colony, postalCode: $postalCode, state: $state, street: $street}';
}
