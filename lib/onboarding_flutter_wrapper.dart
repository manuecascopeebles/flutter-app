import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:onboarding_flutter_wrapper/src/models/face_info.dart';
import 'package:onboarding_flutter_wrapper/src/models/face_login.dart';
import 'package:onboarding_flutter_wrapper/src/models/results/qr_scan_result.dart';
import 'package:onboarding_flutter_wrapper/src/models/sdk_mode.dart';
import 'package:onboarding_flutter_wrapper/src/models/incode_sdk_init_error.dart';
import 'package:onboarding_flutter_wrapper/src/models/onboarding_flow_configuration.dart';
import 'package:onboarding_flutter_wrapper/src/models/onboarding_record_session_configuration.dart';
import 'package:onboarding_flutter_wrapper/src/models/onboarding_session/onboarding_session_configuration.dart';
import 'package:onboarding_flutter_wrapper/src/models/results/results.dart';
import 'package:onboarding_flutter_wrapper/src/models/modules/user_score_module.dart';

export 'src/models/onboarding_flow_configuration.dart'
    show OnboardingFlowConfiguration;
export 'src/models/id_category.dart';
export 'src/models/id_type.dart';
export 'src/models/face_info.dart';
export 'src/models/modules/id_scan_module.dart' show ScanStepType;
export 'src/models/modules/user_score_module.dart' show UserScoreFetchMode;
export 'src/models/modules/video_selfie_module.dart' show SelfieScanMode;
export 'src/models/modules/video_selfie_module.dart' show IdScanCameraFacing;
export 'src/models/results/results.dart';
export 'src/models/onboarding_session/onboarding_session_configuration.dart';
export 'package:onboarding_flutter_wrapper/src/models/onboarding_record_session_configuration.dart';
export 'src/models/onboarding_session/conference_queue.dart';
export 'src/models/onboarding_session/onboarding_validation_module.dart';
export 'src/models/modules/document_scan_module.dart';
export 'src/models/sdk_mode.dart';
export 'src/models/face_login.dart';
export 'src/models/modules/ml_consent_module.dart' show MLConsentType;
export 'src/models/modules/qr_scan_module.dart';

class IncodeOnboardingSdk {
  static const EventChannel _eventChannel =
      const EventChannel('onboarding_flutter_wrapper/event');
  static const MethodChannel _methodChannel =
      const MethodChannel('onboarding_flutter_wrapper/method');

  static void init({
    bool loggingEnabled = true,
    String? apiKey,
    String? apiUrl,
    bool? testMode,
    bool? waitForTutorials,
    bool? disableJailbreakDetection,
    bool? externalAnalyticsEnabled,
    bool? externalScreenshotsEnabled,
    bool? disableEmulatorDetection,
    bool? disableRootDetection,
    bool? disableHookDetection,
    required Function() onSuccess,
    required Function(String error) onError,
  }) async {
    Map<dynamic, dynamic>? result =
        await _methodChannel.invokeMethod<Map<dynamic, dynamic>>(
      'initialize',
      <String, dynamic>{
        'apiKey': apiKey,
        'apiUrl': apiUrl,
        'loggingEnabled': loggingEnabled,
        'testMode': testMode ?? kDebugMode,
        'waitForTutorials': waitForTutorials,
        'disableJailbreakDetection': disableJailbreakDetection,
        'externalAnalyticsEnabled': externalAnalyticsEnabled,
        'externalScreenshotsEnabled': externalScreenshotsEnabled,
        'disableEmulatorDetection': disableEmulatorDetection,
        'disableRootDetection': disableRootDetection,
        'disableHookDetection': disableHookDetection,
      },
    );
    if (result == null) {
      print('Unknown error');
      onError('Unknown error');
      return;
    }

    if (result['success'] == false) {
      print(result['error']);
      onError(result['error']);
      return;
    }
    onSuccess();
  }

