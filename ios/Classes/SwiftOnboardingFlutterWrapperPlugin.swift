import Flutter
import IncdOnboarding
import UIKit

public class SwiftOnboardingFlutterWrapperPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {

  var eventSink: FlutterEventSink?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let methodChannel = FlutterMethodChannel(
      name: "onboarding_flutter_wrapper/method", binaryMessenger: registrar.messenger())
    let eventChannel = FlutterEventChannel(
      name: "onboarding_flutter_wrapper/event", binaryMessenger: registrar.messenger())
    let instance = SwiftOnboardingFlutterWrapperPlugin()
    registrar.addMethodCallDelegate(instance, channel: methodChannel)

    eventChannel.setStreamHandler(instance)
  }

  public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink)
    -> FlutterError?
  {
    eventSink = events
    return nil
  }
  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    eventSink = nil
    return nil
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let arguments = call.arguments as? NSDictionary
    var response: [String: Any?] = [:]

    switch call.method {
    case "initialize":
      let url: String = arguments?["apiUrl"] as? String ?? ""
      let apiKey: String = arguments?["apiKey"] as? String ?? ""
      let loggingEnabled: Bool = arguments?["loggingEnabled"] as? Bool ?? true
      let testMode: Bool = arguments?["testMode"] as? Bool ?? false
      let waitForTutorials = arguments?["waitForTutorials"] as? Bool
      let disableJailbreakDetection: Bool? = arguments?["disableJailbreakDetection"] as? Bool
      let externalAnalyticsEnabled: Bool? = arguments?["externalAnalyticsEnabled"] as? Bool
      let externalScreenshotsEnabled: Bool? = arguments?["externalScreenshotsEnabled"] as? Bool
      // let disableEmulatorDetection: Bool? = arguments?["disableEmulatorDetection"] as? Bool
      // let disableRootDetection: Bool = arguments?["disableRootDetection"] as? Bool
      applyCustomTheme()

      DispatchQueue.main.async {

        if let waitForTutorials = waitForTutorials {
          IncdOnboardingManager.shared.waitForTutorials = waitForTutorials
        }

        if let disableJailbreakDetection = disableJailbreakDetection {
          IncdOnboardingManager.shared.disableJailbreakDetection = disableJailbreakDetection
        }

        if let externalAnalyticsEnabled = externalAnalyticsEnabled {
          IncdOnboardingManager.shared.externalAnalyticsEnabled = externalAnalyticsEnabled
        }

        if let externalScreenshotsEnabled: Bool = externalScreenshotsEnabled {
          IncdOnboardingManager.shared.enableExternalScreenshots = externalScreenshotsEnabled
        }

        IncdOnboardingManager.shared.initIncdOnboarding(
          url: url, apiKey: apiKey, loggingEnabled: loggingEnabled, testMode: testMode
        ) { (success, error) in
          if success == true {
            print("Incode SDK init complete")
            response["success"] = true
          } else {
            response["success"] = false
            let errorMsg: String
            switch error {
            case .testModeEnabled:
              errorMsg = IncodeSdkInitError.testModeEnabled.rawValue
            case .simulatorDetected:
              errorMsg = IncodeSdkInitError.simulatorDetected.rawValue
            default:
              errorMsg = IncodeSdkInitError.unknown.rawValue
            }
            response["error"] = errorMsg
            print("Incode SDK init failed: \(errorMsg)")
          }
          result(response)
        }
      }
    case "startOnboarding":
      let flutterViewController: UIViewController =
        (UIApplication.shared.delegate?.window??.rootViewController)!

      IncdOnboardingManager.shared.presentingViewController = flutterViewController

      print("Starting onboarding")

      let sessionConfig = getSessionConfigFromDictionary(
        arguments?.value(forKey: "sessionConfig") as? NSDictionary)
      let flowConfig = getFlowConfigFromDictionary(
        arguments?.value(forKey: "flowConfig") as? NSDictionary,
        recordSessionConfig: arguments?.value(forKey: "recordSessionConfig") as? NSDictionary)

      IncdOnboardingManager.shared.startOnboarding(
        sessionConfig: sessionConfig,
        flowConfig: flowConfig,
        delegate: self
      )
    case "startWorkflow":
      let flutterViewController: UIViewController =
        (UIApplication.shared.delegate?.window??.rootViewController)!

      IncdOnboardingManager.shared.presentingViewController = flutterViewController

      print("Starting workflow")

      let sessionConfig = getSessionConfigFromDictionary(
        arguments?.value(forKey: "sessionConfig") as? NSDictionary)

      IncdOnboardingManager.shared.startWorkflow(
        sessionConfig: sessionConfig,
        delegate: self
      )
    case "startFlow":
      let flutterViewController: UIViewController =
        (UIApplication.shared.delegate?.window??.rootViewController)!

      IncdOnboardingManager.shared.presentingViewController = flutterViewController

      print("Starting flow")

      let sessionConfig = getSessionConfigFromDictionary(
        arguments?.value(forKey: "sessionConfig") as? NSDictionary)
      let moduleId = arguments?.value(forKey: "moduleId") as? String

      IncdOnboardingManager.shared.startFlow(
        sessionConfig: sessionConfig,
        delegate: self,
        moduleId: moduleId)
    case "startFlowFromDeepLink":
      let flutterViewController: UIViewController =
        (UIApplication.shared.delegate?.window??.rootViewController)!

      print("Starting flow from deep link")

      if let url = arguments?.value(forKey: "url") as? String,
        let linkUrl = URL(string: url)
      {
        IncdOnboardingManager.shared.presentingViewController = flutterViewController
        IncdOnboardingManager.shared.startFlow(url: linkUrl, delegate: self)
      } else {
        response["success"] = false
        response["error"] = "Error - Invalid URL"
        result(response)
      }
    case "startNewOnboardingSection":
      guard let flowTag = arguments?["flowTag"] as? String else {
        eventSink!(
          FlutterError(
            code: "Error", message: "StartNewOnboardingSection error. No flowTag provided.",
            details: ""))
        return
      }
      guard let flowConfigDict = arguments?.value(forKey: "flowConfig") as? NSDictionary else {
        response["success"] = false
        response["error"] = "Error config is null"
        result(response)
        return
      }

      let flowConfig = getFlowConfigFromDictionary(
        flowConfigDict,
        recordSessionConfig: arguments?.value(forKey: "recordSessionConfig") as? NSDictionary)

      let flutterViewController: UIViewController =
        (UIApplication.shared.delegate?.window??.rootViewController)!

      IncdOnboardingManager.shared.presentingViewController = flutterViewController

      print("Starting new onboarding section")

      IncdOnboardingManager.shared.startOnboardingSection(
        flowConfig: flowConfig, sectionTag: flowTag, delegate: self)
    case "setupOnboardingSession":
      let sessionConfig = getSessionConfigFromDictionary(
        arguments?.value(forKey: "sessionConfig") as? NSDictionary)

      DispatchQueue.main.async {
        IncdOnboardingManager.shared.setupOnboardingSession(sessionConfig: sessionConfig) {
          (creationResult) in
          var response: [String: Any?] = [:]
          if creationResult.error != nil {
            response["success"] = false
            response["error"] = "Incode flow creation failed."
          } else {
            response["success"] = true
            response["data"] = [
              "interviewId": creationResult.interviewId,
              "token": creationResult.token,
              "regionCode": creationResult.regionCode,
            ]
          }
          result(response)
        }
      }
      break
    case "finishFlow":
      IncdOnboardingManager.shared.finishFlow { (success, error) in
        if success {
          response["success"] = true
        } else {
          response["success"] = false
          response["error"] = error?.rawValue
        }
        result(response)
      }
    case "setTheme":
      if let jsonTheme = arguments?.value(forKey: "theme") as? String {
        IncdTheme.loadJsonTheme(jsonTheme)
      }
    case "setSdkMode":
      var response: [String: Any?] = [:]

      if let sdkMode = arguments?.value(forKey: "sdkMode") as? String {
        if sdkMode == "standard" {
          IncdOnboardingManager.shared.sdkMode = .standard
        } else if sdkMode == "captureOnly" {
          IncdOnboardingManager.shared.sdkMode = .captureOnly
        } else if sdkMode == "submitOnly" {
          IncdOnboardingManager.shared.sdkMode = .submitOnly
        }

        response["success"] = true

      } else {
        response["success"] = false
      }
      result(response)

    case "showCloseButton":
      var response: [String: Any?] = [:]
      if let allowUserToCancel = arguments?.value(forKey: "allowUserToCancel") as? Bool {
        IncdOnboardingManager.shared.allowUserToCancel = allowUserToCancel
        response["success"] = true

      } else {
        response["success"] = false
      }
      result(response)

    case "setLocalizationLanguage":
      var response: [String: Any?] = [:]

      if let language = arguments?.value(forKey: "language") as? String {
        IncdLocalization.localizationLanguage = language as String
        response["success"] = true
      } else {
        response["success"] = false
      }

      result(response)

    case "setString":
      var response: [String: Any?] = [:]

      if let strings = arguments?.value(forKey: "strings") as? [String: String] {
        for (key, value) in strings {
          if let key = key as? String, let value = value as? String {
            IncdLocalization.current[key] = value
          }
        }
        response["success"] = true
      } else {
        response["success"] = false
      }

      result(response)

    case "startFaceLogin":
      let arguments = arguments?.value(forKey: "faceLogin") as? NSDictionary
      let faceAuthModeString = arguments?.value(forKey: "faceAuthMode") as? String?
      var faceAuthMode: FaceAuthMode
      switch faceAuthModeString {
      case "local":
        faceAuthMode = .local
      case "hybrid":
        faceAuthMode = .hybrid
      case "server":
        faceAuthMode = .server
      default:
        faceAuthMode = .server
      }

      let flutterViewController: UIViewController =
        (UIApplication.shared.delegate?.window??.rootViewController)!
      IncdOnboardingManager.shared.presentingViewController = flutterViewController

      if let recognitionThreshold = arguments?.value(forKey: "recognitionThreshold") as? Double {
        IncdOnboardingManager.shared.recognitionThreshold = Float(recognitionThreshold)
      }

      if let spoofThreshold = arguments?.value(forKey: "spoofThreshold") as? Double {
        IncdOnboardingManager.shared.spoofThreshold = Float(spoofThreshold)
      }
      IncdOnboardingManager.shared.startFaceLogin(
        showTutorials: arguments?.value(forKey: "showTutorials") as? Bool,
        customerUUID: arguments?.value(forKey: "customerUUID") as? String,
        faceAuthMode: faceAuthMode,
        faceAuthModeFallback: arguments?.value(forKey: "faceAuthModeFallback") as? Bool ?? false,
        lensesCheck: arguments?.value(forKey: "lensesCheck") as? Bool,
        faceMaskCheck: arguments?.value(forKey: "faceMaskCheck") as? Bool,
        logAuthenticationEnabled: arguments?.value(forKey: "logAuthenticationEnabled") as? Bool
      ) { faceLoginResult in
        if let error = faceLoginResult.error {
          response["success"] = false
          response["error"] = error.rawValue
        } else {
          response["success"] = faceLoginResult.faceLoginResult?.success == true
          response["data"] = TypeHelper.mapFaceLoginResult(faceLoginResult)
        }
        result(response)
      }
      break
    case "addFace":
      guard let faceTemplate = arguments?.value(forKey: "faceTemplate") as? String,
        let customerUUID = arguments?.value(forKey: "customerUUID") as? String,
        let templateId = arguments?.value(forKey: "templateId") as? String
      else {
        response["success"] = false
        response["error"] =
          "Incorrect input values, please make sure faceTemplate, customerUUID, and templateId are provided correctly"
        result(response)
        return
      }
      let faceInfo = FaceInfo(
        faceTemplate: faceTemplate,
        customerUUID: customerUUID,
        templateId: templateId)
      IncdOnboardingManager.shared.addFace(faceInfo)
      response["success"] = true
      result(response)
    case "removeFace":
      let customerUUID = arguments?.value(forKey: "customerUUID") as? String
      guard let customerUUID = arguments?.value(forKey: "customerUUID") as? String else {
        response["success"] = false
        response["error"] =
          "Incorrect input value, please make sure customerUUID was provided correctly"
        return
      }
      IncdOnboardingManager.shared.removeFace(customerUUID: customerUUID)
      response["success"] = true
      result(response)
    case "getFaces":
      let faceInfos = IncdOnboardingManager.shared.getFaces()
      let faceInfoDictionary = faceInfos.map { $0.toDictionary() }
      guard
        let data = try? JSONSerialization.data(
          withJSONObject: faceInfoDictionary, options: .prettyPrinted)
      else {
        response["success"] = false
        response["error"] = "Couldn't serialize face info list"
        result(response)
        return
      }

      response["success"] = true
      response["data"] = String(data: data, encoding: String.Encoding.utf8)
      result(response)
    case "setFaces":
      guard let facesJSONArrayString = arguments?.value(forKey: "faces") as? String,
        let facesJSONArrayData = facesJSONArrayString.data(using: .utf8),
        let facesJSON = try? JSONSerialization.jsonObject(with: facesJSONArrayData, options: [])
          as? [[String: Any]]
      else {
        print("Coudln't deserialize facesJSON")
        response["success"] = false
        response["error"] = "Couldn't deserialize facesJSON"
        result(response)
        return
      }

      var faceInfoList = [FaceInfo]()
      for faceJSON in facesJSON {
        if let faceTemplate = faceJSON["faceTemplate"] as? String,
          let customerUUID = faceJSON["customerUUID"] as? String,
          let templateId = faceJSON["templateId"] as? String
        {
          faceInfoList.append(
            FaceInfo(
              faceTemplate: faceTemplate,
              customerUUID: customerUUID,
              templateId: templateId))
        }
      }

      IncdOnboardingManager.shared.setFaces(faceInfoList)
      response["success"] = true
      result(response)
    case "getUserScore":
      let fetchMode = arguments?.value(forKey: "fetchMode") as? String
      IncdOnboardingManager.shared.getUserScore(
        userScoreFetchMode: getUserScoreFetchMode(fetchMode)
      ) { userScoreResult in
        var response: [String: Any?] = [:]

        if let error = userScoreResult.error {
          response["success"] = false
          response["error"] = error.rawValue
        } else {
          response["success"] = true
          response["data"] = TypeHelper.userScoreAsDict(userScore: userScoreResult)
        }

        result(response)
      }

    case "addNOM151Archive":
      IncdOnboardingManager.shared.addNOM151Archive { addNOM151Result in
        var response: [String: Any?] = [:]

        guard addNOM151Result.error == nil else {
          response["success"] = false
          response["error"] = "Incode addNOM151Archive failed"
          result(response)
          return
        }
        response["success"] = true
        response["data"] = [
          "archiveUrl": addNOM151Result.archiveUrl,
          "signature": addNOM151Result.signature,
        ]
        result(response)
      }
    case "getUserOCRData":
      let token = arguments?.value(forKey: "token") as? String
      IncdOnboardingManager.shared.getUserOCRData(token) { userOcrData in
        var response: [String: Any?] = [:]

        if userOcrData.error == nil {
          response["success"] = true
          let ocrData =
            userOcrData.ocrData != nil
            ? String(data: userOcrData.extendedJsonData!, encoding: String.Encoding.utf8) : "{}"
          response["data"] = ["ocrData": ocrData]

        } else {
          response["success"] = false
          response["error"] = "Incode getUserOCRData failed"
        }

        result(response)
      }
      break
    default:
      result(FlutterMethodNotImplemented)
      break
    }

  }

  private func getUserScoreFetchMode(_ fetchMode: String?) -> UserScoreFetchMode? {
    guard let fetchMode = fetchMode else { return nil }

    switch fetchMode {
    case "fast":
      return .fast
    case "accurate":
      return .accurate
    default:
      return nil
    }
  }

  func applyCustomTheme() {
    let bineoIncTheme = BineoIncTheme()
    let customThemeConfiguration = bineoIncTheme.buildCustomTheme()

    var customTheme = IncdTheme.current

    // Apply colors
    customTheme.colors.accent = customThemeConfiguration.colors.accent
    customTheme.colors.primary = customThemeConfiguration.colors.primary
    customTheme.colors.background = customThemeConfiguration.colors.background
    customTheme.colors.secondaryBackground = customThemeConfiguration.colors.secondaryBackground
    customTheme.colors.success = customThemeConfiguration.colors.success
    customTheme.colors.error = customThemeConfiguration.colors.error
    customTheme.colors.warning = customThemeConfiguration.colors.warning
    customTheme.colors.cancel = customThemeConfiguration.colors.cancel
    customTheme.colors.primaryDark = customThemeConfiguration.colors.primaryDark

    // Apply fonts
    customTheme.fonts.title = customThemeConfiguration.fonts.title
    customTheme.fonts.hugeTitle = customThemeConfiguration.fonts.hugeTitle
    customTheme.fonts.subtitle = customThemeConfiguration.fonts.subtitle
    customTheme.fonts.boldedSubtitle = customThemeConfiguration.fonts.boldedSubtitle
    customTheme.fonts.smallSubtitle = customThemeConfiguration.fonts.smallSubtitle
    customTheme.fonts.info = customThemeConfiguration.fonts.info
    customTheme.fonts.body = customThemeConfiguration.fonts.body
    customTheme.fonts.boldedBody = customThemeConfiguration.fonts.boldedBody
    customTheme.fonts.buttonBig = customThemeConfiguration.fonts.buttonBig
    customTheme.fonts.buttonMedium = customThemeConfiguration.fonts.buttonMedium

    // Apply buttons
    customTheme.buttons.primary = customThemeConfiguration.buttons.primary
    customTheme.buttons.secondary = customThemeConfiguration.buttons.secondary
    customTheme.buttons.text = customThemeConfiguration.buttons.text
    customTheme.buttons.help = customThemeConfiguration.buttons.help

    // Apply labels
    customTheme.labels.title = customThemeConfiguration.labels.title
    customTheme.labels.secondaryTitle = customThemeConfiguration.labels.secondaryTitle
    customTheme.labels.subtitle = customThemeConfiguration.labels.subtitle
    customTheme.labels.secondarySubtitle = customThemeConfiguration.labels.secondarySubtitle
    customTheme.labels.smallSubtitle = customThemeConfiguration.labels.smallSubtitle
    customTheme.labels.info = customThemeConfiguration.labels.info
    customTheme.labels.secondaryInfo = customThemeConfiguration.labels.secondaryInfo
    customTheme.labels.body = customThemeConfiguration.labels.body
    customTheme.labels.secondaryBody = customThemeConfiguration.labels.secondaryBody
    customTheme.labels.code = customThemeConfiguration.labels.code

    // Apply custom components
    customTheme.customComponents.cameraFeedback =
      customThemeConfiguration.customComponents.cameraFeedback
    customTheme.customComponents.idCaptureHelp =
      customThemeConfiguration.customComponents.idCaptureHelp
    customTheme.customComponents.idSideLabel = customThemeConfiguration.customComponents.idSideLabel
    customTheme.customComponents.separator = customThemeConfiguration.customComponents.separator

    IncdTheme.current = customTheme
  }

}

