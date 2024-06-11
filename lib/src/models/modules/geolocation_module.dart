import 'package:onboarding_flutter_wrapper/src/models/modules/base_module.dart';

class GeoLocationModule extends BaseModule {
  @override
  String get name => 'Geolocation';

  @override
  Map<String, dynamic> toJson() => {'name': name};
}