  static void startOnboarding({
    required OnboardingSessionConfiguration sessionConfig,
    required OnboardingFlowConfiguration flowConfig,
    OnboardingRecordSessionConfiguration? recordSessionConfig,
    required Function() onSuccess,
    required Function(String error) onError,
    Function(SelfieScanResult result)? onSelfieScanCompleted,
    Function(FaceMatchResult result)? onFaceMatchCompleted,
    Function(GeoLocationResult result)? onGeolocationCompleted,
    Function(PhoneNumberResult result)? onAddPhoneNumberCompleted,
    Function(VideoSelfieResult result)? onVideoSelfieCompleted,
    Function(OnboardingSessionResult result)? onOnboardingSessionCreated,
    Function(ApprovalResult result)? onApproveCompleted,
    Function(UserScoreResult result)? onUserScoreFetched,
    Function(GovernmentValidationResult result)?
        onGovernmentValidationCompleted,
    Function(AntifraudResult result)? onAntifraudCompleted,
    Function(DocumentScanResult result)? onDocumentScanCompleted,
    Function(SignatureResult result)? onSignatureCollected,
    Function(CaptchaResult result)? onCaptchaCompleted,
    Function(CurpValidationResult result)? onCurpValidationCompleted,
    Function(IdScanResult result)? onIdFrontCompleted,
    Function(IdScanResult result)? onIdBackCompleted,
    Function(String ocrData)? onIdProcessed,
    Function(AddEmailResult result)? onAddEmailCompleted,
    Function(AddFullNameResult result)? onAddFullNameCompleted,
    Function(MLConsentResult result)? onMLConsentCompleted,
    Function(UserConsentResult result)? onUserConsentCompleted,
    Function(QRScanResult result)? onQRScanCompleted,
    Function(GlobalWatchlistResult result)? onGlobalWatchlistCompleted,
    Function()? onUserCancelled,
  }) async {
    _startOnboarding(
      configJson: <String, dynamic>{
        'sessionConfig': sessionConfig.toJson(),
        'flowConfig': flowConfig.toJson(),
        'recordSessionConfig': recordSessionConfig?.toJson(),
      },
      method: 'startOnboarding',
      onError: onError,
      onSuccess: onSuccess,
      onSelfieScanCompleted: onSelfieScanCompleted,
      onFaceMatchCompleted: onFaceMatchCompleted,
      onGeolocationCompleted: onGeolocationCompleted,
      onAddPhoneNumberCompleted: onAddPhoneNumberCompleted,
      onVideoSelfieCompleted: onVideoSelfieCompleted,
      onOnboardingSessionCreated: onOnboardingSessionCreated,
      onApproveCompleted: onApproveCompleted,
      onUserScoreFetched: onUserScoreFetched,
      onGovernmentValidationCompleted: onGovernmentValidationCompleted,
      onAntifraudCompleted: onAntifraudCompleted,
      onDocumentScanCompleted: onDocumentScanCompleted,
      onSignatureCollected: onSignatureCollected,
      onCaptchaCompleted: onCaptchaCompleted,
      onCurpValidationCompleted: onCurpValidationCompleted,
      onIdFrontCompleted: onIdFrontCompleted,
      onIdBackCompleted: onIdBackCompleted,
      onIdProcessed: onIdProcessed,
      onUserCancelled: onUserCancelled,
      onAddEmailCompleted: onAddEmailCompleted,
      onAddFullNameCompleted: onAddFullNameCompleted,
      onMLConsentCompleted: onMLConsentCompleted,
      onUserConsentCompleted: onUserConsentCompleted,
      onQRScanCompleted: onQRScanCompleted,
    );
  }

