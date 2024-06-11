# Incode Onboarding Flutter SDK 

**Incode Onboarding**  provides effortless onboarding where security matters.
Incode Onboarding is part of Incode Omnichannel Biometric Identity Platform, that is powered by Incode's world class Face Recognition, Liveness detection and ID Validation models.

In this repo you can find an example onboarding app that uses Incode Onboarding Flutter SDK to enable remote account opening.

Contents:

- [SDK Setup](#SDK-Setup)
  - [Requirements](#Requirements)
  - [Installation](#Installation)
  - [Additional setup for iOS](#Additional-setup-for-iOS)
  - [Additional setup for Android](#Additional-setup-for-Android)
- [Updating to latest version](#Updating-to-latest-version)
- [Usage Example](#Usage-Example)
- [Modules](#Modules)
  - [Modules configuration](#Modules-configuration)
  - [Modules interdependencies](#Modules-interdependencies)
- [SDK results](#SDK-results)
  - [Phone](#Phone)
  - [Name](#Name)
  - [Email](#Email)
  - [IdScan](#IdScan)
  - [ProcessId](#ProcessId)
  - [SelfieScan](#SelfieScan)
  - [FaceMatch](#FaceMatch)
  - [Geolocation](#Geolocation)
  - [GovernmentValidation](#GovernmentValidation)
  - [VideoSelfie](#VideoSelfie)
  - [Antifraud](#Antifraud)
  - [UserScore](#UserScore)
  - [Signature](#Signature)
  - [Document Scan](#DocumentScan)
  - [Captcha](#Captcha)
  - [CURP](#CURP)
  - [MLConsent](#MLConsent)
  - [UserConsent](#UserConsent)
  - [QRScan](#QRScan)
  - [GlobalWatchlist](#GlobalWatchlist)
- [Advanced usage](#Advanced-usage)
  - [Setup onboarding session](#Setup-onboarding-session)
  - [Configure section flow](#Configure-section-flow)
  - [Start onboarding section](#Start-onboarding-section)
  - [Finish onboarding session](#Finish-onboarding-section)
- [Face Login](#Face-login)
  - [Face Login 1:1](#Face-login-1:1)
  - [Face Login 1:N](#Face-login-1:N)
  - [Face Login parametrization](#face-login-parametrization)
    - [Authorization modes](#Authorization-modes)
    - [Face mask check](#Face-mask-check)
    - [Lenses check](#leneses-check)
    - [Log authentication attempts](#log-authentication-attempts)
  - [Manipulating locally stored identities](#manipulating-locally-stored-identities)
    - [Add face](#add-face)
    - [Remove face](#remove-face)
    - [Set multiple faces](#set-multiple-faces)
    - [Get faces](#get-faces)
    - [Clear face database](#clear-face-database)
- [Customization](#Customization)
- [Using SDK without an API KEY](#Using-SDK-without-an-API-KEY)
- [Other Public API methods](#Other-Public-API-methods)
  - [SDK Mode](#SDK-Mode)
  - [Allowing user to cancel the flow](#Allowing-user-to-cancel-the-flow)
  - [Get Score API](#Get-Score-API)
  - [AddNom151Archive API](#AddNom151Archive-API)
  - [Get user OCR data API](#Get-user-OCR-data-API)
- [Known issues](#Known-issues)

# SDK Setup

## Requirements
- Flutter version >=1.20.0

## Installation

```yaml
onboarding_flutter_wrapper:
  git:
    url: git@github.com:Incode-Technologies-Example-Repos/IncdOnboardingFlutter.git
    ref: master
```

## Additional setup for iOS

After installation, it's necessary to do the linking for the iOS, after running the command above.

1. Change your `Podfile` inside `ios` folder so it requires deployment target 13 or higher.

```diff
-platform :ios, '11.0'
+platform :ios, '13.0'
```

2. Run `pod install` within the `ios` folder:

```sh
pod install
```

3. Adapt `Info.plist` by adding mandatory permission related entries depending on the modules you need:

- For camera modules like IdScan, SelfieScan, DocumentScan or VideoSelfie the `NSCameraUsageDesscription` is mandatory.
- `Geolocation` module requires `NSLocationWhenInUseUsageDescription`
- `VideoSelfie` module and its voice consent step requires `NSMicrophoneUsageDescription`

## Additional setup for Android

1. Modify `app/build.gradle` so that you enable `multiDexEnabled` and set the minimum API level to 21:

```diff
defaultConfig {
  …
  multiDexEnabled true
  minSdkVersion 21
}
```

2. Modify your `build.gradle` so it contains Artifactory username and password, provided by Incode:

```diff
allprojects {
  repositories {
    ...
+    maven { url "https://jitpack.io" }
+    maven {
+      url "https://repo.incode.com/artifactory/libs-incode-welcome"
+      credentials {
+        username = "ARTIFACTORY_USERNAME"
+        password = "ARTIFACTORY_PASSWORD"
+      }
+    }
    ...
  }
}
```

Additionaly, if you're explicitly setting `kotlin-gradle-plugin` version make sure kotlin version is set to `1.9.0`:

```diff
buildscript {
+    ext.kotlin_version = '1.9.0'
   ///

    dependencies {
        ...
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
    }
}
```

3. Optionally, modify your `app/build.gradle` to add dependencies depending on the features you want to use:

Other optional dependencies can be added for optimized Face Login features:
- Add 'com.incode.sdk:model-mask-detection:2.0.0' to detect face mask during face login.
- Add 'com.incode.sdk:model-liveness-detection:2.0.0' to use local liveness by specifying .hybrid or .local `FaceAuthMode` for face login.
- Add 'com.incode.sdk:model-face-recognition:2.0.0' to use local face recognition by specifying .local `FaceAuthMode` for face login.


# Updating to latest version

Run `flutter pub upgrade` or `flutter packages upgrade`, and in case iOS SDK version was updated run `pod install --repo-update` and `pod update IncdOnboarding` inside your ios folder.

# Usage example

1. Initialize the SDK
```dart
IncodeOnboardingSdk.init(
  apiKey: 'YOUR_API_KEY',
  apiUrl: 'YOUR_API_URL',
  testMode: false,
  onError: (String error) {
    IncodeSdkInitError? e = error.toIncodeSdkInitError();
    switch (e) {
      case IncodeSdkInitError.hookDetected:
        print('Incode init failed, hook detected: $IncodeSdkInitError.hookDetected');
        break;
      case IncodeSdkInitError.testModeEnabled:
        print('Incode init failed, test mode enabled: $IncodeSdkInitError.testModeEnabled');
        break;
      default:
        print('Incode init failed: $error');
        break;
    }
  },
  onSuccess: () {
    // Update UI, safe to start Onboarding
    print('Incode initialize successfully!');
  },
);
```

`apiUrl` and `apiKey` will be provided to you by Incode.
If you're running the app on a simulator, please set the `testMode` parameter to true.

In case initialization isn't successfull, `onError` callback will be triggered and `error` String will contain more information. Possible values are listed in `IncodeSdkInitError` enum: `simulatorDetected`, `testModeEnabled`, `rootDetected`, `hookDetected`, and `unknown`.

2. Configure Onboarding session
You should create an instance of `OnboardingSessionConfiguration`:

```dart
OnboardingSessionConfiguration sessionConfig = OnboardingSessionConfiguration();
```

Optionally, you can provide these parameters to the `OnboardingSessionConfiguration` object constructor:
- region: `ALL` by default
- onboardingValidationModules: list of `OnboardingValidationModule` items. This list determines which modules are used for verification and calculation of the onboarding score. If you pass null as validationModuleList, the default values will be used: id, faceRecognition and liveness.
- customFields: custom fields which are sent to the server.
- externalId: User identifier outside of Incode Omni database.
- interviewId: Unique identifier of an existion session
- token: Token of an existing session
- configurationId: Flow configurationId found on Incode dashboard.

Specifying `interviewId` or `token` will return an existing session that will be resumed.
Specifying `externalId` will return an existing session in case a session with the same `externalId` was already started, otherwise new session will be created.

3. Configure Onboarding Flow

You should create an instance of `OnboardingFlowConfiguration`:

```dart
OnboardingFlowConfiguration flowConfig = OnboardingFlowConfiguration()
```

Depending on your needs you should specify the steps you want to include, ie.:

```dart
flowConfig.addIdScan();
flowConfig.addSelfieScan();
flowConfig.addFaceMatch();
```

The steps will be executed in the order you added them to the flowConfig.

4. Start the onboarding
```dart
IncodeOnboardingSdk.startOnboarding(
  sessionConfig: sessionConfig,
  flowConfig: flowConfig,
  onSuccess: () {
    print('Incode Onboarding completed!');
  },
  onError: (String error) {
    print('Incode onboarding error: $error');
  },
  onSelfieScanCompleted: (SelfieScanResult result) {
    print('Selfie completed result: $result');
  },
  onIdFrontCompleted: (IdScanResult result) {
    print('onIdFrontCompleted result: $result');
  },
  onIdBackCompleted: (IdScanResult result) {
    print('onIdBackCompleted result: $result');
  },
  onIdProcessed: (String ocrData) {
    print('onIdProcessed result: $ocrData');
  },
);
```

Once all the steps are completed by the user the `onSuccess` method will be called.
In case some error occured that stopped the flow from completing, the `onError` method will be called.

To listen for the results of the steps in the flow as soon as they're completed, you can add optional callback methods, ie. `onSelfieScanCompleted` that was added in the above example.

Optionally, if you want to store ID and Selfie capture session recordings, specify `recordSessionConfig` parameter to the `startOnboarding` method. Set `OnboardingRecordSessionConfiguration.forcePermission` to true if you wish to force the user to accept the recording permissions, otherwise the onboarding session will be aborted.

```dart
OnboardingRecordSessionConfiguration recordSessionConfig =  OnboardingRecordSessionConfiguration(recordSession: true, forcePermission: false);

IncodeOnboardingSdk.startOnboarding(
  sessionConfig: sessionConfig,
  flowConfig: flowConfig,
  recordSessionConfig: recordSessionConfig,
  onSuccess: () {
    print('Incode Onboarding completed!');
  },
  onError: (String error) {
    print('Incode onboarding error: $error');
  },
  onSelfieScanCompleted: (SelfieScanResult result) {
    print('Selfie completed result: $result');
  },
  onIdFrontCompleted: (IdScanResult result) {
    print('onIdFrontCompleted result: $result');
  },
  onIdBackCompleted: (IdScanResult result) {
    print('onIdBackCompleted result: $result');
  },
  onIdProcessed: (String ocrData) {
    print('onIdProcessed result: $ocrData');
  },
);
```

# Modules

The modules supported by the SDK are listed here, and elaborated in more detail throughout the rest of this document.

- `Phone` - Ask the user to enter a phone number.
- `Name` - Ask the user to enter a name.
- `Email` - Ask the user to enter an email.
- `IdScan` - Ask the user to capture ID or Passport.
- `ProcessId` - Process the ID in case Id Scan was separated to front and back captures.
- `SelfieScan` - Ask the user to capture a selfie.
- `FaceMatch` - Perform a face match between captured ID and Selfie
- `Geolocation` - Get the information about the users current location.
- `GovernmentValidation` - Perform government validation of the ID
- `VideoSelfie` - Records the device's screen while the user needs to do a selfie, show his ID, answer a couple of questions and verbally confirms that he accept the terms and conditions. The recorded video is then uploaded and stored for later usage.
- `UserScore` - Shows the info and scoring for all the steps performed
- `Signature` - Ask the user to draw a signature
- `DocumentScan` - Ask the user to capture a document
- `Captcha` - Ask the user to complete CAPTCHA
- `CURP` - Validate user's curp from the ID
- `Approve` - Based on a score approves the current onboarding session and adds the user to the omni database. 
- `MLConsent` - Ask the user for Machine Learning consent
- `UserConsent` - Ask the user for User consent
- `QRScan` - Ask the user for QR scan
- `Antifraud` - Gives ability to compare current interview with existing interviews and customers and detect anomalies that could be signs of fraud.

## Modules configuration

Below is the list of all available modules, with additional configuration parameters.

- Phone
  - `defaultRegionPrefix`(optional): int?. Default region prefix for phone input. If set, will override the current default prefix based on the user's device region selection. 
- Name
  - no additional parameters
- Email
  - no additional parameters
- IdScan
  - `showTutorials` (optional, defaults to `true`): bool?
  - `idType` (optional): `IdType.id` or `IdType.passport`. If omitted, the app will display a chooser to the user.
  - `idCategory` (optional): `IdCategory.primary` or `IdCategory.secondary`
  - `scanStep` (otpional): If you wish to separate front and back ID scan, specify `ScanStepType.front` or  `ScanStepType.back`. `ScanStepType.both` is the default and will capture both front and back of the ID, and process the ID afterwards. If you specify `ScanStepType.front` or `ScanStepType.back` you will have to add `ProcessId` module after the captures.
- ProcessId (used only if `ScanStepType.front` or `ScanStepType.back` were specified as `scanStep` for `IdScan` module)
  - `idCategory` (optional): `IdCategory.primary` or `IdCategory.secondary`
  - `enableIdSummaryScreen` (optional): bool?
  - Note: Please make sure to call this module only after the both `ScanStepType.front` and `ScanStepType.back` IdScans are completed.
- SelfieScan
  - `showTutorials` (optional, defaults to `true`): bool?
- FaceMatch
  - `idCategory` (optional, defaults to `primary`): `IdCategory.primary` or `IdCategory.secondary`
  - Note: has to be specified **after IDScan and SelfieScan** modules.
- Geolocation
  - no additional parameters
- GovernmentValidation
  - `isBackgroundExecuted` - (optional, defaults to `false`): bool?. Specify true to hide the module UI during its execution.
- VideoSelfie:
  - `showTutorials` (optional, defaults to `true`): bool?. Show tutorial for video selfie.
  - `selfieScanMode` (optional, defaults to `selfieMatch`): `SelfieScanMode.selfieMatch` or `SelfieScanMode.faceMatch`; Specify if you would like to do selfie comparison, or comparison with the photo from ID.
  - `selfieLivenessCheck` (optional, defaults to `false`): bool?. Check for user liveness during video selfie.
  - `showIdScan` (optional, defaults to `true`): bool?. Ask for ID scan during video selfie.
  - `showDocumentScan` (optional, defaults to `true`): bool?. Ask for Proof of Address during video selfie
  - `showVoiceConsent` (optional, defaults to `true`): bool?. Ask for Voice consent during video selfie
  - `voiceConsentQuestionsCount` (optional, defaults to `3`): int?. Choose number of questions for video selfie voice 
  consent steps.
  - `idScanCameraFacing`  (optional, defaults to `back`): `IdScanCameraFacing.front` or `IdScanCameraFacing.back`; Specify if you would like to use fromt or back camera for ID scan
- UserScore
  - `mode` (optional, defaults to `accurate`): `UserScoreFetchMode.accurate` or `UserScoreFetchMode.fast`. If `accurate` the results will be fetched from server, which may exhibit some latency, but will rely on server-side processing of information, which may be more reliable than on-device processing. If `fast`, then results based on on-device processing will be shown.
- Approve
  - `forceApproval` (optional, defaults to `false`): bool? - if `true` the user will be force-approved
- Signature
  - no additional parameters
- DocumentScan
  - `showTutorials` (optional, defaults to `true`): bool?. Show tutorial for document scan.
  - `showDocumentProviderOptions` (optional, defaults to `false`).
  - `documentType` (optional, defaults to `DocumentType.addressStatement`).
- Captcha
  - no additional parameters
- CURP
  - no additional parameters
- MLConsent
  - `type`: MLConsentType.gdpr or MLConsentType.us
- UserConsent
  - `title`: String, title for user consent
  - `content`: String, content for user consent
- QRScan
  - `showTutorials` (optional, defaults to `true`): bool?. Show tutorial for QR scan.
- Antifraud
  - no additional parameters

## Modules interdependencies
- `ProcessId` module expects `IdScan` both `ScanStepType.front` or `ScanStepType.back` to have executed.
- `FaceMatch` module expects `IdScan` and `SelfieScan` to have executed, in order to perform the match. In other words, `IdScan` and `SelfieScan` must precede `FaceMatch`
- `VideoSelfie` module expects `IdScan` in `faceMatch` mode, or `SelfieScan` in `selfieMatch` mode.
- `UserScore` module should succeed all other modules (must be at the end)
- `Approve` module should succeed all other modules (must be at the end)
- The `UserScore` and `Approve` modules do not depend on each other, so their order can be arbitrary.
  
# SDK results

## Phone

Specify `onAddPhoneNumberCompleted` to the `startOnboarding` method, to receive `PhoneNumberResult`:

- `phone` : String, the phone number user entered

## Name

Specify `onAddFullNameCompleted` to the `startOnboarding` method, to receive `AddFullNameResult`:

- `name` : String, the name user entered

## Email

Specify `onAddEmailCompleted` to the `startOnboarding` method, to receive `AddEmailResult`:

- `email` : String, the email user entered

## IdScan

1) Specify `onIdFrontCompleted`, `onIdBackCompleted` to the `startOnboarding` method, to receive `IdScanResult` result:

- `image`: Captured ID image
- `base64Image`: String?. Captured front ID in base64 format
- `croppedFace`: Cropped face from captured ID image
- `chosenIdType`: User chosen type on ID selection screen- `id` or `passport`
- `classifiedIdType`: type of the captured ID
- `idCategory`: IdCategory. Category of the scanned ID
- `scanStatus`: If status has a value other than `IdValidationStatus.ok` you can consider the ID scan and/or validation did not come through successfully. Other status messages are: `errorClassification`, `noFacesFound`, `errorCropQuality`, `errorGlare`, `errorSharpness`, `errorTypeMismatch`, `userCancelled`, `unknown`, `errorAddress`, `errorPassportClassification`.

2) Specify `onIdProcessed` to the `startOnboarding` method, to receive `String` OCR result:
- `ocrData`: String?. Raw JSON containing full OCR data ie. `exteriorNumber`, `interiorNumber`, `typeOfId`, `documentFrontSubtype`


## SelfieScan

Specify `onSelfieScanCompleted` to the `startOnboarding` method, to receive `SelfieScanResult`:

- `image`: Uint8List?. Captured Selfie image
- `spoofAttempt`: bool. `false` means that person trying to do selfie is a real person. `true` means it is a spoof attempt, meaning that person is trying to spoof the system by pretending to be someone else using a physical paper, digital photo or other methods. `nil` means that unexpected error happened so it couldn't be determined if the selfie scan was a spoof attempt or not.
- `base64Images`: SelfieScanBase64Images. Contains image, in different formats, taken during Selfie Scan
  - `selfieBase64`: String?. Captured Selfie base64 image
  - `selfieEncryptedBase64`: String?. Captured Selfie encrypted base64 image

## FaceMatch

Specify `onFaceMatchCompleted` to the `startOnboarding` method, to receive `FaceMatchResult`:

- `faceMatched`: bool. `true` means person's selfie matched successfully with the front ID. `false` it means that person's selfie isn't matched with the front ID image. `null` it means that front ID image wasn't uploaded at all, so the face match service didn't have data to compare with selfie
- `idCategory` : IdCategory. Category of the ID that was used for face match.
- `existingUser`: bool. Indicates whether the user is new or existing one.
- `existingInterviewId`: String?. If user is existing user this field is populated with existing interview id.

## Geolocation

Specify `onGeolocationCompleted` to the `startOnboarding` method, to receive `GeoLocationResult`:

- `city`: String?
- `colony`: String?
- `postalCode`: String?
- `state`: String?
- `street`: String?

## GovernmentValidation

Specify `onGovernmentValidationCompleted` to the `startOnboarding` method, to receive `GovernmentValidationResult`:

- `success`: bool, `true` if the government validation was performed successfully, `false` otherwise.

## VideoSelfie

Specify `onVideoSelfieCompleted ` to the `startOnboarding` method, to receive `VideoSelfieResult`:

- `success`: bool, `true` if the video selfie was performed successfully, `false` otherwise.

## Antifraud

Specify `onAntifraudCompleted ` to the `startOnboarding` method, to receive `AntifraudResult`:

- `success`: bool, `true` if the antifraud was passed successfully, `false` otherwise.

## UserScore

Specify `onUserScoreFetched` to the `startOnboarding` method, to receive `UserScoreResult`.

Example `UserScoreResult` for **completion** of the module:

```dart
{
  ovarall: {
    value: '0.0/100',
    status: 'ok'
  },
  faceRecognition: {
    value: '0.0/100',
    status: 'warn',
  },
  liveness: {
    value: '95.2/100',
    status: 'manual',
  },
  idValidation: {
    value: '79.0/100',
    status: 'fail',
  },

}
```

The field `status` can have one of the following values: `warning`, `unknown`, `manual`, `fail` and `ok`.

## Approve

Specify `onApproveCompleted` to the `startOnboarding` method, to receive `ApprovalResult`.

- `success`: bool. `true` if the approval was successful, `false` otherwise.
- `uuid` : String?. Customer Id of newly created customer if approval was successful, `null` otherwise.
- `customerToken` : String?. Customer token for newly created customer if approval was successful, `null` otherwise.

## Signature

Specify `onSignatureCollected` to the `startOnboarding` method, to receive `SignatureResult`.

- `signature`: Uint8List?. Collected signature image.

## Document

Specify `onDocumentScanCompleted` to the `startOnboarding` method, to receive `DocumentScanResult`.

- `image`: Uint8List?. Document scan image.
- `documentType`: DocumentType. Type of scanned document.
- `address`: Map<String, dynamic>?. Address fetched from the document. Will be available only for `DocumentType.addressStatement`
- `ocrData`: Raw JSON containing full OCR data

## Captcha

Specify `onCaptchaCompleted` to the `startOnboarding` method, to receive `CaptchaResult`.

- `captcha`: String?. Entered captcha.

## CURP

Specify `onCurpValidationCompleted` to the `startOnboarding` method, to receive `CurpValidationResult`.

- `curp`: String?. User's CURP.
- `valid`: bool?. Tells if user's CURP is valid. Null means there is no result (user decided to skip).
- `data`: Map<String, dynamic>?. User's CURP data.

## MLConsent

Specify `onMLConsentCompleted` to the `startOnboarding` method, to receive `MLConsentResult`.

- `status`: bool. `true` if the user has given the machine learning consent, `false` otherwise.

If user cancels the flow, a method `onUserCancelled` is triggered.

## UserConsent

Specify `onUserConsentCompleted` to the `startOnboarding` method, to receive `UserConsentResult`.

- `status`: bool. `true` if the user has given the user learning consent, `false` otherwise.

If user cancels the flow, a method `onUserCancelled` is triggered.

## QRScan

Specify `onQRScanCompleted` to the `startOnboarding` method, to receive `QRScanResult`.

- `status`: bool. `true` if QR scan completed successfully, `false` otherwise.

If user cancels the flow, a method `onUserCancelled` is triggered.


## GlobalWatchlist

Specify `onGlobalWatchlistCompleted` to the `startOnboarding` method, to receive `GlobalWatchlistResult`.

- `status`: bool. `true` if GlobalWatchlist completed successfully, `false` otherwise.

If user cancels the flow, a method `onUserCancelled` is triggered.



# Advanced Usage

If you would like to use SDK in a way that the default flow builder doesn't provide,  
you can use SDK APIs for advanced usage where you'll be able to fully customize the experience of the flow,  
ie. by calling individual SDK modules, or grouping SDK modules in sections, and returning control to your host application in between.

## Setup an onboarding session

Before calling any other Onboarding SDK components it is necessary to setup an onboarding session.

```dart
OnboardingSessionConfiguration sessionConfiguration =
        OnboardingSessionConfiguration();
IncodeOnboardingSdk.setupOnboardingSession(
  sessionConfig: sessionConfiguration,
  onError: (String error) {
    print('Incode onboarding session error: $error');
  },
  onSuccess: (OnboardingSessionResult result) {
    print('Incode Onboarding session created! $result');
  },
);
```

Session configuration can be configured in the same way as explained in the `Usage Example` section `Configure Onboarding session`.

## Configure section flow

Once the new onboarding session is created ([See previous section](#create-new-onboarding-session)), you can separate Onboarding SDK flow into multiple sections based on your needs.

```dart
IncodeOnboardingFlowConfiguration flowConfig = IncodeOnboardingFlowConfiguration();
flowConfig.addIdScan();
```

## Start onboarding section

Once the `IncodeOnboardingFlowConfiguration` is created call the following method:

```dart
IncodeOnboardingSdk.startNewOnboardingSection(
  flowConfig: flowConfig,
  flowTag: 'idSection',
  onError: (String error) {
    print('Incode onboarding session error: $error');
  },
  onIdFrontCompleted: (IdScanResult result) {
    print('onIdFrontCompleted result: $result');
  },
  onIdBackCompleted: (IdScanResult result) {
    print('onIdBackCompleted result: $result');
  },
  onIdProcessed: (String ocrData) {
    print('onIdProcessed result: $ocrData');
  },
  onOnboardingSectionCompleted: (String flowTag) {
    print('section completed');
  },
);
```

## Start flow

Starts the flow based on the `OnboardingSessionConfiguration` provided - specify the `configurationId`, and optionally the `interviewId` if you want to resume a certain onboarding session and/or `moduleId` to start from a specific step within the flow.

```dart
 OnboardingSessionConfiguration sessionConfig =
        OnboardingSessionConfiguration(
            configurationId: "YOUR_CONFIGURATION_ID",
            interviewId: "YOUR_INTERVIEW_ID"); // optional

  IncodeOnboardingSdk.startFlow(
      sessionConfig: sessionConfig,
      moduleId: 'YOUR_MODULE_ID', // optional, ie. "PHONE"
      onError: (String error) {
        print('Incode startFlow error: $error');
      },
      onSuccess: () {
        print('Incode startFlow completed!');
      },
      onUserCancelled: () {
        print('User cancelled');
      },
  );

```

## Start flow from deep link

Starts the flow based on the deeplink URL. This method will read `configurationId`, `interviewId` and a step from which it should start.

```dart
  IncodeOnboardingSdk.startFlowFromDeepLink(
      url: 'YOUR_DEEPLINK_URL',
      onError: (String error) {
        print('Incode startFlowFromDeepLink error: $error');
      },
      onSuccess: () {
        print('Incode startFlowFromDeepLink completed!');
      },
      onUserCancelled: () {
        print('User cancelled');
      },
    );

```

## Finish onboarding session

Make sure to call `finishFlow()` at the end of the flow (when you are sure user has finished all onboarding modules and you won't be reusing same interviewId again).

```dart
IncodeOnboardingSdk.finishFlow();
```

# Face Login

Prerequisites for a successful Face Login is that user has an approved account with an enrolled face.

## Face Login 1:1

1:1 Face Login performs a 1:1 face comparison, and returns a successful match if the two faces match.

For 1:1 Face login you need to have at hand his `customerUUID`. If the user was approved during onboarding on mobile device, you should have received `customerUUID` as a result of Approve step during onboarding.

```dart
IncodeOnboardingSdk.startFaceLogin(
    faceLogin: FaceLogin(customerUUID: "yourCustomerUUID"),
    onSuccess: (FaceLoginResult result) {
      print(result);
    },
    onError: (String error) {
      print(error);
    },
  );
```

`FaceLoginResult` will contain:
- image: selfie image
- spoofAttempt: boolean that indicates if user tried to spoof the system
- base64Images: base64 representations of the selfie image
- faceMatched: boolean that indicates if the faces matched
- customerUUID: unique user identifier if the user successfully authenticated
- interviewId: sessionId in which the user got approved
- interviewToken: session token in which the user got approved
- token: token that can be used for further API calls
- transactionId: unique identifier of face login attempt
- hasLenses: indicator if login attempt failed due to person wearing lenses
- hasFaceMask: indicator if login attempt failed due to person wearing a face mask.

## Face Login 1:N

1:N Face Login performs a 1:N database face lookup, and returns a successful match if face is found in the database.

```dart
IncodeOnboardingSdk.startFaceLogin(
    faceLogin: FaceLogin(),
    onSuccess: (FaceLoginResult result) {
      print(result);
    },
    onError: (String error) {
      print(error);
    },
  );
```

`FaceLoginResult` will contain:
- image: selfie image
- spoofAttempt: boolean that indicates if user tried to spoof the system
- base64Images: base64 representations of the selfie image
- faceMatched: boolean that indicates if the faces matched
- customerUUID: unique user identifier if the user successfully authenticated
- interviewId: sessionId in which the user got approved
- interviewToken: session token in which the user got approved
- token: token that can be used for further API calls
- transactionId: unique identifier of face login attempt

## Face Login parametrization

### Authorization modes

By default Face Login will perform server spoof and face recogniton check.

In order to optimize and speed up Face Login there are two other options that you can provide to `FaceLogin` parameter `faceAuthMode`: `FaceAuthMode.hybrid` and `FaceAuthMode.local`.

`FaceAuthMode.hybrid` will perform spoof check locally on the device, and if it is successful it will perform server face recognition check.
`FaceAuthMode.local` will perform both spoof check and face recognition check locally on the device, thus making it possible to authenticate users while being offline. Prerequisite for a successful offline face login is that the user was onboarded and approved on the same device.

To use `FaceAuthMode.local` mode on Android please add 'com.incode.sdk:model-liveness-detection:2.0.0' and 'com.incode.sdk:model-face-recognition:2.0.0' depenendcies to your `app/build.gradle` file.

To perform a one-time server authentication in case a user isn't found locally on the device during `FaceAuthMode.local` execution, specify `faceAuthModeFallback` to true. It works only in 1:1 Face Login mode.

To adjust spoof and recognition thresholds for `FaceAuthMode.local` and `FaceAuthMode.hybrid` modes, specify `spoofThreshold` and `recognitionThreshold` params to `FaceLogin` object.

`FaceAuthMode.kiosk` will perform only face recognition check on the server. It is currently only supported on Android platform.

To use `FaceAuthMode.kiosk` mode on Android please add 'com.incode.sdk:kiosk-login:1.0.0' dependency to your `app/build.gradle` file.

### Face mask check

By default Face Login won't detect if people wear face masks.

To enable face mask check specify `faceMaskCheck` parameter to true in `FaceLogin`.

To use `faceMaskCheck` in Android please add 'com.incode.sdk:model-mask-detection:2.0.0' dependency to your `app/build.gradle` file.

### Leneses check

By default Face Login will detect if people wear lenses.

To disable lenses check specify `lensesCheck` parameter to false in `FaceLogin`.

### Log Authentication attempts

By default each authentication attempt is logged, and some statistics info like device used is being tracked.

Specify `logAuthenticationEnabled` false if you want to disable this to get faster performing authentications.

## Manipulating locally stored identities

To be able to authenticate multiple users using 1:N and `FaceAuhtMode.local` mode you'll need to add these users to the local database. This section will describe which methods you can use to perform CRUD operations with locally stored identities.

### Add Face

To add a single identity to the local dabtase, use `addFace` method and provide a `FaceInfo` object, that contains:
  - `faceTemplate`: String -> biometric representation of a user's face
  - `customerUUID`: String -> unique customer identifer in Incode's database
  - `templateId`: String -> unique identifier of a biometric representation of a user's face in Incode's database

```dart
FaceInfo faceInfo = FaceInfo(faceTemplate: template,
                         customerUUID: uuid,
                         templateId: templateId)
IncodeOnboardingSdk.addFace(
      faceInfo: faceInfo,
      onSuccess: (bool result) {
        print(result);
      },
      onError: (String error) {
        print(error);
      });
```

### Remove Face

To remove a single identity from the local database use `removeFace` method and provide a `customerUUID`:

```dart
IncodeOnboardingSdk.removeFace(
      customerUUID: "your_customer_uuid",
      onSuccess: (bool result) {
        print(result);
      },
      onError: (String error) {
        print(error);
      });
```

### Get faces

To fetch all currently stored identities use `getFaces` method.

```dart
  IncodeOnboardingSdk.getFaces(
      onSuccess: (List<FaceInfo> faceInfos) => {
        print("faceInfos: $faceInfos")},
      onError: (String error) {
        print(error);
      });
```

### Set multiple faces

To add multiple identities at once you can use `setFaces` method and provide a list of `FaceInfo` objects, but keep in mind it will firstly wipe out all currently stored identities.

```dart
FaceInfo faceInfo =
      FaceInfo("your_face_template", "your_customer_uuid", "your_template");
  FaceInfo faceInfo2 =
      FaceInfo("your_face_template2", "your_customer_uuid2", "your_template2");

  final faceInfos = <FaceInfo>[
    FaceInfo("your_face_template", "your_customer_uuid", "your_template"),
    FaceInfo("your_face_template2", "your_customer_uuid2", "your_template2")
  ];
  IncodeOnboardingSdk.setFaces(
      faces: faceInfos,
      onSuccess: (bool result) => {print("result: $result")},
      onError: (String error) {
        print(error);
      });
```

### Clear face database

To clear local database use `setFaces` method and provide empty `FaceInfo` list of objects.

```dart
  IncodeOnboardingSdk.setFaces(
      faces: List.empty(),
      onSuccess: (bool result) => {print("result: $result")},
      onError: (String error) {
        print(error);
      });
```

# Customization

To change theme and resources (text, images and videos) on Android platform please look at a guide [here](https://github.com/Incode-Technologies-Example-Repos/Incode-Welcome-Android-example/blob/master/docs/markdown/USER_GUIDE_CUSTOMIZATION.md).

To change resources on iOS platform please look at a guide [here](https://github.com/Incode-Technologies-Example-Repos/Incode-Welcome-Example-iOS/blob/main/USER_GUIDE_CUSTOMIZATION.md).

To change theme on iOS platform specify json theme configuration and call `IncodeOnboardingSdk.setTheme(theme: theme)`:

```dart
Map<String, dynamic> theme = {
  "buttons": {
    "primary": {
      "states": {
        "normal": {
          "cornerRadius": 16,
          "textColor": "#ffffff",
          "backgroundColor": "#ff0000"
        },
        "highlighted": {
          "cornerRadius": 16,
          "textColor": "#ffffff",
          "backgroundColor": "#5b0000"
        },
        "disabled": {
          "cornerRadius": 16,
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

IncodeOnboardingSdk.setTheme(theme: theme);
```

# Using SDK without an API KEY

To use the SDK without an API KEY, please follow these steps:
1) provide only a specific `apiUrl` only to the `init` method.
2) Afterwards, configure `OnboardingSessionConfiguration` with a `token` 
3) Provide it either to the `startOnboarding`, or if you're using sections to the `setupOnboardingSession` and then start your sections.

Example code that showcases steps 1) and 2:

```dart
IncodeOnboardingSdk.init(
      apiUrl: 'https://demo-api.incodesmile.com/0/',
      onError: (String error) {
        print('Incode SDK init failed: $error');
        setState(() {
          initSuccess = false;
        });
      },
      onSuccess: () {
        // Update UI, safe to start Onboarding
        print('Incode initialize successfully!');
        OnboardingSessionConfiguration sessionConfiguration = OnboardingSessionConfiguration(token: "YOUR_TOKEN");

        // call `startOnboarding` or `setupOnboardingSession` and then start sections.
      },
    );
```

# Other Public API methods

## SDK Mode

You can choose between two modes: `SdkMode.standard` and `SdkMode.captureOnly`. `SdkMode.standard` is the default, but if you would like to skip image upload and server validations for id and selfie scan you can specify captureOnly mode using method:

```dart
IncodeOnboardingSdk.setSdkMode(sdkMode: SdkMode.captureOnly);
```

## Allowing user to cancel the flow

You can use `showCloseButton` method to display an 'X' button on the top right of each module, so that user can cancel the flow at any point:

```dart
IncodeOnboardingSdk.showCloseButton(allowUserToCancel: true);
```

## Set Localization Language

To programatically set localization language in runtime, call `IncodeSdk.setLocalizationLanguage`.
Parameters available for `IncodeSDK.setLocalizationLanguage` method:

- `language` - language used for runtime localization. Supported values are currently: 'en', 'es' , 'pt'.

```dart
IncodeOnboardingSdk.setLocalizationLanguage('es');
```

Additionally, on Android platform a new dependency needs to be added in your app's build/gradle:

```
  implementation 'com.incode.sdk:extensions:1.1.0'
```

## Set string

To programatically set and update strings in runtime, call `IncodeSdk.setString`.
Parameters available for `IncodeSDK.setString` method:

- `strings`: Map<String, dynamic>. Map of string keys and its values.

```dart
    Map<String, dynamic> strings = {
      /// iOS labels
      'incdOnboarding.idChooser.title': 'My Custom chooser title',

      /// Android labels
      'onboard_sdk_id_type_chooser_title': 'My Custom chooser title',
    };
    IncodeOnboardingSdk.setString(strings: strings);
```

Additionally, on Android platform a new dependency needs to be added in your app's build/gradle:

```
  implementation 'com.incode.sdk:extensions:1.1.0'
```

For iOS please check documentation here:
`https://docs.incode.com/docs/ios/LOCALIZATION_GUIDE#list-of-localizable-texts`

For Android please check documentation here:
`https://docs.incode.com/docs/android/USER_GUIDE_CUSTOMIZATION#32-dynamic-localization`


## Get Score API

You can use `getUserScore` method to fetch current onboarding session user score at any point:

```dart
IncodeOnboardingSdk.getUserScore(
        onSuccess: (UserScoreResult result) {
          print("userScore: $result");
        },
        onError: (String error) {
           print("userScore error: $error");
        });
```

`UserScoreResult` has `extendedUserScoreJsonData` String field which contains full user data in a json format.

## AddNom151Archive API

You can use `addNOM151Archive` method to generate and fetch Nom151Archive:

```dart
IncodeOnboardingSdk.addNOM151Archive(
        onSuccess: (AddNom151Result addNom151Result) {
      String? signature = addNom151Result.signature;
      String? archiveUrl = addNom151Result.archiveUrl;
    }, onError: (String error) {
      print('Incode addNOM151Archive error: $error');
    });
```

`AddNom151Result` contains two String fields `signature` and `archiveUrl` as an and result.

## Get user OCR data API

You can use `getUserOCRData` method to fetch user OCR data for a specific session:

```dart
IncodeOnboardingSdk.getUserOCRData(
    token: "{SESSION_TOKEN}",
    onSuccess: (GetUserOCRDataResult result) {
      print(result); //
    },
    onError: (String error) {
      print(error);
    },
  );
```

`GetUserOCRDataResult` contains a String field `ocrData`, which represents full OCR data in a JSON format.

# Known issues

- Running the app on iOS simulator from VSCode isn't supported currently. Please run the app from Xcode for now if you want to test it on iOS Simulator.
NOTE: Don't forget to set `testMode` to `true` before running the app.
