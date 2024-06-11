class CaptchaResult {
  final String? captcha;

  CaptchaResult(this.captcha);

  factory CaptchaResult.fromJson(Map<String, dynamic> json) => CaptchaResult(
        json['captcha'],
      );

  @override
  String toString() => 'CaptchaResult: {captcha: $captcha}';
}