public class BineoIncTheme {
  private struct Insets {
    static let bigInsets = UIEdgeInsets(top: 12, left: 56, bottom: 12, right: 56)
    static let mediumInsets = UIEdgeInsets(top: 12, left: 26, bottom: 12, right: 26)
  }

  private struct Margins {
    static let tutorialID = CGFloat(24 * 2 + 30)  // 24 from sides, 12 between buttons
  }

  private struct Colors {
    static var accent = UIColor(red: 0.984, green: 0.592, blue: 0.184, alpha: 1)  // FB972F
    static var primary = UIColor.black
    static var background = UIColor(red: 0.106, green: 0.122, blue: 0.133, alpha: 1)  // 1B1F22
    static var secondaryBackground = UIColor(red: 0.918, green: 0.918, blue: 0.925, alpha: 1)  // EAEAEC
    static var disabled = UIColor(red: 0.298, green: 0.298, blue: 0.298, alpha: 1)  // 4C4C4C
    static var primaryText = UIColor.white
    static var secondaryText = UIColor.white
    static var success = UIColor(red: 0.229, green: 0.667, blue: 0.208, alpha: 1)  // 3AAA35
    static var error = UIColor(red: 1.0, green: 0.435, blue: 0.4, alpha: 1)  // FF6F66
    static var warning = UIColor(red: 154 / 255, green: 57 / 255, blue: 100 / 255, alpha: 1)
    static var cancel = UIColor(red: 154 / 255, green: 80 / 255, blue: 170 / 255, alpha: 1)
    static var textColorPrimaryButton = UIColor(red: 0.333, green: 0.161, blue: 0.0, alpha: 1)  // 552900
    static var backgroundHighlight = UIColor(red: 1.0, green: 0.831, blue: 0.651, alpha: 1)  // FFD4A6
  }

