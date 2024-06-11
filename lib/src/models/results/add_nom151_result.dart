class AddNom151Result {
  final String? archiveUrl;
  final String? signature;

  AddNom151Result(this.archiveUrl, this.signature);

  factory AddNom151Result.fromJson(Map<String, dynamic> json) =>
      AddNom151Result(
        json['archiveUrl'],
        json['signature'],
      );

  @override
  String toString() =>
      'AddNom151Result: {archiveUrl: $archiveUrl, signature: $signature}';
}
