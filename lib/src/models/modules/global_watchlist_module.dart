import 'package:onboarding_flutter_wrapper/src/models/modules/base_module.dart';

class GlobalWatchlistModule extends BaseModule {
  @override
  String get name => 'GlobalWatchlist';

  GlobalWatchlistModule();

  @override
  Map<String, dynamic> toJson() => {
        'name': name,
      };
}