  // private struct Fonts {
  //   static var title = BineoTheme.Typography.headline2
  //   static var hugeTitle = BineoTheme.Typography.headline2
  //   static var subtitle = BineoTheme.Typography.caption1
  //   static var boldedSubtitle = BineoTheme.Typography.caption1
  //   static var smallSubtitle = BineoTheme.Typography.caption3
  //   static var info = BineoTheme.Typography.body2
  //   static var body = BineoTheme.Typography.body1
  //   static var boldedBody = BineoTheme.Typography.body1Bold
  //   static var buttonBig = BineoTheme.Typography.buttons1
  //   static var buttonMedium = BineoTheme.Typography.buttons2
  // }

  func buildCustomTheme() -> ThemeConfiguration {

    let colorsConfig = ColorsConfiguration(
      accent: Colors.accent,
      primary: Colors.primary,
      background: Colors.background,
      secondaryBackground: Colors.secondaryBackground,
      success: Colors.success,
      error: Colors.error,
      warning: Colors.warning,
      cancel: Colors.cancel,
      primaryDark: UIColor.black)

    // let fontsConfig = FontsConfiguration(
    //   title: Fonts.title,
    //   hugeTitle: Fonts.hugeTitle,
    //   subtitle: Fonts.subtitle,
    //   boldedSubtitle: Fonts.boldedSubtitle,
    //   smallSubtitle: Fonts.smallSubtitle,
    //   info: Fonts.info,
    //   body: Fonts.body,
    //   boldedBody: Fonts.boldedBody,
    //   buttonBig: Fonts.buttonBig,
    //   buttonMedium: Fonts.buttonMedium)

    let buttonsConfig = ButtonsConfiguration(
      primary: primaryButton,
      secondary: secondaryButton,
      text: textButton,
      help: helpButton)

    let labelsConfig = LabelsConfiguration(
      title: titleLabelConfig,
      secondaryTitle: secondaryTitleLabelConfig,
      subtitle: subtitleLabelConfig,
      secondarySubtitle: secondarySubtitleLabelConfig,
      smallSubtitle: smallSubtitleLabelConfig,
      info: infoLabelConfig,
      secondaryInfo: secondaryInfoLabelConfig,
      body: bodyLabelConfig,
      secondaryBody: secondaryBodyLabelConfig,
      code: codeLabelConfig)

    let customComponents = CustomComponentsConfiguration(
      cameraFeedback: cameraFeedback,
      idCaptureHelp: idCaptureHelp,
      idSideLabel: idSideLabel,
      separator: separatorConfig)

    return ThemeConfiguration(
      colors: colorsConfig,
      // fonts: fontsConfig,
      buttons: buttonsConfig,
      labels: labelsConfig,
      customComponents: customComponents)
  }
}

