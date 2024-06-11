import 'package:onboarding_flutter_wrapper/src/models/modules/base_module.dart';

class PhoneModule extends BaseModule {
  @override
  String get name => 'Phone';

  final int? defaultRegionPrefix;

  PhoneModule({
    this.defaultRegionPrefix,
  });

  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        if (defaultRegionPrefix != null)
          'defaultRegionPrefix': defaultRegionPrefix,
      };
}
