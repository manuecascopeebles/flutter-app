//
//  TypeHelper.swift
//  onboarding_flutter_wrapper
//
//  Created by Srdjan Petkovic on 2.8.22..
//

import Foundation
import IncdOnboarding

class TypeHelper {
    static func getConferenceTypeFromRawValue(_ rawType: String?) -> ConferenceQueue? {
        let queue: ConferenceQueue
        switch rawType {
        case "aristotle":
            queue = .aristotle
        case "buddha":
            queue = .buddha
        case "confucius":
            queue = .confucius
        case "diogenes":
            queue = .diogenes
        case "defaultQueue":
            queue = .defaultQueue
        default:
            queue = .defaultQueue
        }
        return queue
    }
    
    static func getValidationModulesFromRaw(_ dict: [String]?) -> [OnboardingValidationModule]? {
        var modules: [OnboardingValidationModule] = []
        dict?.forEach({ (value: Any) in
            let module = value as! String
            if let moduleEnum = OnboardingValidationModule.getOnboardingValidationModuleBy(name: module) {
                modules.append(moduleEnum)
            }
        })
        return modules;
    }
    
    static func mapFaceLoginResult(_ selfieScanResult: IncdOnboarding.SelfieScanResult) -> [String: Any] {
      var result: [String: Any] = [
        "faceMatched": selfieScanResult.faceLoginResult?.success == true,
        "spoofAttempt": selfieScanResult.spoofAttempt == true,
        "base64Images": ["selfieBase64": selfieScanResult.selfieBase64, "selfieEncryptedBase64": selfieScanResult.selfieEncryptedBase64]
      ]

      if let image = selfieScanResult.image?.pngData() {
        result["image"] = image
      }
      
      if let interviewId = selfieScanResult.faceLoginResult?.interviewId {
        result["interviewId"] = interviewId
      }

      if let transactionId = selfieScanResult.faceLoginResult?.transactionId {
        result["transactionId"] = transactionId
      }

      if let customerUUID = selfieScanResult.faceLoginResult?.customerUUID {
        result["customerUUID"] = customerUUID
      }

      if let interviewToken = selfieScanResult.faceLoginResult?.interviewToken {
        result["interviewToken"] = interviewToken
      }

      if let token = selfieScanResult.faceLoginResult?.token {
        result["token"] = token
      }

      if let hasFaceMask = selfieScanResult.faceLoginResult?.hasFaceMask {
        result["hasFaceMask"] = hasFaceMask == true
      } else {
        result["hasFaceMask"] = false
      }

      if let hasLenses = selfieScanResult.faceLoginResult?.hasLenses {
        result["hasLenses"] = hasLenses == true
      } else {
        result["hasLenses"] = false
      }

      return result
    }

    static func userScoreAsDict(userScore: UserScore) -> [String: Any] {
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
                "status": maybeToString(faceRecognition.overall?.status),
            ]
        }

        if let idValidation = userScore.idValidation {
            result["idValidation"] = [
                "value": maybeToString(idValidation.overall?.value),
                "status": maybeToString(idValidation.overall?.status),
            ]
        }

        if let liveness = userScore.liveness {
            result["liveness"] = [
                "value": maybeToString(liveness.overall?.value),
                "status": maybeToString(liveness.overall?.status),
            ]
        }
        return result
    }
}

extension FaceInfo {

  func toDictionary() -> [String: Any] {
          return [
              "faceTemplate": faceTemplate,
              "customerUUID": customerUUID,
              "templateId": templateId
          ]
      }
}
