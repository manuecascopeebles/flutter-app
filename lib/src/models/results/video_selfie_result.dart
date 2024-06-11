class VideoSelfieResult {
  final bool success;

  VideoSelfieResult(this.success);

  factory VideoSelfieResult.fromJson(Map<String, dynamic> json) =>
      VideoSelfieResult(json['success']);

  @override
  String toString() => 'VideoSelfieResult: {success: $success}';
}