  static void startNewOnboardingSection({
    required OnboardingFlowConfiguration flowConfig,
    String? flowTag,
    OnboardingRecordSessionConfiguration? recordSessionConfig,
    required Function(String error) onError,
    Function(SelfieScanResult result)? onSelfieScanCompleted,
    Function(FaceMatchResult result)? onFaceMatchCompleted,
    Function(GeoLocationResult result)? onGeolocationCompleted,
    Function(PhoneNumberResult result)? onAddPhoneNumberCompleted,
    Function(VideoSelfieResult result)? onVideoSelfieCompleted,
    Function(OnboardingSessionResult result)? onOnboardingSessionCreated,
    Function(ApprovalResult result)? onApproveCompleted,
    Function(UserScoreResult result)? onUserScoreFetched,
    Function(GovernmentValidationResult result)?
        onGovernmentValidationCompleted,
    Function(AntifraudResult result)? onAntifraudCompleted,
    Function(DocumentScanResult result)? onDocumentScanCompleted,
    Function(SignatureResult result)? onSignatureCollected,
    Function(CaptchaResult result)? onCaptchaCompleted,
    Function(CurpValidationResult result)? onCurpValidationCompleted,
    Function(IdScanResult result)? onIdFrontCompleted,
    Function(IdScanResult result)? onIdBackCompleted,
    Function(AddEmailResult result)? onAddEmailCompleted,
    Function(AddFullNameResult result)? onAddFullNameCompleted,
    Function(MLConsentResult result)? onMLConsentCompleted,
    Function(UserConsentResult result)? onUserConsentCompleted,
    Function(QRScanResult result)? onQRScanCompleted,
    Function(GlobalWatchlistResult result)? onGlobalWatchlistCompleted,
    Function(String ocrData)? onIdProcessed,
    Function()? onUserCancelled,
    Function(String flowTag)? onOnboardingSectionCompleted,
  }) async {
    _startOnboarding(
      configJson: <String, dynamic>{
        'flowConfig': flowConfig.toJson(),
        if (flowTag != null) 'flowTag': flowTag,
        'recordSessionConfig': recordSessionConfig?.toJson(),
      },
      method: 'startNewOnboardingSection',
      onError: onError,
      onSuccess: () {},
      onSelfieScanCompleted: onSelfieScanCompleted,
      onFaceMatchCompleted: onFaceMatchCompleted,
      onGeolocationCompleted: onGeolocationCompleted,
      onAddPhoneNumberCompleted: onAddPhoneNumberCompleted,
      onVideoSelfieCompleted: onVideoSelfieCompleted,
      onOnboardingSessionCreated: onOnboardingSessionCreated,
      onApproveCompleted: onApproveCompleted,
      onUserScoreFetched: onUserScoreFetched,
      onGovernmentValidationCompleted: onGovernmentValidationCompleted,
      onAntifraudCompleted: onAntifraudCompleted,
      onDocumentScanCompleted: onDocumentScanCompleted,
      onSignatureCollected: onSignatureCollected,
      onCaptchaCompleted: onCaptchaCompleted,
      onCurpValidationCompleted: onCurpValidationCompleted,
      onAddEmailCompleted: onAddEmailCompleted,
      onIdFrontCompleted: onIdFrontCompleted,
      onIdBackCompleted: onIdBackCompleted,
      onAddFullNameCompleted: onAddFullNameCompleted,
      onMLConsentCompleted: onMLConsentCompleted,
      onUserConsentCompleted: onUserConsentCompleted,
      onQRScanCompleted: onQRScanCompleted,
      onIdProcessed: onIdProcessed,
      onUserCancelled: onUserCancelled,
      onOnboardingSectionCompleted: onOnboardingSectionCompleted,
    );
  }

  static void startWorkflow({
    required OnboardingSessionConfiguration sessionConfig,
    required Function() onSuccess,
    required Function(String error) onError,
    Function(SelfieScanResult result)? onSelfieScanCompleted,
    Function(FaceMatchResult result)? onFaceMatchCompleted,
    Function(GeoLocationResult result)? onGeolocationCompleted,
    Function(PhoneNumberResult result)? onAddPhoneNumberCompleted,
    Function(VideoSelfieResult result)? onVideoSelfieCompleted,
    Function(OnboardingSessionResult result)? onOnboardingSessionCreated,
    Function(ApprovalResult result)? onApproveCompleted,
    Function(UserScoreResult result)? onUserScoreFetched,
    Function(GovernmentValidationResult result)?
        onGovernmentValidationCompleted,
    Function(DocumentScanResult result)? onDocumentScanCompleted,
    Function(SignatureResult result)? onSignatureCollected,
    Function(CaptchaResult result)? onCaptchaCompleted,
    Function(CurpValidationResult result)? onCurpValidationCompleted,
    Function(IdScanResult result)? onIdFrontCompleted,
    Function(IdScanResult result)? onIdBackCompleted,
    Function(String ocrData)? onIdProcessed,
    Function(AddEmailResult result)? onAddEmailCompleted,
    Function(AddFullNameResult result)? onAddFullNameCompleted,
    Function(MLConsentResult result)? onMLConsentCompleted,
    Function(QRScanResult result)? onQRScanCompleted,
    Function(GlobalWatchlistResult result)? onGlobalWatchlistCompleted,
    Function()? onUserCancelled,
  }) async {
    _startOnboarding(
      configJson: <String, dynamic>{
        'sessionConfig': sessionConfig.toJson(),
      },
      method: 'startWorkflow',
      onError: onError,
      onSuccess: onSuccess,
      onSelfieScanCompleted: onSelfieScanCompleted,
      onFaceMatchCompleted: onFaceMatchCompleted,
      onGeolocationCompleted: onGeolocationCompleted,
      onAddPhoneNumberCompleted: onAddPhoneNumberCompleted,
      onVideoSelfieCompleted: onVideoSelfieCompleted,
      onOnboardingSessionCreated: onOnboardingSessionCreated,
      onApproveCompleted: onApproveCompleted,
      onUserScoreFetched: onUserScoreFetched,
      onGovernmentValidationCompleted: onGovernmentValidationCompleted,
      onDocumentScanCompleted: onDocumentScanCompleted,
      onSignatureCollected: onSignatureCollected,
      onCaptchaCompleted: onCaptchaCompleted,
      onCurpValidationCompleted: onCurpValidationCompleted,
      onIdFrontCompleted: onIdFrontCompleted,
      onIdBackCompleted: onIdBackCompleted,
      onIdProcessed: onIdProcessed,
      onUserCancelled: onUserCancelled,
      onAddEmailCompleted: onAddEmailCompleted,
      onAddFullNameCompleted: onAddFullNameCompleted,
      onMLConsentCompleted: onMLConsentCompleted,
      onQRScanCompleted: onQRScanCompleted,
    );
  }

