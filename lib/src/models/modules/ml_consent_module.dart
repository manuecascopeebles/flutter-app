import 'package:flutter/foundation.dart';
import 'package:onboarding_flutter_wrapper/src/models/modules/base_module.dart';

class MLConsentModule extends BaseModule {
  @override
  String get name => 'MLConsent';

  final MLConsentType? type;

  MLConsentModule({
    this.type,
  });

  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type != null ? describeEnum(type!) : null,
      };
}

enum MLConsentType {
  gdpr,
  us,
}
