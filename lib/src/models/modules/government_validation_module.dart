import 'package:onboarding_flutter_wrapper/src/models/modules/base_module.dart';

class GovernmentValidationModule extends BaseModule {
  @override
  String get name => 'GovernmentValidation';

  final bool? isBackgroundExecuted;

  GovernmentValidationModule({
    this.isBackgroundExecuted,
  });

  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        if (isBackgroundExecuted != null)
          'isBackgroundExecuted': isBackgroundExecuted,
      };
}
