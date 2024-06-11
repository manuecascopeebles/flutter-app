# 3.1.0 (May 15th 2024)

- Added new API method `startFlow` to support start or resume an onboarding session based on the provided session configuration and starting module.
- Added new API method `startFlowFromDeepLink` to support resume an onboarding session based on the provided deep link URL.
- Added new optional parameter `enableIdSummaryScreen` to the `ProcessId` module
- Added new optional parameters to the `initialize` method
- `initialize` method when rejected now returns a typed error `IncodeSdkInitError` (as a string value).
- Fixed Android crash when adding Video Selfie and User Consent configurations without params

Using iOS 5.27.1-s-l and Android 5.26.0

# 3.0.0 (Mar 18th 2024)

- Android `core-light` dependency is now part of the Flutter SDK. Breaking change, so please follow the guide in the migration [guide](MIGRATION_GUIDE.md) how to remove `core-light` from the list of your app's dependencies in the `build.gradle`.
- Added `setLocalizationLanguage` method used for runtime localization. Please check [here](README.md#set-localization-language) for more details.
- Added dynamic localization and updating strings in runtime with new API method `setString`. Please check [here](README.md#set-string) for more details.
- Added `Antifraud` module.
- Added `UserConsentModule` module.
- Added new API method `startWorkflow` to support workflows
- Added `isBackgroundExecuted` param to the `GovernmentValidation` module

Using iOS 5.26.0-s-l and Android 5.24.0

# 2.8.0 (Nov 19th)

- Added `GlobalWatchlist` module
- Added new parameter `idScanCameraFacing` for `VideoSelfie` module, which can be used to select front or back camera for ID scan

Using iOS 5.22.0-s-l and Android 5.21.0
# 2.7.0 (Nov 7th)

- Added `QRScan` module
- Fixed configuration issue for `VideoSelfie` module when `voiceConsentQuestionsCount` was not respected correctly on Android platform
- Added optional `defaultRegionPrefix` parameter to phone input module
- iOS requirements changed to Xcode 14.1 and iOS 13.0 target as minimum supported versions

Using iOS 5.20.1-s-l and Android 5.20.0

# 2.6.0 (Sep 18th)

- Added `recordSessionConfig` parameter to the `startOnboarding` and `startNewOnboardingSection`, which can be used to record ID and Selfie capture sessions.
- Added `MLConsent` module
- Breaking change, please update Android gradle settings and Incode's Android core depedency as specified in the migration [guide](MIGRATION_GUIDE.md)

Using iOS 5.17.0-s-l and Android 5.17.2

# 2.4.0 (May 19th 2023)

- Breaking change, please update Android gradle settings and Incode's Android core depedency as specified in the migration [guide](MIGRATION_GUIDE.md)
- Added `addFace`, `removeFace`, `setFaces` and `getFaces` methods to the `IncdOnboardingSdk`
- Added `faceAuthModeFallback`, `lensesCheck`, `spoofThreshold`, `recognitionThreshold` to the `FaceLogin` object provided to the `startFaceLogin` method
- Added `hasLenses` to the `FaceLoginResult` object.
- Android `minSdkVersion` is now 21

Using iOS 5.16.0-s-l and 5.16.0 Android SDKs

# 2.3.0 (Jan 6 2023)

- Added `getUserOCRData` method that fetches OCR data for a specific onboarding session.

Using 5.11.0 iOS-s-l, Android 5.13.0

# 2.2.0 (Dec 9 2022)

- Android core dependency has been updated. Please refer [here](MIGRATION_GUIDE.md) for more details.
- Added Name module, add it by calling `addFullName` method in the `OnboardingFlowConfiguration`
- Added `addNOM151Archive` method
- Added FaceLogin.FaceAuthMode `kiosk` option that triggers Kiosk login on Android platform. Kiosk dependency is mandatory, please add `com.incode.sdk:kiosk-login:1.0.0` to your app's `build.gradle`.
- Added `logAuthenticationEnabled` to the `FaceLogin` params. Specify `false` if you want to disable logging and statistics updates for authentications to get faster performance when calling `startFaceLogin`. Currently supported on Android only.

Using 5.10.0 iOS-s-l, Android 5.13.0

# 2.1.0 (Oct 19 2022)

- Android core dependency has been updated. Please refer here[MIGRATION_GUIDE.md] for more details.
- Added Email module
- Added `getUserScore` method
- Added `showCloseButton` method
- Added `nameMatched` field to the `FaceMatchResult` as part of the `onFaceMatchCompleted` callback
- Fixed `onUserCancelled` callback method not getting triggered on iOS
- Fixed issue of flow configuration not being used when `OnboardingSessionConfiguration` object is provided with a `token`
- Fixed issue of bad flow configuration for ID scan when it is split in front and back modules.

Using 5.8.1 iOS-s-l, Android 5.10.0

# 2.0.1 (Aug 26 2022)

- Bugfix ProcessId module not being added to IdScan automatically on Android devices
- Fixed crash on `setupOnboardingSession` when specifying `token` if SDK is initialized without API key.
- Fixed bad Swift Import path for iOS frameworks after running `pod install`

# 2.0.0 (Aug 16 2022)

- Added `setupOnboardingSession` that replaces `creatingNewOnboardingSession` and `setOnboardingSession`. Please check [here](MIGRATION_GUIDE.md) for more details.
- Add `interviewId` and `token` to `OnboardingSessionConfig`
- Added `startFaceLogin` method
- Added `extendedUserScoreJsonData` to UserScoreResult that contains raw JSON for the score.
- Bugfix `configurationId` not set when using startOnboarding
- Bugfix UserScore not parsed properly on Android devices

Using iOS 5.4.0-s-l, Android 5.4.0

# 1.2.0 (Feb 23 2022)

- Added option to separate `IdScan` module into three segments - Front capture, Back capture and newly introduced `ProcessId` module. `onIdValidationCompleted` callback now split into `onIdFrontCompleted`, `onIdBackCompleted` and `onIdProcessed`. Added more data in the ID capture results, such as `cropeedFace`, `chosenIdType` and `classifiedIdType`.
- `DocumentScan` module now supports `addressStatement`, `medicalDoc`, `paymentProof`, `otherDocument1`, `otherDocument2`.
- `DocumentScanResult` now contains `image`, `documentType` that was selected, `address` that contains parsed OCR data in case of `addressStatement`, and `ocrData` that contains full OCR data.

Using iOS 4.1.1-d, Android 4.3.1

# 1.1.0 (Jan 18 2022)

- Added switching between `Capture only` and `Standard` SDK mode via `setSdkMode` method.
- Added Sections API that allows more flexibile onboarding flow that can be split in multiple sections
- Added Modules - `Signature`, `Document Scan`, `Captcha`, `CURP`
- Added Theme Customization via `setTheme` method that accepts JSON in order to change theme on iOS platform. For Android please use this guide:
https://github.com/Incode-Technologies-Example-Repos/Incode-Welcome-Android-example/blob/master/docs/markdown/USER_GUIDE_CUSTOMIZATION.md

# 1.0.0

- Initial Flugger IncodeOnboarding SDK release