  static void startFlow({
    required OnboardingSessionConfiguration sessionConfig,
    String? moduleId,
    required Function() onSuccess,
    required Function(String error) onError,
    Function(SelfieScanResult result)? onSelfieScanCompleted,
    Function(FaceMatchResult result)? onFaceMatchCompleted,
    Function(GeoLocationResult result)? onGeolocationCompleted,
    Function(PhoneNumberResult result)? onAddPhoneNumberCompleted,
    Function(VideoSelfieResult result)? onVideoSelfieCompleted,
    Function(OnboardingSessionResult result)? onOnboardingSessionCreated,
    Function(ApprovalResult result)? onApproveCompleted,
    Function(UserScoreResult result)? onUserScoreFetched,
    Function(GovernmentValidationResult result)?
        onGovernmentValidationCompleted,
    Function(DocumentScanResult result)? onDocumentScanCompleted,
    Function(SignatureResult result)? onSignatureCollected,
    Function(CaptchaResult result)? onCaptchaCompleted,
    Function(CurpValidationResult result)? onCurpValidationCompleted,
    Function(IdScanResult result)? onIdFrontCompleted,
    Function(IdScanResult result)? onIdBackCompleted,
    Function(String ocrData)? onIdProcessed,
    Function(AddEmailResult result)? onAddEmailCompleted,
    Function(AddFullNameResult result)? onAddFullNameCompleted,
    Function(MLConsentResult result)? onMLConsentCompleted,
    Function(QRScanResult result)? onQRScanCompleted,
    Function(GlobalWatchlistResult result)? onGlobalWatchlistCompleted,
    Function()? onUserCancelled,
  }) async {
    _startOnboarding(
      configJson: <String, dynamic>{
        'sessionConfig': sessionConfig.toJson(),
        if (moduleId != null) 'moduleId': moduleId,
      },
      method: 'startFlow',
      onError: onError,
      onSuccess: onSuccess,
      onSelfieScanCompleted: onSelfieScanCompleted,
      onFaceMatchCompleted: onFaceMatchCompleted,
      onGeolocationCompleted: onGeolocationCompleted,
      onAddPhoneNumberCompleted: onAddPhoneNumberCompleted,
      onVideoSelfieCompleted: onVideoSelfieCompleted,
      onOnboardingSessionCreated: onOnboardingSessionCreated,
      onApproveCompleted: onApproveCompleted,
      onUserScoreFetched: onUserScoreFetched,
      onGovernmentValidationCompleted: onGovernmentValidationCompleted,
      onDocumentScanCompleted: onDocumentScanCompleted,
      onSignatureCollected: onSignatureCollected,
      onCaptchaCompleted: onCaptchaCompleted,
      onCurpValidationCompleted: onCurpValidationCompleted,
      onIdFrontCompleted: onIdFrontCompleted,
      onIdBackCompleted: onIdBackCompleted,
      onIdProcessed: onIdProcessed,
      onUserCancelled: onUserCancelled,
      onAddEmailCompleted: onAddEmailCompleted,
      onAddFullNameCompleted: onAddFullNameCompleted,
      onMLConsentCompleted: onMLConsentCompleted,
      onQRScanCompleted: onQRScanCompleted,
    );
  }

