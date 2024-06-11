import 'dart:typed_data';

import 'package:onboarding_flutter_wrapper/src/models/results/selfie_scan_result.dart';

class FaceLoginResult {
  final Uint8List? image;
  final bool? spoofAttempt;
  final SelfieScanBase64Images base64Images;
  final bool faceMatched;
  final String? customerUUID;
  final String? interviewId;
  final String? interviewToken;
  final String? token;
  final String? transactionId;

  /// Boolean indicator if person was wearing a face mask during login.
  /// Available in iOS only, Android will force the user to take the mask off before login is performed.
  final bool? hasFaceMask;

  /// Boolean indicator if person was wearing lenses during login.
  /// Available in iOS only, Android will force the user to take the lenses off before login is performed.
  final bool? hasLenses;

  FaceLoginResult(
      this.image,
      this.spoofAttempt,
      this.base64Images,
      this.faceMatched,
      this.customerUUID,
      this.interviewId,
      this.interviewToken,
      this.token,
      this.transactionId,
      this.hasFaceMask,
      this.hasLenses);

  factory FaceLoginResult.fromJson(Map<String, dynamic> json) =>
      FaceLoginResult(
          json['image'],
          json['spoofAttempt'],
          SelfieScanBase64Images.fromJson(
              Map<String, dynamic>.from(json['base64Images'])),
          json['faceMatched'],
          json['customerUUID'],
          json['interviewId'],
          json['interviewToken'],
          json['token'],
          json['transactionId'],
          json['hasFaceMask'],
          json['hasLenses']);

  @override
  String toString() =>
      'FaceLoginResult: {spoofAttempt: $spoofAttempt, faceMatched: $faceMatched, customerUUID: $customerUUID, interviewId: $interviewId, interviewToken: $interviewToken, token: $token, transactionId: $transactionId, hasFaceMask: $hasFaceMask, hasLenses: $hasLenses, image: $image, base64Images: $base64Images}';
}
