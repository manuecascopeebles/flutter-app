//
//  ModulesConfigurationBuilder.swift
//  onboarding_flutter_wrapper
//
//  Created by Srdjan Petkovic on 7.10.21..
//

import Foundation
import IncdOnboarding

func getSessionConfigFromDictionary(_ dictionary: NSDictionary?) -> IncdOnboardingSessionConfiguration {
    guard let dictionary = dictionary else { return IncdOnboardingSessionConfiguration() }
    
    return IncdOnboardingSessionConfiguration(
        regionCode: dictionary.value(forKey: "userRegion") as? String,
        queue: TypeHelper.getConferenceTypeFromRawValue(dictionary.value(forKey: "queue") as? String),
        configurationId: dictionary.value(forKey: "configurationId") as? String,
        validationModules: TypeHelper.getValidationModulesFromRaw(dictionary.value(forKey: "onboardingValidationModules") as? [String]),
        customFields: dictionary.value(forKey: "customFields") as? [String:String],
        interviewId: dictionary.value(forKey: "interviewId") as? String,
        token: dictionary.value(forKey: "token") as? String,
        externalId: dictionary.value(forKey: "externalId") as? String
    )
}

func getFlowConfigFromDictionary(_ configRaw: NSDictionary?, recordSessionConfig: NSDictionary?) -> IncdOnboardingFlowConfiguration {
    guard let configRaw = configRaw else { return IncdOnboardingFlowConfiguration() }
    
    guard let modulesConfig = configRaw.value(forKey: "modules") as? [NSDictionary] else { return IncdOnboardingFlowConfiguration() }
    
    let config = IncdOnboardingFlowConfiguration()
    
    func shouldShowTutorial (_ module: NSDictionary, defaultValue: Bool = true) -> Bool {
        if let show = module.value(forKey: "showTutorials") {
            return show as! Bool
        }
        return defaultValue
    }

    if let recordSessionConfig = recordSessionConfig,
        let recordSession = recordSessionConfig["recordSession"] as? Bool,
        let forcePermission = recordSessionConfig["forcePermission"] as? Bool,
        recordSession {
        config.recordSession(forcePermission: forcePermission)
    }
    
    for moduleConfig in modulesConfig {
        let module = moduleConfig.value(forKey: "name") as! String
        
        let showTutorials = shouldShowTutorial(moduleConfig)
        
        switch module{
        case "Phone":
            let defaultRegionPrefix = moduleConfig.value(forKey: "defaultRegionPrefix") as? Int
            config.addPhone(defaultRegionPrefix: defaultRegionPrefix)
        case "IdScan":
            let idType = moduleConfig.value(forKey: "idType") as? String
            let idCategory = moduleConfig.value(forKey: "idCategory") as? String
            let scanStepString = moduleConfig.value(forKey: "scanStep") as? String ?? "both"
            var scanStep: ScanStep
            switch scanStepString {
            case "front":
                scanStep = .front
                break;
            case "back":
                scanStep = .back
                break;
            default:
                scanStep = .both
                break;
            }
            
            if (idType != nil && idCategory != nil) {
                config.addIdScan(idType: idType == "passport" ? .passport : .id, scanStep:scanStep, idCategory: idCategory == "primary" ? .primary : .secondary, showTutorials: showTutorials)
            }
            else if (idType != nil) {
                config.addIdScan(idType: idType == "passport" ? .passport : .id, scanStep: scanStep, showTutorials: showTutorials)
            }
            else if (idCategory != nil) {
                config.addIdScan(scanStep: scanStep, idCategory: idCategory == "primary" ? .primary : .secondary, showTutorials: showTutorials)
            }
            else {
                config.addIdScan(scanStep: scanStep, showTutorials: showTutorials)
            }
        case "DocumentScan":
            let showDocumentProviderOptions = moduleConfig.value(forKey: "showDocumentProviderOptions") as? Bool?
            let documentTypeString = moduleConfig.value(forKey: "documentType") as? String?
            var documentType: DocumentType;
            switch documentTypeString {
            case "addressStatement":
                documentType = .addressStatement
                break
            case "medicalDoc":
                documentType = .medicalDoc
                break
            case "paymentProof":
                documentType = .paymentProof
                break
            case "otherDocument1":
                documentType = .otherDocument1
                break
            case "otherDocument2":
                documentType = .otherDocument2
                break
            case "creditCard":
                documentType = .creditCard
                break
            case .none:
                documentType = .addressStatement
                break
            case .some(_):
                documentType = .addressStatement
                break
            }
            
            config.addDocumentScan(showTutorials: shouldShowTutorial(moduleConfig, defaultValue:IncdOnboardingManager.shared.showDocumentCaptureTutorials), showDocumentProviderOptions: showDocumentProviderOptions ?? IncdOnboardingManager.shared.showDocumentProviderOptions, documentType: documentType)
        case "Geolocation":
            config.addGeolocation()
        case "SelfieScan":
            config.addSelfieScan(showTutorials: showTutorials, lensesCheck: nil, brightnessThreshold: nil)
        case "FaceMatch":
            if let categoryString = moduleConfig.value(forKey: "idCategory") as? String {
                config.addFaceMatch(idCategory: categoryString == "primary" ? .primary : .secondary)
            } else{
                config.addFaceMatch()
            }
        case "Signature":
            config.addSignature()
        case "VideoSelfie":
            let videoSelfieConfiguration = VideoSelfieConfiguration()
            videoSelfieConfiguration.tutorials(enabled: showTutorials)
            
            let livenessCheck: Bool = moduleConfig.value(forKey: "selfieLivenessCheck") as? Bool ?? IncdOnboardingManager.shared.videoSelfieLivenessCheck
            if let selfieScanMode = moduleConfig.value(forKey: "selfieScanMode") as? String {
                if selfieScanMode == "faceMatch" {
                    videoSelfieConfiguration.selfieScan(performLivenessCheck: livenessCheck, mode: .faceMatch)
                } else if selfieScanMode == "selfieMatch" {
                    videoSelfieConfiguration.selfieScan(performLivenessCheck: livenessCheck, mode: .selfieMatch)
                }
            }

            if let idScanCameraFacing = moduleConfig.value(forKey: "idScanCameraFacing") as? String {
                if idScanCameraFacing == "front" {
                    videoSelfieConfiguration.cameraFacingConfig.idFrontCameraFacing = .front
                    videoSelfieConfiguration.cameraFacingConfig.idBackCameraFacing = .front
                } else if idScanCameraFacing == "back" {
                    videoSelfieConfiguration.cameraFacingConfig.idFrontCameraFacing = .back
                    videoSelfieConfiguration.cameraFacingConfig.idBackCameraFacing = .back
                }
            }
            
            if let showIdScan = moduleConfig.value(forKey: "showIdScan") as? Bool {
                videoSelfieConfiguration.idScan(enabled: showIdScan, compareIdEnabled: true)
            }
            if let poa = moduleConfig.value(forKey: "showDocumentScan") as? Bool {
                videoSelfieConfiguration.documentScan(enabled: poa)
            }
            
            if let showVoiceConsent = moduleConfig.value(forKey: "showVoiceConsent") as? Bool {
                if let questionsCount = moduleConfig.value(forKey: "voiceConsentQuestionsCount") as? Int {
                    videoSelfieConfiguration.voiceConsent(enabled: showVoiceConsent, questionsCount: questionsCount)
                } else {
                    videoSelfieConfiguration.voiceConsent(enabled: showVoiceConsent);
                }
            }
            config.addVideoSelfie(videoSelfieConfiguration: videoSelfieConfiguration)
        case "MLConsent":
            if let type = moduleConfig.value(forKey: "type") as? String {
                let regulationType: RegulationType = type == "gdpr" ? .gdpr : .us
                config.addMachineLearningConsent(type: regulationType)
            } else{
                print("ML Consent type missing")
            }
        case "UserConsent":
            if let title = moduleConfig.value(forKey: "title") as? String,
            let content = moduleConfig.value(forKey: "content") as? String {
                config.addUserConsent(title: title, content: content)
            } else {
                print("User Consent title and content missing")
            }
        case "Conference":
            config.addVideoConference(disableMicOnCallStarted: moduleConfig.value(forKey: "disableMicOnCallStarted") as? Bool)
        case "Approve":
            config.addApproval(forceApproval: moduleConfig.value(forKey: "forceApproval") as? Bool)
        case "UserScore":
            var mode: UserScoreFetchMode?
            if let modeName = moduleConfig.value(forKey: "mode") as? String {
                mode = (modeName == "fast") ? UserScoreFetchMode.fast : UserScoreFetchMode.accurate
            }
            config.addUserScore(userScoreFetchMode: mode)
            break;
        case "QRScan":
            config.addQRScan(showTutorials: showTutorials)
        case "GlobalWatchlist":
            config.addGlobalWatchlist()
        case "Captcha":
            config.addCaptcha()
        case "GovernmentValidation":
          if let isBackgroundExecuted = moduleConfig.value(forKey: "isBackgroundExecuted") as? Bool {
            config.addGovernmentValidation(isBackgroundExecuted: isBackgroundExecuted)
          } else {
            config.addGovernmentValidation()
          }
        case "Antifraud":
            config.addAntifraud()
        case "CURPValidation":
            config.addCURPValidation()
        case "ProcessId":
            let enableIdSummaryScreen = moduleConfig.value(forKey: "enableIdSummaryScreen") as? Bool 
            print("🌸 ${enableIdSummaryScreen}")
            if let categoryString = moduleConfig.value(forKey: "idCategory") as? String {
                config.addIdProcess(idCategory: categoryString == "primary" ? .primary : .secondary, enableIdSummaryScreen: enableIdSummaryScreen)
            } else {
                config.addIdProcess(enableIdSummaryScreen: enableIdSummaryScreen)
            }
        case "Email":
            config.addEmail()
        case "FullName":
            config.addFullName()
        default:
            print("Unknown config option \(module)")
        }
    }
    return config
}
