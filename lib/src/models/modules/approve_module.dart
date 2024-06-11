import 'package:onboarding_flutter_wrapper/src/models/modules/base_module.dart';

class ApproveModule extends BaseModule {
  @override
  String get name => 'Approve';

  final bool? forceApproval;

  ApproveModule({this.forceApproval});

  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        if (forceApproval != null) 'forceApproval': forceApproval,
      };
}