//MARK: - Buttons
extension BineoIncTheme {

  private var primaryButton: ButtonConfiguration {
    let normal = ButtonThemedState(
      backgroundColor: UIColor(
        frame: CGRect(origin: .zero, size: CGSize(width: 200, height: 48)),
        colors: UIColor(red: 0.984, green: 0.592, blue: 0.184, alpha: 1),  // FB972F
        UIColor(red: 1.0, green: 0.51, blue: 0.0, alpha: 1)  // FF8200
      ),
      cornerRadius: 8,
      shadowColor: UIColor.black,
      shadowOffset: CGSize(width: 0, height: 4),
      shadowOpacity: 0.25,
      shadowRadius: 16,
      textColor: Colors.textColorPrimaryButton)
    var highlighted = normal
    highlighted.backgroundColor = Colors.backgroundHighlight
    highlighted.textColor = Colors.textColorPrimaryButton
    highlighted.transform = CGAffineTransform(scaleX: 0.99, y: 0.99)
    var disabled = normal
    disabled.backgroundColor = Colors.disabled
    disabled.textColor = UIColor.black

    let big = ButtonSizeVariant(
      height: 48,
      minWidth: UIScreen.main.bounds.width - 32.0,
      contentInsets: Insets.bigInsets)

    let medium = ButtonSizeVariant(
      height: 24,
      minWidth: (UIScreen.main.bounds.width - Margins.tutorialID) / 2,
      contentInsets: Insets.mediumInsets)

    return ButtonConfiguration(
      states: .init(
        normal: normal,
        highlighted: highlighted,
        disabled: disabled),
      big: big,
      medium: medium)
  }

