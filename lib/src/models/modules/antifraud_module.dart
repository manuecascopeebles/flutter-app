import 'package:onboarding_flutter_wrapper/src/models/modules/base_module.dart';

class AntifraudModule extends BaseModule {
  @override
  String get name => 'Antifraud';

  @override
  Map<String, dynamic> toJson() => {'name': name};
}