  static void startFlowFromDeepLink({
    required String url,
    required Function() onSuccess,
    required Function(String error) onError,
    Function(SelfieScanResult result)? onSelfieScanCompleted,
    Function(FaceMatchResult result)? onFaceMatchCompleted,
    Function(GeoLocationResult result)? onGeolocationCompleted,
    Function(PhoneNumberResult result)? onAddPhoneNumberCompleted,
    Function(VideoSelfieResult result)? onVideoSelfieCompleted,
    Function(OnboardingSessionResult result)? onOnboardingSessionCreated,
    Function(ApprovalResult result)? onApproveCompleted,
    Function(UserScoreResult result)? onUserScoreFetched,
    Function(GovernmentValidationResult result)?
        onGovernmentValidationCompleted,
    Function(DocumentScanResult result)? onDocumentScanCompleted,
    Function(SignatureResult result)? onSignatureCollected,
    Function(CaptchaResult result)? onCaptchaCompleted,
    Function(CurpValidationResult result)? onCurpValidationCompleted,
    Function(IdScanResult result)? onIdFrontCompleted,
    Function(IdScanResult result)? onIdBackCompleted,
    Function(String ocrData)? onIdProcessed,
    Function(AddEmailResult result)? onAddEmailCompleted,
    Function(AddFullNameResult result)? onAddFullNameCompleted,
    Function(MLConsentResult result)? onMLConsentCompleted,
    Function(QRScanResult result)? onQRScanCompleted,
    Function(GlobalWatchlistResult result)? onGlobalWatchlistCompleted,
    Function()? onUserCancelled,
  }) async {
    _startOnboarding(
      configJson: <String, dynamic>{
        'url': url,
      },
      method: 'startFlowFromDeepLink',
      onError: onError,
      onSuccess: onSuccess,
      onSelfieScanCompleted: onSelfieScanCompleted,
      onFaceMatchCompleted: onFaceMatchCompleted,
      onGeolocationCompleted: onGeolocationCompleted,
      onAddPhoneNumberCompleted: onAddPhoneNumberCompleted,
      onVideoSelfieCompleted: onVideoSelfieCompleted,
      onOnboardingSessionCreated: onOnboardingSessionCreated,
      onApproveCompleted: onApproveCompleted,
      onUserScoreFetched: onUserScoreFetched,
      onGovernmentValidationCompleted: onGovernmentValidationCompleted,
      onDocumentScanCompleted: onDocumentScanCompleted,
      onSignatureCollected: onSignatureCollected,
      onCaptchaCompleted: onCaptchaCompleted,
      onCurpValidationCompleted: onCurpValidationCompleted,
      onIdFrontCompleted: onIdFrontCompleted,
      onIdBackCompleted: onIdBackCompleted,
      onIdProcessed: onIdProcessed,
      onUserCancelled: onUserCancelled,
      onAddEmailCompleted: onAddEmailCompleted,
      onAddFullNameCompleted: onAddFullNameCompleted,
      onMLConsentCompleted: onMLConsentCompleted,
      onQRScanCompleted: onQRScanCompleted,
    );
  }

