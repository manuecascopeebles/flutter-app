import 'package:flutter/foundation.dart';
import 'package:onboarding_flutter_wrapper/onboarding_flutter_wrapper.dart';
import 'package:onboarding_flutter_wrapper/src/models/modules/base_module.dart';

class ProcessIdModule extends BaseModule {
  @override
  String get name => 'ProcessId';

  final IdCategory? idCategory;
  final bool? enableIdSummaryScreen;

  ProcessIdModule({this.idCategory, this.enableIdSummaryScreen});

  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        'idCategory': idCategory != null ? describeEnum(idCategory!) : null,
        if (enableIdSummaryScreen != null)
          'enableIdSummaryScreen': enableIdSummaryScreen,
      };
}
