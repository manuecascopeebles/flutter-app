class GetUserOCRDataResult {
  final String? ocrData;

  GetUserOCRDataResult(this.ocrData);

  factory GetUserOCRDataResult.fromJson(Map<String, dynamic> json) =>
      GetUserOCRDataResult(
        json['ocrData'],
      );

  @override
  String toString() => 'GetUserOCRDataResult: {ocrData: $ocrData}';
}
