//
//  SwiftOnboardingFlutterWrapperPlugin+IncodeDelegate.swift
//  onboarding_flutter_wrapper
//
//  Created by Milos Pesic on 16/08/2022.
//

import Foundation
import IncdOnboarding

extension SwiftOnboardingFlutterWrapperPlugin: IncdOnboardingDelegate {

  func sinkError(code: String, message: String, details: Any?) {
    eventSink?(FlutterError(code: code, message: message, details: details))
  }

  func sinkCompleted(code: String, data: Any?) {
    var response: [String: Any?] = [:]
    response["code"] = code
    response["data"] = data
    eventSink?(response)
  }

  public func sinkOnEnd() {
    eventSink?(FlutterEndOfEventStream)
  }

  public func onSuccess() {
    sinkOnEnd();
  }

  public func onError(_ error: IncdFlowError) {
    sinkError(code: "onError", message: error.description, details: error.rawValue)
  }

  public func onIdFrontCompleted(_ result: IdScanResult) {
    parseIdScanResult(result: result, code: "onIdFrontCompleted")
  }

  public func onIdBackCompleted(_ result: IdScanResult) {
    parseIdScanResult(result: result, code: "onIdBackCompleted")
  }

  public func onIdProcessed(_ result: IdProcessResult) {
    sinkCompleted(code: "onIdProcessed", data: [
      "ocrData": result.ocrData != nil ? String(data: result.extendedOcrJsonData!, encoding: String.Encoding.utf8) : "{}"
    ])
  }

  public func onSelfieScanCompleted(_ result: IncdOnboarding.SelfieScanResult) {
    var ret: [String: Any?] = [
      "image": result.image?.pngData()
    ]
    if let spoofAttept = result.spoofAttempt {
      ret["spoofAttempt"] = spoofAttept
    }
    ret["base64Images"] = [
      "selfieBase64": result.selfieBase64,
      "selfieEncryptedBase64": result.selfieEncryptedBase64,
    ]
    sinkCompleted(code: "onSelfieScanCompleted", data: ret)
  }

  public func onFaceMatchCompleted(_ result: IncdOnboarding.FaceMatchResult) {
    sinkCompleted(code: "onFaceMatchCompleted", data: [
      "faceMatched": result.faceMatched ?? false,
      "idCategory": result.idCategories.contains(.primary) ? "primary" : "secondary",
      "existingUser": result.existingUser ?? false,
      "existingInterviewId": result.existingInterviewId as Any,
      "nameMatched": result.nameMatched ?? false,
    ])
  }

  public func onAddPhoneNumberCompleted(_ result: PhoneNumberResult) {
    sinkCompleted(code: "onAddPhoneNumberCompleted", data: ["phone": result.phone ?? ""])
  }

  public func onGeolocationCompleted(_ result: GeolocationResult) {
    sinkCompleted(code: "onGeolocationCompleted", data: ocrData(addressFields: result.addressFields))
  }

  public func onVideoSelfieCompleted(_ result: VideoSelfieResult) {
    sinkCompleted(code: "onVideoSelfieCompleted", data: ["success": result.success])
  }

  public func onMachineLearningConsentCompleted(_ result: MachineLearningConsentResult) {
     sinkCompleted(code: "onMLConsentCompleted", data: ["success": result.status])
  }

  public func onUserConsentGiven(_ result: UserConsentResult) {
      sinkCompleted(code: "onUserConsentCompleted", data: ["success": result.success])
  }
  
  public func onQRScanCompleted(_ result: QRScanResult) {
    sinkCompleted(code: "onQRScanCompleted", data: ["success": result.success])
  }

  public func onGlobalWatchlistCompleted(_ result: GlobalWatchlistModuleResult) {
    sinkCompleted(code: "onGlobalWatchlistCompleted", data: ["success": result.error != nil ? false : true])
  }

  public func onOnboardingSessionCreated(_ result: OnboardingSessionResult) {
    sinkCompleted(code: "onOnboardingSessionCreated", data: [
      "interviewId": result.interviewId,
      "regionCode": result.regionCode,
      "token": result.token,
    ])
  }

  public func onApproveCompleted(_ result: ApprovalResult) {
    sinkCompleted(code: "onApproveCompleted", data: [
      "success": result.success,
      "uuid": result.uuid ?? "",
      "customerToken": result.customerToken ?? ""
    ])
  }

  public func onUserScoreFetched(_ result: UserScore) {
    sinkCompleted(code: "onUserScoreFetched", data: TypeHelper.userScoreAsDict(userScore: result))
  }

  public func userCancelledSession() {
    sinkCompleted(code: "onUserCancelled", data: ["success": false])
  }

  public func onGovernmentValidationCompleted(_ result: GovernmentValidationResult) {
    sinkCompleted(code: "onGovernmentValidationCompleted", data: ["success": result.success])
  }

  public func onAntifraudCompleted(_ result: AntifraudResult) {
    sinkCompleted(code: "onAntifraudCompleted", data: ["success":  result.response?.result == .passed  ? true : false])
  }

