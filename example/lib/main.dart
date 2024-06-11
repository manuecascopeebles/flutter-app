import 'package:flutter/material.dart';
import 'package:onboarding_flutter_wrapper/onboarding_flutter_wrapper.dart';
import 'package:onboarding_flutter_wrapper_example/advanced_usage.dart';
import 'package:onboarding_flutter_wrapper_example/incode_button.dart';
import 'package:onboarding_flutter_wrapper/src/models/incode_sdk_init_error.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeView(),
      routes: {'advanced': (_) => AdvancedUsage()},
    );
  }
}

class HomeView extends StatefulWidget {
  HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  OnboardingStatus? status;
  late Future<bool> future;
  bool initSuccess = false;
  bool isOnboarding = false;

  @override
  void initState() {
    super.initState();

    IncodeOnboardingSdk.init(
      apiKey: 'YOUR_API_KEY',
      apiUrl: 'YOUR_API_URL',
      testMode: false,
      loggingEnabled: true,
      externalAnalyticsEnabled: false,
      externalScreenshotsEnabled: false,
      disableHookDetection: false,
      disableEmulatorDetection: false,
      disableRootDetection: false,
      onError: (String error) {
        IncodeSdkInitError? e = error.toIncodeSdkInitError();

        // Handle the error accordingly
        switch (e) {
          case IncodeSdkInitError.hookDetected:
            print('Incode SDK init failed: $IncodeSdkInitError.hookDetected');
            break;
          case IncodeSdkInitError.testModeEnabled:
            print(
                'Incode SDK init failed: $IncodeSdkInitError.testModeEnabled');
            break;
          default:
            print('Incode SDK init failed: $error');
            break;
        }

        setState(() {
          initSuccess = false;
        });
      },
      onSuccess: () {
        // Update UI, safe to start Onboarding
        print('Incode initialize successfully!');
        setState(() {
          initSuccess = true;
        });
      },
    );

    // IncodeOnboardingSdk.setTheme(theme: theme);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Incode Omni'),
        actions: [
          if (initSuccess)
            TextButton(
              onPressed: () => Navigator.of(context).pushNamed('advanced'),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Advanced',
                    style: TextStyle(color: Colors.white),
                  ),
                  Icon(
                    Icons.navigate_next_outlined,
                    color: Colors.white,
                  ),
                ],
              ),
            )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _buildChildren(),
        ),
      ),
    );
  }

  List<Widget> _buildChildren() {
    List<Widget> children;
    switch (status) {
      case OnboardingStatus.success:
        children = [
          _buildInfoMessage(
            title: 'Thank you!',
            subtitle: 'You\'ve successfully completed the onboarding process.',
          ),
          _buildRestartOnoardingButton(),
        ];
        break;
      case OnboardingStatus.failure:
        children = [
          Flexible(
            child: _buildInfoMessage(
              title: 'Process was not completed',
              subtitle:
                  'We\'re unable to onboard you remotely, please proceed to the nearest branch.',
            ),
          ),
          Flexible(child: _buildRestartOnoardingButton()),
        ];
        break;
      case null:
        children = [
          IncodeButton(
            text: 'START ONBOARDING',
            onPressed: initSuccess && !isOnboarding ? onStartOnboarding : null,
          ),
          SizedBox(height: 16),
          IncodeButton(
            text: 'START WORKFLOW',
            onPressed: initSuccess && !isOnboarding ? onStartWorkflow : null,
          ),
          SizedBox(height: 16),
          IncodeButton(
            text: 'START FLOW',
            onPressed: initSuccess && !isOnboarding ? onStartFlow : null,
          ),
          SizedBox(height: 16),
          IncodeButton(
            text: 'START FLOW DEEPLINK',
            onPressed:
                initSuccess && !isOnboarding ? onStartFlowFromDeepLink : null,
          ),
          SizedBox(height: 16),
          IncodeButton(
            text: 'START FACE LOGIN',
            onPressed: initSuccess && !isOnboarding ? onFaceLogin : null,
          ),
          SizedBox(height: 16),
        ];
        break;
    }
    return children;
  }

  Widget _buildRestartOnoardingButton() {
    return IncodeButton(
      text: 'RESTART ONBOARDING',
      onPressed: () {
        setState(() {
          status = null;
        });
      },
    );
  }

  Widget _buildInfoMessage({required String title, required String subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 24),
        Text(
          subtitle,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void onStartOnboarding() {
    OnboardingSessionConfiguration sessionConfig =
        OnboardingSessionConfiguration();
    OnboardingFlowConfiguration flowConfig = OnboardingFlowConfiguration();

    // flowConfig.addPhone(defaultRegionPrefix: 31);
    // flowConfig.addMLConsent(type: MLConsentType.gdpr);
    // flowConfig.addUserConsent(title: "title", content: "content");
    // flowConfig.addQRScan(showTutorials: true);
    flowConfig.addIdScan();
    flowConfig.addSelfieScan();
    flowConfig.addFaceMatch();

    ///flowConfig.addGlobalWatchlist();

    // flowConfig.addVideoSelfie(
    //   showTutorials: false,
    //   idScanCameraFacing: IdScanCameraFacing.front,
    //   showIdScan: true,
    //   showVoiceConsent: true,
    //   voiceConsentQuestionsCount: 0,
    // );

    //flowConfig.addGeolocation();
    // flowConfig.addApproval();
    // flowConfig.addGovernmentValidation(isBackgroundExecuted: true);
    // flowConfig.addAntifraud();
    // flowConfig.addDocumentScan(documentType: DocumentType.medicalDoc);
    // flowConfig.addSignature();
    // flowConfig.addUserScore(mode: UserScoreFetchMode.fast);
    // flowConfig.addCaptcha();
    // flowConfig.addCurpValidation();
    // flowConfig.addIdScan(scanStep: ScanStepType.front);
    // flowConfig.addIdScan(scanStep: ScanStepType.back);
    // flowConfig.addProcessId();

    setState(() {
      isOnboarding = true;
    });

    IncodeOnboardingSdk.showCloseButton(allowUserToCancel: true);
    IncodeOnboardingSdk.setLocalizationLanguage(language: 'en');
    Map<String, dynamic> strings = {
      /// iOS labels
      'incdOnboarding.idChooser.title': 'My Custom chooser title',

      /// Android labels
      'onboard_sdk_id_type_chooser_title': 'My Custom chooser title',
    };
    IncodeOnboardingSdk.setString(strings: strings);

    OnboardingRecordSessionConfiguration recordSessionConfig =
        OnboardingRecordSessionConfiguration(
            recordSession: true, forcePermission: true);

    IncodeOnboardingSdk.startOnboarding(
      sessionConfig: sessionConfig,
      flowConfig: flowConfig,
      // recordSessionConfig: recordSessionConfig,
      onError: (String error) {
        print('Incode onboarding error: $error');
        setState(() {
          status = OnboardingStatus.failure;
          isOnboarding = false;
        });
      },
      onSuccess: () {
        print('Incode Onboarding completed!');
        setState(() {
          status = OnboardingStatus.success;
          isOnboarding = false;
        });
      },
      onSelfieScanCompleted: (SelfieScanResult result) {
        print(result);
      },
      onIdFrontCompleted: (IdScanResult result) {
        print(result);
      },
      onIdBackCompleted: (IdScanResult result) {
        print(result);
      },
      onIdProcessed: (String ocrData) {
        print(ocrData);
      },
      onAddPhoneNumberCompleted: (PhoneNumberResult result) {
        print(result);
      },
      onAddEmailCompleted: (AddEmailResult result) {
        print(result);
      },
      onAddFullNameCompleted: (AddFullNameResult result) {
        print(result);
      },
      onGeolocationCompleted: (GeoLocationResult result) {
        print(result);
      },
      onFaceMatchCompleted: (FaceMatchResult result) {
        print(result);
      },
      onVideoSelfieCompleted: (VideoSelfieResult result) {
        print(result);
      },
      onMLConsentCompleted: (MLConsentResult result) {
        print(result);
      },
      onQRScanCompleted: (QRScanResult result) {
        print('✅ QRScan: $result');
      },
      onGlobalWatchlistCompleted: (GlobalWatchlistResult result) {
        print('✅ GlobalWatchlist: $result');
      },
      onOnboardingSessionCreated: (OnboardingSessionResult result) {
        print(result);
        setState(() {
          isOnboarding = false;
        });
      },
      onUserScoreFetched: (UserScoreResult result) {
        print(result);
      },
      onApproveCompleted: (ApprovalResult result) {
        print(result);
      },
      onDocumentScanCompleted: (DocumentScanResult result) {
        print(result);
      },
      onSignatureCollected: (SignatureResult result) {
        print(result);
      },
      onUserConsentCompleted: (UserConsentResult result) {
        print(result);
      },
      onUserCancelled: () {
        print('User cancelled');
        setState(() {
          isOnboarding = false;
        });
      },
      onGovernmentValidationCompleted: (GovernmentValidationResult result) {
        print(result);
      },
      onAntifraudCompleted: (AntifraudResult result) {
        print(result);
      },
      onCaptchaCompleted: (CaptchaResult result) {
        print(result);
      },
      onCurpValidationCompleted: (CurpValidationResult result) {
        print(result);
      },
    );
  }

  void onStartWorkflow() {
    OnboardingSessionConfiguration sessionConfig =
        OnboardingSessionConfiguration(configurationId: "YOUR_WORKLOW_ID");

    setState(() {
      isOnboarding = true;
    });

    IncodeOnboardingSdk.showCloseButton(allowUserToCancel: true);
    IncodeOnboardingSdk.startWorkflow(
      sessionConfig: sessionConfig,
      onError: (String error) {
        print('Incode startWorkflow error: $error');
        setState(() {
          status = OnboardingStatus.failure;
          isOnboarding = false;
        });
      },
      onSuccess: () {
        print('Incode startWorkflow completed!');
        setState(() {
          status = OnboardingStatus.success;
          isOnboarding = false;
        });
      },
      onUserCancelled: () {
        print('User cancelled');
        setState(() {
          isOnboarding = false;
        });
      },
    );
  }

  void onStartFlow() {
    OnboardingSessionConfiguration sessionConfig =
        OnboardingSessionConfiguration(
            configurationId: "YOUR_CONFIGURATION_ID",
            interviewId: "YOUR_INTERVIEW_ID");

    setState(() {
      isOnboarding = true;
    });

    IncodeOnboardingSdk.showCloseButton(allowUserToCancel: true);
    IncodeOnboardingSdk.startFlow(
      sessionConfig: sessionConfig,
      moduleId: 'YOUR_MODULE_ID',
      onError: (String error) {
        print('Incode startFlow error: $error');
        setState(() {
          status = OnboardingStatus.failure;
          isOnboarding = false;
        });
      },
      onSuccess: () {
        print('Incode startFlow completed!');
        setState(() {
          status = OnboardingStatus.success;
          isOnboarding = false;
        });
      },
      onUserCancelled: () {
        print('User cancelled');
        setState(() {
          isOnboarding = false;
        });
      },
    );
  }

  void onStartFlowFromDeepLink() {
    setState(() {
      isOnboarding = true;
    });

    IncodeOnboardingSdk.showCloseButton(allowUserToCancel: true);
    IncodeOnboardingSdk.startFlowFromDeepLink(
      url:
          'YOUR_DEEPLINK_URL',
      onError: (String error) {
        print('Incode startFlowFromDeepLink error: $error');
        setState(() {
          status = OnboardingStatus.failure;
          isOnboarding = false;
        });
      },
      onSuccess: () {
        print('Incode startFlowFromDeepLink completed!');
        setState(() {
          status = OnboardingStatus.success;
          isOnboarding = false;
        });
      },
      onUserCancelled: () {
        print('User cancelled');
        setState(() {
          isOnboarding = false;
        });
      },
    );
  }
}

void onFaceLogin() {
  IncodeOnboardingSdk.showCloseButton(allowUserToCancel: true);
  IncodeOnboardingSdk.startFaceLogin(
    faceLogin: FaceLogin(),
    onSuccess: (FaceLoginResult result) {
      print(result);
    },
    onError: (String error) {
      print(error);
    },
  );
}

enum OnboardingStatus {
  success,
  failure,
}

Map<String, dynamic> theme = {
  "buttons": {
    "primary": {
      "states": {
        "normal": {
          "cornerRadius": 32,
          "textColor": "#ffffff",
          "backgroundColor": "#ff0000"
        },
        "highlighted": {
          "cornerRadius": 32,
          "textColor": "#ffffff",
          "backgroundColor": "#5b0000"
        },
        "disabled": {
          "cornerRadius": 32,
          "textColor": "#ffffff",
          "backgroundColor": "#f7f7f7"
        }
      }
    }
  },
  "labels": {
    "title": {"textColor": "#ff0000"},
    "secondaryTitle": {"textColor": "#ff0000"},
    "subtitle": {"textColor": "#ff0000"},
    "secondarySubtitle": {"textColor": "#ff0000"},
    "smallSubtitle": {"textColor": "#ff0000"},
    "info": {"textColor": "#ff0000"},
    "secondaryInfo": {"textColor": "#ff0000"},
    "body": {"textColor": "#ff0000"},
    "secondaryBody": {"textColor": "#ff0000"},
    "code": {"textColor": "#ff0000"}
  }
};
