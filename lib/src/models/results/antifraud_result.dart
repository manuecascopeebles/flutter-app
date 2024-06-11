class AntifraudResult {
  final bool success;

  AntifraudResult(this.success);

  factory AntifraudResult.fromJson(Map<String, dynamic> json) =>
      AntifraudResult(
        json['success'],
      );

  @override
  String toString() => 'AntifraudResult: {success: $success}';
}
