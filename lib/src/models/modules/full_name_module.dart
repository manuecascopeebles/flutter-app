import 'package:onboarding_flutter_wrapper/src/models/modules/base_module.dart';

class FullNameModule extends BaseModule {
  @override
  String get name => 'FullName';

  @override
  Map<String, dynamic> toJson() => {
    'name': name
  };
}
