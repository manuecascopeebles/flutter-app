import 'package:onboarding_flutter_wrapper/src/models/modules/base_module.dart';

class CurpValidationModule extends BaseModule {
  @override
  String get name => 'CURPValidation';

  @override
  Map<String, dynamic> toJson() => {
        'name': name,
      };
}
