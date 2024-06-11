import 'package:flutter/foundation.dart';

class FaceLogin {
  final bool showTutorials;
  final String? customerUUID;
  final FaceAuthMode faceAuthMode;
  final bool faceAuthModeFallback;
  final bool lensesCheck;
  final bool faceMaskCheck;
  final bool logAuthenticationEnabled;
  final double? recognitionThreshold;
  final double? spoofThreshold;

  FaceLogin(
      {this.showTutorials = true,
      this.customerUUID,
      this.faceAuthMode = FaceAuthMode.server,
      this.faceAuthModeFallback = false,
      this.lensesCheck = true,
      this.faceMaskCheck = false,
      this.logAuthenticationEnabled = true,
      this.recognitionThreshold,
      this.spoofThreshold});

  Map<String, dynamic> toJson() => {
        'showTutorials': showTutorials,
        if (customerUUID != null) 'customerUUID': customerUUID,
        'faceAuthMode': describeEnum(faceAuthMode),
        'faceAuthModeFallback': faceAuthModeFallback,
        'lensesCheck': lensesCheck,
        'faceMaskCheck': faceMaskCheck,
        'logAuthenticationEnabled': logAuthenticationEnabled,
        'recognitionThreshold': recognitionThreshold,
        'spoofThreshold': spoofThreshold
      };
}

enum FaceAuthMode {
  local,
  hybrid,
  server,
  kiosk, // server FR only on Android
}
