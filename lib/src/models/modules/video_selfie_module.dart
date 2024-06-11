import 'package:flutter/foundation.dart';
import 'package:onboarding_flutter_wrapper/src/models/modules/base_module.dart';

class VideoSelfieModule extends BaseModule {
  @override
  String get name => 'VideoSelfie';

  final bool? showTutorials;
  final SelfieScanMode? selfieScanMode;
  final bool? selfieLivenessCheck;
  final bool? showIdScan;
  final bool? showDocumentScan;
  final bool? showVoiceConsent;
  final int? voiceConsentQuestionsCount;
  final IdScanCameraFacing? idScanCameraFacing;

  VideoSelfieModule(
      {this.showTutorials,
      this.selfieScanMode,
      this.selfieLivenessCheck,
      this.showIdScan,
      this.showDocumentScan,
      this.showVoiceConsent,
      this.voiceConsentQuestionsCount,
      this.idScanCameraFacing});

  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        if (showTutorials != null) 'showTutorials': showTutorials,
        'selfieScanMode':
            selfieScanMode != null ? describeEnum(selfieScanMode!) : null,
        'selfieLivenessCheck': selfieLivenessCheck,
        'showIdScan': showIdScan,
        'showDocumentScan': showDocumentScan,
        'showVoiceConsent': showVoiceConsent,
        'voiceConsentQuestionsCount': voiceConsentQuestionsCount,
        'idScanCameraFacing': idScanCameraFacing != null
            ? describeEnum(idScanCameraFacing!)
            : null,
      };
}

enum SelfieScanMode {
  selfieMatch,
  faceMatch,
}

enum IdScanCameraFacing {
  back,
  front,
}