  static void _startOnboarding({
    required String method,
    required Map<String, dynamic> configJson,
    required Function() onSuccess,
    required Function(String error) onError,
    Function(SelfieScanResult result)? onSelfieScanCompleted,
    Function(FaceMatchResult result)? onFaceMatchCompleted,
    Function(GeoLocationResult result)? onGeolocationCompleted,
    Function(PhoneNumberResult result)? onAddPhoneNumberCompleted,
    Function(VideoSelfieResult result)? onVideoSelfieCompleted,
    Function(OnboardingSessionResult result)? onOnboardingSessionCreated,
    Function(ApprovalResult result)? onApproveCompleted,
    Function(UserScoreResult result)? onUserScoreFetched,
    Function(GovernmentValidationResult result)?
        onGovernmentValidationCompleted,
    Function(AntifraudResult result)? onAntifraudCompleted,
    Function(DocumentScanResult result)? onDocumentScanCompleted,
    Function(SignatureResult result)? onSignatureCollected,
    Function(CaptchaResult result)? onCaptchaCompleted,
    Function(CurpValidationResult result)? onCurpValidationCompleted,
    Function(IdScanResult result)? onIdFrontCompleted,
    Function(IdScanResult result)? onIdBackCompleted,
    Function(AddFullNameResult result)? onAddFullNameCompleted,
    Function(MLConsentResult result)? onMLConsentCompleted,
    Function(UserConsentResult result)? onUserConsentCompleted,
    Function(QRScanResult result)? onQRScanCompleted,
    Function(GlobalWatchlistResult result)? onGlobalWatchlistCompleted,
    Function(String ocrData)? onIdProcessed,
    Function(AddEmailResult result)? onAddEmailCompleted,
    Function()? onUserCancelled,
    Function(String flowTag)? onOnboardingSectionCompleted,
  }) async {
    StreamSubscription? subscription;
    subscription = _eventChannel.receiveBroadcastStream().listen(
      (data) {
        Map<String, dynamic> jsonResult = Map<String, dynamic>.from(data);
        Map<String, dynamic> jsonData = Map<String, dynamic>.from(
            jsonResult['data'] != null ? jsonResult['data'] : {});

        switch (jsonResult['code']) {
          case 'onSelfieScanCompleted':
            print('onSelfieScanCompleted');
            if (onSelfieScanCompleted != null) {
              onSelfieScanCompleted(SelfieScanResult.fromJson(jsonData));
            }
            break;
          case 'onFaceMatchCompleted':
            print('onFaceMatchCompleted');
            if (onFaceMatchCompleted != null) {
              onFaceMatchCompleted(FaceMatchResult.fromJson(jsonData));
            }
            break;
          case 'onGeolocationCompleted':
            print('onGeolocationCompleted');
            if (onGeolocationCompleted != null) {
              onGeolocationCompleted(GeoLocationResult.fromJson(jsonData));
            }
            break;
          case 'onAddPhoneNumberCompleted':
            print('onAddPhoneNumberCompleted');
            if (onAddPhoneNumberCompleted != null) {
              onAddPhoneNumberCompleted(PhoneNumberResult.fromJson(jsonData));
            }
            break;
          case 'onVideoSelfieCompleted':
            print('onVideoSelfieCompleted');
            if (onVideoSelfieCompleted != null) {
              onVideoSelfieCompleted(VideoSelfieResult.fromJson(jsonData));
            }
            break;
          case 'onMLConsentCompleted':
            print('onMLConsentCompleted');
            if (onMLConsentCompleted != null) {
              onMLConsentCompleted(MLConsentResult.fromJson(jsonData));
            }
            break;
          case 'onUserConsentCompleted':
            print('onUserConsentCompleted');
            if (onUserConsentCompleted != null) {
              onUserConsentCompleted(UserConsentResult.fromJson(jsonData));
            }
            break;
          case 'onOnboardingSessionCreated':
            print('onOnboardingSessionCreated');
            if (onOnboardingSessionCreated != null) {
              onOnboardingSessionCreated(
                  OnboardingSessionResult.fromJson(jsonData));
            }
            break;
          case 'onApproveCompleted':
            print('onApproveCompleted');
            if (onApproveCompleted != null) {
              onApproveCompleted(ApprovalResult.fromJson(jsonData));
            }
            break;
          case 'onUserScoreFetched':
            print('onUserScoreFetched');
            if (onUserScoreFetched != null) {
              onUserScoreFetched(UserScoreResult.fromJson(jsonData));
            }
            break;
          case 'onUserCancelled':
            print('onUserCancelled');
            if (onUserCancelled != null) {
              onUserCancelled();
            }
            break;
          case 'onGovernmentValidationCompleted':
            print('onGovernmentValidationCompleted');
            if (onGovernmentValidationCompleted != null) {
              onGovernmentValidationCompleted(
                  GovernmentValidationResult.fromJson(jsonData));
            }
            break;
          case 'onAntifraudCompleted':
            print('onAntifraudCompleted');
            if (onAntifraudCompleted != null) {
              onAntifraudCompleted(AntifraudResult.fromJson(jsonData));
            }
            break;
          case 'onOnboardingSectionCompleted':
            print('onOnboardingSectionCompleted');
            if (onOnboardingSectionCompleted != null) {
              onOnboardingSectionCompleted(jsonData['flowTag']);
            }
            break;
          case 'onDocumentScanCompleted':
            print('onDocumentScanCompleted');
            if (onDocumentScanCompleted != null) {
              onDocumentScanCompleted(DocumentScanResult.fromJson(jsonData));
            }
            break;
          case 'onSignatureCollected':
            print('onSignatureCollected');
            if (onSignatureCollected != null) {
              onSignatureCollected(SignatureResult.fromJson(jsonData));
            }
            break;
          case 'onCaptchaCompleted':
            print('onCaptchaCompleted');
            if (onCaptchaCompleted != null) {
              onCaptchaCompleted(CaptchaResult.fromJson(jsonData));
            }
            break;
          case 'onCURPValidationCompleted':
            print('onCURPValidationCompleted');
            if (onCurpValidationCompleted != null) {
              onCurpValidationCompleted(
                  CurpValidationResult.fromJson(jsonData));
            }
            break;
          case 'onAddEmailCompleted':
            print('onAddEmailCompleted');
            if (onAddEmailCompleted != null) {
              onAddEmailCompleted(AddEmailResult.fromJson(jsonData));
            }
            break;

          case 'onIdFrontCompleted':
            print('onIdFrontCompleted');
            if (onIdFrontCompleted != null) {
              onIdFrontCompleted(IdScanResult.fromJson(jsonData));
            }
            break;
          case 'onIdBackCompleted':
            print('onIdBackCompleted');
            if (onIdBackCompleted != null) {
              onIdBackCompleted(IdScanResult.fromJson(jsonData));
            }
            break;
          case 'onIdProcessed':
            print('onIdProcessed');
            if (onIdProcessed != null) {
              onIdProcessed(jsonData['ocrData']);
            }
            break;
          case 'onAddFullNameCompleted':
            print('onAddFullNameCompleted');
            if (onAddFullNameCompleted != null) {
              onAddFullNameCompleted(AddFullNameResult.fromJson(jsonData));
            }
            break;
          case 'onQRScanCompleted':
            print('onQRScanCompleted');
            if (onQRScanCompleted != null) {
              onQRScanCompleted(QRScanResult.fromJson(jsonData));
            }
            break;
          case 'onGlobalWatchlistCompleted':
            print('onGlobalWatchlistCompleted');
            if (onGlobalWatchlistCompleted != null) {
              onGlobalWatchlistCompleted(
                  GlobalWatchlistResult.fromJson(jsonData));
            }
            break;

          default:
            print('Not supported');
        }
      },
      onError: (error) {
        // PlatformException
        onError(error.message ?? 'Unknown error');
        subscription?.cancel();
      },
      onDone: () {
        onSuccess();
        subscription?.cancel();
      },
    );

    _methodChannel.invokeMethod<Map<dynamic, dynamic>>(
      method,
      configJson,
    );
  }

