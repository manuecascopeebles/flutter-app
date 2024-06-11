import 'package:onboarding_flutter_wrapper/onboarding_flutter_wrapper.dart';
import 'package:onboarding_flutter_wrapper/src/models/modules/approve_module.dart';
import 'package:onboarding_flutter_wrapper/src/models/modules/base_module.dart';
import 'package:onboarding_flutter_wrapper/src/models/modules/captcha_module.dart';
import 'package:onboarding_flutter_wrapper/src/models/modules/curp_validation_module.dart';
import 'package:onboarding_flutter_wrapper/src/models/modules/face_match_module.dart';
import 'package:onboarding_flutter_wrapper/src/models/modules/geolocation_module.dart';
import 'package:onboarding_flutter_wrapper/src/models/modules/government_validation_module.dart';
import 'package:onboarding_flutter_wrapper/src/models/modules/antifraud_module.dart';
import 'package:onboarding_flutter_wrapper/src/models/modules/id_scan_module.dart';
import 'package:onboarding_flutter_wrapper/src/models/modules/phone_module.dart';
import 'package:onboarding_flutter_wrapper/src/models/modules/process_id_module.dart';
import 'package:onboarding_flutter_wrapper/src/models/modules/qr_scan_module.dart';
import 'package:onboarding_flutter_wrapper/src/models/modules/selfie_scan_module.dart';
import 'package:onboarding_flutter_wrapper/src/models/modules/signature_module.dart';
import 'package:onboarding_flutter_wrapper/src/models/modules/user_score_module.dart';
import 'package:onboarding_flutter_wrapper/src/models/modules/video_selfie_module.dart';
import 'package:onboarding_flutter_wrapper/src/models/modules/email_module.dart';
import 'package:onboarding_flutter_wrapper/src/models/modules/full_name_module.dart';
import 'package:onboarding_flutter_wrapper/src/models/modules/ml_consent_module.dart';
import 'package:onboarding_flutter_wrapper/src/models/modules/user_consent_module.dart';
import 'package:onboarding_flutter_wrapper/src/models/modules/global_watchlist_module.dart';

class OnboardingFlowConfiguration {
  final Set<BaseModule> _modules;

  OnboardingFlowConfiguration() : _modules = Set<BaseModule>();

  void addIdScan({
    IdCategory? idCategory,
    IdType? idType,
    bool? showTutorials,
    ScanStepType? scanStep,
  }) {
    _modules.add(IdScanModule(
      idCategory: idCategory,
      idType: idType,
      showTutorials: showTutorials,
      scanStep: scanStep,
    ));
  }

  void addSelfieScan({bool? showTutorials}) {
    _modules.add(SelfieScanModule(showTutorials: showTutorials));
  }

  void addFaceMatch({IdCategory? idCategory}) {
    _modules.add(FaceMatchModule(idCategory: idCategory));
  }

  void addPhone({int? defaultRegionPrefix}) {
    _modules.add(PhoneModule(defaultRegionPrefix: defaultRegionPrefix));
  }

  void addGeolocation() {
    _modules.add(GeoLocationModule());
  }

  void addVideoSelfie(
      {bool? showTutorials,
      SelfieScanMode? selfieScanMode,
      bool? selfieLivenessCheck,
      bool? showIdScan,
      bool? showDocumentScan,
      bool? showVoiceConsent,
      int? voiceConsentQuestionsCount,
      IdScanCameraFacing? idScanCameraFacing}) {
    _modules.add(
      VideoSelfieModule(
        showTutorials: showTutorials,
        selfieScanMode: selfieScanMode,
        idScanCameraFacing: idScanCameraFacing,
        selfieLivenessCheck: selfieLivenessCheck,
        showIdScan: showIdScan,
        showDocumentScan: showDocumentScan,
        showVoiceConsent: showVoiceConsent,
        voiceConsentQuestionsCount: voiceConsentQuestionsCount,
      ),
    );
  }

  void addApproval({bool? forceApproval}) {
    _modules.add(ApproveModule(forceApproval: forceApproval));
  }

  void addUserScore({UserScoreFetchMode? mode}) {
    _modules.add(UserScoreModule(mode: mode));
  }

  void addGovernmentValidation({bool? isBackgroundExecuted}) {
    _modules.add(
        GovernmentValidationModule(isBackgroundExecuted: isBackgroundExecuted));
  }

  void addAntifraud() {
    _modules.add(AntifraudModule());
  }

  void addDocumentScan({
    bool? showTutorials,
    bool? showDocumentProviderOptions,
    DocumentType? documentType,
  }) {
    _modules.add(
      DocumentScanModule(
        showTutorials: showTutorials,
        showDocumentProviderOptions: showDocumentProviderOptions,
        documentType: documentType,
      ),
    );
  }

  void addSignature() {
    _modules.add(SignatureModule());
  }

  void addCaptcha() {
    _modules.add(CaptchaModule());
  }

  void addCurpValidation() {
    _modules.add(CurpValidationModule());
  }

  void addProcessId({IdCategory? idCategory, bool? enableIdSummaryScreen}) {
    _modules.add(ProcessIdModule(
        idCategory: idCategory, enableIdSummaryScreen: enableIdSummaryScreen));
  }

  void addEmail() {
    _modules.add(EmailModule());
  }

  void addFullName() {
    _modules.add(FullNameModule());
  }

  void addMLConsent({
    MLConsentType? type,
  }) {
    _modules.add(
      MLConsentModule(type: type),
    );
  }

  void addUserConsent({
    String? title,
    String? content,
  }) {
    _modules.add(
      UserConsentModule(title: title, content: content),
    );
  }

  void addQRScan({bool? showTutorials}) {
    _modules.add(QRScanModule(showTutorials: showTutorials));
  }

  void addGlobalWatchlist() {
    _modules.add(GlobalWatchlistModule());
  }

  Map<String, dynamic> toJson() =>
      {'modules': _modules.map((module) => module.toJson()).toList()};
}
