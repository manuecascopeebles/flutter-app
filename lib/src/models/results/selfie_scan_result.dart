import 'dart:typed_data';

class SelfieScanResult {
  final Uint8List? image;
  final bool? spoofAttempt;
  final SelfieScanBase64Images base64Images;

  SelfieScanResult(this.image, this.spoofAttempt, this.base64Images);

  factory SelfieScanResult.fromJson(Map<String, dynamic> json) =>
      SelfieScanResult(
        json['image'],
        json['spoofAttempt'],
        SelfieScanBase64Images.fromJson(
            Map<String, dynamic>.from(json['base64Images'])),
      );

  @override
  String toString() =>
      'SelfieScanResult: {spoofAttempt: $spoofAttempt, image: $image, base64Images: $base64Images}';
}

class SelfieScanBase64Images {
  final String? selfieBase64;
  final String? selfieEncryptedBase64;

  SelfieScanBase64Images(this.selfieBase64, this.selfieEncryptedBase64);

  factory SelfieScanBase64Images.fromJson(Map<String, dynamic> json) =>
      SelfieScanBase64Images(
        json['selfieBase64'],
        json['selfieEncryptedBase64'],
      );

  @override
  String toString() =>
      'images: {selfieBase64: $selfieBase64, selfieEncryptedBase64: $selfieEncryptedBase64}';
}