  static Future<void> finishFlow({
    Function()? onSuccess,
    Function(String error)? onError,
  }) async {
    Map<dynamic, dynamic>? result =
        await _methodChannel.invokeMethod<Map<dynamic, dynamic>>('finishFlow');
    if (result == null) {
      print('Unknown error');
      if (onError != null) {
        onError('Unknown error');
      }
      return;
    }

    if (result['success'] == false) {
      print(result['error']);
      if (onError != null) {
        onError(result['error']);
      }
      return;
    }
    print(result);
    if (onSuccess != null) {
      onSuccess();
    }
  }

  static Future<void> setupOnboardingSession({
    required OnboardingSessionConfiguration sessionConfig,
    required Function(OnboardingSessionResult result) onSuccess,
    required Function(String error) onError,
  }) async {
    Map<dynamic, dynamic>? result =
        await _methodChannel.invokeMethod<Map<dynamic, dynamic>>(
      'setupOnboardingSession',
      {
        'sessionConfig': sessionConfig.toJson(),
      },
    );
    if (result == null) {
      print('Unknown error');
      onError('Unknown error');
      return;
    }

    if (result['success'] == false) {
      print(result['error']);
      onError(result['error']);
      return;
    }
    onSuccess(
      OnboardingSessionResult.fromJson(
        Map<String, dynamic>.from(result['data']),
      ),
    );
  }

  static Future<void> setTheme({
    required Map<String, dynamic> theme,
  }) async {
    if (Platform.isIOS) {
      await _methodChannel
          .invokeMethod('setTheme', {'theme': jsonEncode(theme)});
    }
  }

  static Future<void> setSdkMode({required SdkMode sdkMode}) async {
    await _methodChannel
        .invokeMethod('setSdkMode', {'sdkMode': describeEnum(sdkMode)});
  }

  static Future<void> showCloseButton({required bool allowUserToCancel}) async {
    await _methodChannel.invokeMethod(
        'showCloseButton', {'allowUserToCancel': allowUserToCancel});
  }

  static Future<void> setLocalizationLanguage(
      {required String language}) async {
    await _methodChannel
        .invokeMethod('setLocalizationLanguage', {'language': language});
  }

  static Future<void> setString({required Map<String, dynamic> strings}) async {
    await _methodChannel.invokeMethod('setString', {'strings': strings});
  }

  static Future<void> getUserScore({
    UserScoreFetchMode? fetchMode,
    required Function(UserScoreResult result) onSuccess,
    required Function(String error) onError,
  }) async {
    String? strFetchMode;
    if (fetchMode != null) {
      strFetchMode = describeEnum(fetchMode);
    }

    Map<dynamic, dynamic>? result = await _methodChannel
        .invokeMethod('getUserScore', {'fetchMode': strFetchMode});

    if (result == null) {
      print('Unknown error');
      onError('Unknown error');
      return;
    }

    if (result['error'] != null) {
      print(result['error']);
      onError(result['error']);
      return;
    }
    onSuccess(
      UserScoreResult.fromJson(
        Map<String, dynamic>.from(result['data']),
      ),
    );
  }

