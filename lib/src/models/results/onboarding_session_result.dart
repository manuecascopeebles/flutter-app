class OnboardingSessionResult {
  final String? interviewId;
  final String? regionCode;
  final String? token;

  OnboardingSessionResult(this.interviewId, this.regionCode, this.token);

  factory OnboardingSessionResult.fromJson(Map<String, dynamic> json) =>
      OnboardingSessionResult(
        json['interviewId'],
        json['regionCode'],
        json['token'],
      );

  @override
  String toString() =>
      'OnboardingSessionResult: {interviewId: $interviewId, regionCode: $regionCode, token: $token}';
}
