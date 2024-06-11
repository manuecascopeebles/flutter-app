import 'dart:typed_data';

class SignatureResult {
  final Uint8List? signature;

  SignatureResult(this.signature);

  factory SignatureResult.fromJson(Map<String, dynamic> json) =>
      SignatureResult(json['signature']);

  @override
  String toString() => 'SignatureResult: {signature: $signature}';
}