  public func onOnboardingSectionCompleted(_ flowTag: String) {
    sinkCompleted(code: "onOnboardingSectionCompleted", data: [
      "flowTag": flowTag
    ])
  }

  public func onDocumentScanCompleted(_ documentScanResult: DocumentScanResult) {

    func getRawDocumentScanType(_ documentType: DocumentType) -> String { //TODO move this to a helper class
      var type = "addressStatement"
      switch (documentType) {
      case .medicalDoc:
        type = "medicalDoc"
      case .paymentProof:
        type = "paymentProof"
      case .otherDocument1:
        type = "otherDocument1"
      case .otherDocument2:
        type = "otherDocument2"
      case .otherDocument3:
        type = "otherDocument3"
      default:
        type = "addressStatement"
      }
      return type
    }

    var result = [
      "image": documentScanResult.documentImage?.pngData() as Any,
      "documentType": getRawDocumentScanType(documentScanResult.documentType)
    ]

    if let addressFieldsFromPoa = documentScanResult.addressFieldsFromPoa {
      var address: [String : String?] = [:]

      address["city"] = addressFieldsFromPoa.city
      address["colony"] = addressFieldsFromPoa.colony
      address["postalCode"] = addressFieldsFromPoa.postalCode
      address["street"] = addressFieldsFromPoa.street
      address["state"] = addressFieldsFromPoa.state

      result["address"] = address
    }


    if let data = documentScanResult.data as? Data {
      result["ocrData"] = String(data: data, encoding: String.Encoding.utf8) ?? "{}"
    }

    sinkCompleted(code: "onDocumentScanCompleted", data: result)
  }

  public func onSignatureCollected(_ result: SignatureFormResult) {
    sinkCompleted(code: "onSignatureCollected", data: [
      "signature": result.signature?.pngData(),
    ])
  }

  public func onCaptchaCompleted(_ result: CaptchaResult) {
    sinkCompleted(code: "onCaptchaCompleted", data: [
      "captcha": result.captcha,
    ])
  }

  public func onCURPValidationCompleted(_ result: CURPValidationResult) {
    sinkCompleted(code: "onCURPValidationCompleted", data: [
      "curp": result.curp as Any?,
      "valid": result.valid as Any?,
      "data": result.data,
    ])
  }

  public func onAddEmailAddressCompleted(_ result: EmailAddressResult) {
    sinkCompleted(code: "onAddEmailCompleted", data: [
      "email": result.email as Any?,
    ])
  }

  func ocrData(addressFields: OCRDataAddress?) -> [String: String] {
    return [
      "city": addressFields?.city ?? "",
      "colony": addressFields?.colony ?? "",
      "postalCode": addressFields?.postalCode ?? "",
      "street": addressFields?.street ?? "",
      "state": addressFields?.state ?? "",
    ]
  }

  public func onAddFullNameCompleted(_ result: UserNameInfoResult) {
    sinkCompleted(code: "onAddFullNameCompleted", data: [
      "name": result.name
    ])
  }

  func userScoreAsDict(userScore: UserScore) -> [String: Any] {
    func maybeToString(_ maybe: Any?) -> String {
      if let it = maybe {
        return "\(it)"
      }
      return ""
    }

    var result = [String: Any]()

    if let rawData = userScore.extendedUserScoreJsonData,
       let extendedUserScoreJsonData = String(data: rawData, encoding: String.Encoding.utf8) {
      result["extendedUserScoreJsonData"] = extendedUserScoreJsonData
    }

    if let overall = userScore.overall {
      result["overall"] = [
        "value": maybeToString(overall.value),
        "status": maybeToString(overall.status),
      ]
    }

    if let faceRecognition = userScore.faceRecognition {
      result["faceRecognition"] = [
        "value": maybeToString(faceRecognition.overall?.value),
        "status":maybeToString(faceRecognition.overall?.status),
      ]
    }

    if let idValidation = userScore.idValidation {
      result["idValidation"] = [
        "value": maybeToString(idValidation.overall?.value),
        "status":maybeToString(idValidation.overall?.status),
      ]
    }

    if let liveness = userScore.liveness {
      result["liveness"] = [
        "value": maybeToString(liveness.overall?.value),
        "status":maybeToString(liveness.overall?.status),
      ]
    }
    return result
  }

  func parseIdScanResult(result: IdScanResult, code: String) {
    let image: UIImage? = result.image
    let croppedFace: UIImage? = result.croppedFace

    sinkCompleted(code: code, data: [
      "image": image?.pngData() as Any,
      "base64Image": result.base64Image as Any,
      "croppedFace": croppedFace?.pngData() as Any,
      "classifiedIdType": result.classifiedIdType ?? "",
      "chosenIdType": result.chosenIdType == .passport ? "passport" : "id", // will be null on back ID result
      "idCategory": result.idCategory == .primary ? "primary" : "secondary",
      "scanStatus": result.scanStatus.rawValue,
    ])
  }

}
