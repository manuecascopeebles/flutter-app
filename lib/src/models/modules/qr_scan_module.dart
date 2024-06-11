import 'package:onboarding_flutter_wrapper/src/models/modules/base_module.dart';

class QRScanModule extends BaseModule {
  @override
  String get name => 'QRScan';

  final bool? showTutorials;

  QRScanModule({this.showTutorials});

  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        if (showTutorials != null) 'showTutorials': showTutorials,
      };
}