  static Future<void> startFaceLogin({
    required FaceLogin faceLogin,
    required Function(FaceLoginResult result) onSuccess,
    required Function(String error) onError,
  }) async {
    Map<dynamic, dynamic>? result =
        await _methodChannel.invokeMethod<Map<dynamic, dynamic>>(
      'startFaceLogin',
      {'faceLogin': faceLogin.toJson()},
    );

    if (result == null) {
      print('Unknown error');
      onError('Unknown error');
      return;
    }

    if (result['error'] != null) {
      print(result['error']);
      onError(result['error']);
      return;
    }
    onSuccess(
      FaceLoginResult.fromJson(
        Map<String, dynamic>.from(result['data']),
      ),
    );
  }

  static Future<void> addNOM151Archive({
    required Function(AddNom151Result result) onSuccess,
    required Function(String error) onError,
  }) async {
    Map<dynamic, dynamic>? result =
        await _methodChannel.invokeMethod('addNOM151Archive', {});

    if (result == null) {
      print('Unknown error');
      onError('Unknown error');
      return;
    }

    if (result['error'] != null) {
      print(result['error']);
      onError(result['error']);
      return;
    }
    onSuccess(
      AddNom151Result.fromJson(
        Map<String, dynamic>.from(result['data']),
      ),
    );
  }

  static Future<void> addFace(
      {required FaceInfo faceInfo,
      required Function(bool result) onSuccess,
      required Function(String error) onError}) async {
    Map<dynamic, dynamic>? result =
        await _methodChannel.invokeMethod('addFace', {
      'faceTemplate': faceInfo.faceTemplate,
      'customerUUID': faceInfo.customerUUID,
      'templateId': faceInfo.templateId
    });

    if (result == null) {
      print('Unknown error');
      onError('Unknown error');
      return;
    }

    if (result['error'] != null) {
      print(result['error']);
      onError(result['error']);
      return;
    }

    onSuccess(true);
  }

  static Future<void> removeFace(
      {required String customerUUID,
      required Function(bool result) onSuccess,
      required Function(String error) onError}) async {
    Map<dynamic, dynamic>? result = await _methodChannel
        .invokeMethod('removeFace', {'customerUUID': customerUUID});

    if (result == null) {
      print('Unknown error');
      onError('Unknown error');
      return;
    }

    if (result['error'] != null) {
      print(result['error']);
      onError(result['error']);
      return;
    }

    onSuccess(true);
  }

  static Future<void> getFaces({
    required Function(List<FaceInfo> result) onSuccess,
    required Function(String error) onError,
  }) async {
    Map<dynamic, dynamic>? result =
        await _methodChannel.invokeMethod('getFaces', {});

    if (result == null) {
      print('Unknown error');
      onError('Unknown error');
      return;
    }

    if (result['error'] != null) {
      print(result['error']);
      onError(result['error']);
      return;
    }

    final List faceInfoJSONArrayAsString = jsonDecode(result['data']);
    final List<FaceInfo> faceInfoList = faceInfoJSONArrayAsString
        .map((faceInfoJSON) => FaceInfo.fromJson(faceInfoJSON))
        .toList();

    onSuccess(faceInfoList);
  }

  static Future<void> setFaces({
    required List<FaceInfo> faces,
    required Function(bool result) onSuccess,
    required Function(String error) onError,
  }) async {
    String jsonFaces = jsonEncode(faces);
    Map<dynamic, dynamic>? result =
        await _methodChannel.invokeMethod<Map<dynamic, dynamic>>(
      'setFaces',
      <String, dynamic>{'faces': jsonFaces},
    );

    if (result == null) {
      print('Unknown error');
      onError('Unknown error');
      return;
    }

    if (result['error'] != null) {
      print(result['error']);
      onError(result['error']);
      return;
    }

    onSuccess(true);
  }

  static Future<void> getUserOCRData({
    String? token,
    required Function(GetUserOCRDataResult result) onSuccess,
    required Function(String error) onError,
  }) async {
    Map<dynamic, dynamic>? result =
        await _methodChannel.invokeMethod('getUserOCRData', {'token': token});

    if (result == null) {
      print('Unknown error');
      onError('Unknown error');
      return;
    }

    if (result['error'] != null) {
      print(result['error']);
      onError(result['error']);
      return;
    }
    onSuccess(
      GetUserOCRDataResult.fromJson(
        Map<String, dynamic>.from(result['data']),
      ),
    );
  }
}
