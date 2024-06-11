import 'package:flutter/foundation.dart';
import 'package:onboarding_flutter_wrapper/onboarding_flutter_wrapper.dart';
import 'package:onboarding_flutter_wrapper/src/models/modules/base_module.dart';

class FaceMatchModule extends BaseModule {
  @override
  String get name => 'FaceMatch';

  final IdCategory? idCategory;

  FaceMatchModule({this.idCategory});

  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        'idCategory': idCategory != null ? describeEnum(idCategory!) : null,
      };
}
