import 'package:onboarding_flutter_wrapper/src/models/modules/base_module.dart';

class SignatureModule extends BaseModule {
  @override
  String get name => 'Signature';

  @override
  Map<String, dynamic> toJson() => {'name': name};
}
