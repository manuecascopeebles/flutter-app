class QRScanResult {
  final bool success;

  QRScanResult(this.success);

  factory QRScanResult.fromJson(Map<String, dynamic> json) => QRScanResult(
        json['success'],
      );

  @override
  String toString() => 'QRScanResult: {success: $success}';
}