  private var secondaryButton: ButtonConfiguration {
    let normal = ButtonThemedState(
      backgroundColor: .white,
      borderColor: Colors.primary,
      borderWidth: 1.0,
      textColor: Colors.primary)
    var highlighted = normal
    highlighted.backgroundColor = Colors.primary
    highlighted.textColor = Colors.accent
    highlighted.borderColor = Colors.primary
    highlighted.transform = .init(scaleX: 0.93, y: 0.93)
    highlighted.cornerRadius = 12
    var disabled = normal
    disabled.backgroundColor = .white
    disabled.textColor = .incdDisabled
    disabled.borderColor = .incdDisabled

    let big = ButtonSizeVariant(
      minWidth: UIScreen.main.bounds.width - 32.0,
      contentInsets: Insets.bigInsets)

    let medium = ButtonSizeVariant(
      height: 40,
      minWidth: 80,
      contentInsets: Insets.mediumInsets)

    return ButtonConfiguration(
      states: .init(normal: normal, highlighted: highlighted, disabled: disabled),
      big: big,
      medium: medium)
  }

  private var textButton: ButtonConfiguration {
    let normal = ButtonThemedState(
      backgroundColor: .clear,
      borderColor: .clear,
      borderWidth: 0,
      cornerRadius: 0,
      textColor: Colors.backgroundHighlight)

    var highlighted = normal
    highlighted.textColor = Colors.accent
    var disabled = normal
    disabled.textColor = .incdDisabled

    let big = ButtonSizeVariant(
      height: 48,
      minWidth: 200,
      contentInsets: .init(top: 8, left: 16, bottom: 8, right: 16))

    let medium = ButtonSizeVariant(
      height: 40,
      minWidth: 80,
      contentInsets: Insets.mediumInsets)

    return ButtonConfiguration(
      states: .init(normal: normal, highlighted: highlighted, disabled: disabled),
      big: big,
      medium: medium)
  }

