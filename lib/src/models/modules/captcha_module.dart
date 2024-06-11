import 'package:onboarding_flutter_wrapper/src/models/modules/base_module.dart';

class CaptchaModule extends BaseModule {
  @override
  String get name => 'Captcha';

  @override
  Map<String, dynamic> toJson() => {
        'name': name,
      };
}
