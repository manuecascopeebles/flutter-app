import 'package:flutter/foundation.dart';
import 'package:onboarding_flutter_wrapper/onboarding_flutter_wrapper.dart';
import 'package:onboarding_flutter_wrapper/src/models/modules/base_module.dart';

class IdScanModule extends BaseModule {
  @override
  String get name => 'IdScan';

  final bool? showTutorials;
  final IdType? idType;
  final IdCategory? idCategory;
  final ScanStepType? scanStep;

  IdScanModule({
    this.showTutorials,
    this.idType,
    this.idCategory,
    this.scanStep,
  });

  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        if (showTutorials != null) 'showTutorials': showTutorials,
        'idType': idType != null ? describeEnum(idType!) : null,
        'idCategory': idCategory != null ? describeEnum(idCategory!) : null,
        'scanStep': scanStep != null ? describeEnum(scanStep!) : null,
      };
}

enum ScanStepType { front, back, both }
