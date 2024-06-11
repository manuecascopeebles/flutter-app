import 'package:onboarding_flutter_wrapper/src/models/modules/base_module.dart';

class EmailModule extends BaseModule {
  @override
  String get name => 'Email';

  @override
  Map<String, dynamic> toJson() => {
    'name': name,
  };
}
