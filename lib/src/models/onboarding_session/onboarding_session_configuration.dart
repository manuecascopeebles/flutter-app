import 'package:flutter/foundation.dart';
import 'package:onboarding_flutter_wrapper/src/models/onboarding_session/conference_queue.dart';
import 'package:onboarding_flutter_wrapper/src/models/onboarding_session/onboarding_validation_module.dart';

class OnboardingSessionConfiguration {
  final String? userRegion;
  final ConferenceQueue? queue;
  final List<OnboardingValidationModule>? onboardingValidationModules;
  final Map<String, String>? customFields;
  final String? configurationId;
  final String? externalId;
  final String? interviewId;
  final String? token;

  OnboardingSessionConfiguration({
    this.userRegion,
    this.queue,
    this.onboardingValidationModules,
    this.customFields,
    this.configurationId,
    this.externalId,
    this.interviewId,
    this.token,
  });

  Map<String, dynamic> toJson() => {
        if (userRegion != null) 'userRegion': userRegion,
        if (queue != null) 'queue': describeEnum(queue!),
        if (configurationId != null) 'configurationId': configurationId,
        if (onboardingValidationModules != null)
          'onboardingValidationModules': onboardingValidationModules!
              .map((module) => describeEnum(module))
              .toList(),
        if (customFields != null) 'customFields': customFields,
        if (externalId != null) 'externalId': externalId,
        if (interviewId != null) 'interviewId': interviewId,
        if (token != null) 'token': token,
      };
}