  private var helpButton: ButtonConfiguration {
    let normal = ButtonThemedState(
      alpha: 1.0,
      backgroundColor: UIColor(
        frame: CGRect(origin: .zero, size: CGSize(width: 200, height: 48)),
        colors: UIColor(red: 0.984, green: 0.592, blue: 0.184, alpha: 1),
        UIColor(red: 1.0, green: 0.510, blue: 0.0, alpha: 1)),
      borderColor: .clear,
      borderWidth: 0.0,
      shadowColor: UIColor.black,
      shadowOffset: CGSize(width: 0, height: 4),
      shadowOpacity: 0.25,
      shadowRadius: 16,
      textColor: Colors.textColorPrimaryButton,
      iconImageName: nil,
      iconTintColor: nil,
      iconPosition: .none,
      iconPadding: nil)

    var highlighted = normal
    highlighted.backgroundColor = Colors.backgroundHighlight
    highlighted.textColor = Colors.textColorPrimaryButton
    highlighted.transform = CGAffineTransform(scaleX: 0.99, y: 0.99)

    return ButtonConfiguration(states: .init(normal: normal, highlighted: highlighted))
  }
}

//MARK: - Labels
extension BineoIncTheme {

  private var titleLabelConfig: LabelConfiguration {
    LabelConfiguration(textColor: Colors.primaryText)
  }

