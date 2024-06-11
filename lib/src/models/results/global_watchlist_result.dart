class GlobalWatchlistResult {
  final bool success;

  GlobalWatchlistResult(this.success);

  factory GlobalWatchlistResult.fromJson(Map<String, dynamic> json) =>
      GlobalWatchlistResult(
        json['success'],
      );

  @override
  String toString() => 'GlobalWatchlistResult: {success: $success}';
}
