import 'package:flutter/foundation.dart';
import 'package:onboarding_flutter_wrapper/src/models/modules/base_module.dart';

class UserScoreModule extends BaseModule {
  final UserScoreFetchMode? mode;

  UserScoreModule({this.mode});

  @override
  String get name => 'UserScore';

  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        if (mode != null) 'mode': describeEnum(mode!),
      };
}

enum UserScoreFetchMode {
  fast,
  accurate,
}
