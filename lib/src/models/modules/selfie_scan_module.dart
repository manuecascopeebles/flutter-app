import 'package:onboarding_flutter_wrapper/src/models/modules/base_module.dart';

class SelfieScanModule extends BaseModule {
  @override
  String get name => 'SelfieScan';

  final bool? showTutorials;

  SelfieScanModule({this.showTutorials});

  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        if (showTutorials != null) 'showTutorials': showTutorials,
      };
}
