class OnboardingRecordSessionConfiguration {
  final bool recordSession;
  final bool forcePermission;

  OnboardingRecordSessionConfiguration(
      {this.recordSession = true, this.forcePermission = false});

  factory OnboardingRecordSessionConfiguration.fromJson(
          Map<String, dynamic> json) =>
      OnboardingRecordSessionConfiguration(
        recordSession: json['recordSession'],
        forcePermission: json['forcePermission'],
      );

  Map toJson() => {
        'recordSession': recordSession,
        'forcePermission': forcePermission,
      };

  @override
  String toString() =>
      'OnboardingRecordSessionConfiguration: {recordSession: $recordSession, forcePermission: $forcePermission}';
}
