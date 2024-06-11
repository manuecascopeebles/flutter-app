class CurpValidationResult {
  final String? curp;
  final bool? valid;
  final Map<String, dynamic>? data;

  CurpValidationResult(this.curp, this.valid, this.data);

  factory CurpValidationResult.fromJson(Map<String, dynamic> json) =>
      CurpValidationResult(
        json['curp'],
        json['valid'],
        Map<String, dynamic>.from(json['data']),
      );

  @override
  String toString() =>
      'CurpValidationResult: {curp: $curp, valid: $valid, data: $data}';
}