  private var secondaryTitleLabelConfig: LabelConfiguration {
    LabelConfiguration(textColor: Colors.secondaryText)
  }

  private var subtitleLabelConfig: LabelConfiguration {
    LabelConfiguration(textColor: Colors.primaryText)
  }

  private var secondarySubtitleLabelConfig: LabelConfiguration {
    LabelConfiguration(textColor: Colors.secondaryText)
  }

  private var smallSubtitleLabelConfig: LabelConfiguration {
    LabelConfiguration(textColor: Colors.primaryText)
  }

  private var infoLabelConfig: LabelConfiguration {
    LabelConfiguration(textColor: Colors.primaryText)
  }

  private var secondaryInfoLabelConfig: LabelConfiguration {
    LabelConfiguration(textColor: Colors.secondaryText)
  }

  private var bodyLabelConfig: LabelConfiguration {
    LabelConfiguration(textColor: Colors.primaryText)
  }

  private var secondaryBodyLabelConfig: LabelConfiguration {
    LabelConfiguration(textColor: Colors.secondaryText)
  }

  private var codeLabelConfig: LabelConfiguration {
    LabelConfiguration(textColor: Colors.primaryText, kerning: 16)
  }

}

//MARK: - Custom Components
extension BineoIncTheme {

  private var cameraFeedback: CameraFeedbackConfiguration {
    CameraFeedbackConfiguration(
      alpha: 0.5,
      backgroundColor: Colors.primary,
      cornerRadius: 6,
      textBackgroundColor: .black,
      textColor: Colors.secondaryText)
  }

