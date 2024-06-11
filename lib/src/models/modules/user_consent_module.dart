import 'package:flutter/foundation.dart';
import 'package:onboarding_flutter_wrapper/src/models/modules/base_module.dart';

class UserConsentModule extends BaseModule {
  @override
  String get name => 'UserConsent';

  final String? title;
  final String? content;

  UserConsentModule({
    this.title,
    this.content,
  });

  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        'title': title,
        'content': content,
      };
}