  private var idCaptureHelp: IDCaptureHelpConfiguration {
    IDCaptureHelpConfiguration(commonIssueLayoutOrientation: .horizontal)
  }

  private var idSideLabel: IDSideLabelConfiguration {
    IDSideLabelConfiguration(
      alpha: 0.8,
      backgroundColor: Colors.background,
      borderColor: UIColor.white,
      borderWidth: 1.0,
      cornerRadius: 16)
  }

  private var separatorConfig: SeparatorConfiguration {
    SeparatorConfiguration(
      alpha: 1.0,
      color: UIColor.gray,
      cornerRadius: 0.5,
      padding: 16,
      thickness: 1)
  }

}

extension UIColor {

  /**
     Create a color from a view frame and 1 o more color to create a gradient color
     */
  convenience init(frame: CGRect, colors: UIColor...) {
    let backgroundGradientLayer = CAGradientLayer()
    backgroundGradientLayer.frame = frame

    guard colors.count > 1 else {
      self.init(cgColor: colors[0].cgColor)
      return
    }

    let cgColors = colors.map({ $0.cgColor })

    backgroundGradientLayer.colors = cgColors

    UIGraphicsBeginImageContext(backgroundGradientLayer.bounds.size)
    if let context = UIGraphicsGetCurrentContext() {
      backgroundGradientLayer.render(in: context)
    }
    let backgroundColorImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    if let backgroundColorImage {
      self.init(patternImage: backgroundColorImage)
      return
    }
    self.init(cgColor: UIColor.red.cgColor)
  }
}
