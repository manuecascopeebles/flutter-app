package com.incode.onboarding_flutter_wrapper;

import android.os.Build;
import android.util.Log;

import com.incode.welcome_sdk.FlowConfig;
import com.incode.welcome_sdk.IdCategory;
import com.incode.welcome_sdk.IncodeWelcome;
import com.incode.welcome_sdk.SessionConfig;
import com.incode.welcome_sdk.modules.DocumentScan;
import com.incode.welcome_sdk.modules.FaceMatch;
import com.incode.welcome_sdk.modules.GovernmentValidation;
import com.incode.welcome_sdk.modules.IdScan;
import com.incode.welcome_sdk.modules.ProcessId;
import com.incode.welcome_sdk.modules.SelfieScan;
import com.incode.welcome_sdk.modules.Phone;
import com.incode.welcome_sdk.modules.VideoSelfie;
import com.incode.welcome_sdk.CameraFacing;
import com.incode.welcome_sdk.modules.MachineLearningConsent;
import com.incode.welcome_sdk.modules.UserConsent;
import com.incode.welcome_sdk.modules.exceptions.ModuleConfigurationException;
import com.incode.welcome_sdk.ui.camera.id_validation.base.DocumentType;
import com.incode.welcome_sdk.modules.GlobalWatchlist;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class OnboardingConfigFactory {
    public static SessionConfig getSessionConfigByMap(HashMap<?, ?> configuration) {
        SessionConfig.Builder configBuilder = new SessionConfig.Builder();

        if (configuration == null) {
            return configBuilder.build();
        }

        String userRegion = (String) configuration.get("userRegion");
        Log.d("inc", "setting userRegion " + userRegion);
        configBuilder.setRegionIsoCode(userRegion != null ? userRegion : "ALL");

        String conferenceQueue = (String) configuration.get("queue");
        if (conferenceQueue != null) {
            Log.d("inc", "setting queue " + conferenceQueue);
            configBuilder.setQueueName(conferenceQueue);
        }

        String configurationId = (String) configuration.get("configurationId");
        if (configurationId != null) {
            Log.d("inc", "setting configurationId " + configurationId);
            configBuilder.setConfigurationId(configurationId);
        }

        List<?> validationModuleStrings = (List<?>) configuration.get("onboardingValidationModules");
        if (validationModuleStrings != null) {
            Log.d("inc", "setting validationModuleStrings");
            configBuilder.setValidationModuleList(TypeHelper.getValidationModulesFromArray(validationModuleStrings));
        }

        HashMap<?, ?> customFields = (HashMap<?, ?>) configuration.get("customFields");
        if (customFields != null) {
            HashMap<String, String> stringCustomFields = mapToString(customFields);
            Log.d("inc", "setting stringCustomFields " + stringCustomFields);
            configBuilder.setCustomFields(stringCustomFields);
        }

        String token = (String) configuration.get("token");
        if (token != null) {
            Log.d("inc", "setting token " + token);
            configBuilder.setExternalToken(token);
        }

        String interviewId = (String) configuration.get("interviewId");
        if (interviewId != null) {
            Log.d("inc", "setting interviewId " + interviewId);
            configBuilder.setInterviewId(interviewId);
        }

        String externalId = (String) configuration.get("externalId");
        if (externalId != null) {
            Log.d("inc", "setting externalId " + externalId);
            configBuilder.setExternalId(externalId);
        }

        return configBuilder.build();
    }

    public static FlowConfig getFlowConfigByMap(HashMap<?, ?> configuration, String flowTag, HashMap<?, ?> recordSessionConfig)
            throws ModuleConfigurationException {
        FlowConfig.Builder configBuilder = new FlowConfig.Builder();

        if (configuration == null) {
            return configBuilder.build();
        }

        if (recordSessionConfig != null) {
            Boolean recordSession = (Boolean) recordSessionConfig.get("recordSession");
            Boolean forcePermission = (Boolean) recordSessionConfig.get("forcePermission");
            if (recordSession != null && recordSession) {
                configBuilder.setRecordSession(forcePermission != null ? forcePermission : false);
            }
        }

        ArrayList<?> modules = (ArrayList<?>) configuration.get("modules");
        if (modules == null) {
            modules = new ArrayList<>();
        }

        if (flowTag != null) {
            configBuilder.setFlowTag(flowTag);
        }

        for (int i = 0; i < modules.size(); i++) {
            HashMap<?, ?> module = (HashMap<?, ?>) modules.get(i);
            String name = (String) module.get("name");
            Boolean showTutorials = (Boolean) module.get("showTutorials");
            String idCategory = (String) module.get("idCategory");
            if (idCategory != null) {
                if ("primary".equals(idCategory)) {
                    idCategory = "FIRST";
                } else {
                    idCategory = "SECOND";
                }
            }

            if (name == null) {
                name = "";
            }
            switch (name) {
                case ModuleNames.FACE_MATCH:
                    FaceMatch.Builder fmBuilder = new FaceMatch.Builder();
                    if (idCategory != null) {
                        fmBuilder.setIdCategory(IdCategory.valueOf(idCategory));
                    }
                    configBuilder.addFaceMatch(fmBuilder.build());
                    break;
                case ModuleNames.ID_SCAN:
                    String idType = (String) module.get("idType");
                    IdScan.Builder idScanBuilder = new IdScan.Builder();

                    if (idType != null)
                        idScanBuilder.setIdType(IdScan.IdType.valueOf(idType.toUpperCase()));
                    if (idCategory != null) {
                        idScanBuilder.setIdCategory(IdCategory.valueOf(idCategory));
                    }
                    if (showTutorials != null)
                        idScanBuilder.setShowIdTutorials(showTutorials);

                    String scanStepString = (String) module.get("scanStep");
                    if (scanStepString == null) {
                        scanStepString = "both";
                    }

                    if (!scanStepString.equals("both")) {
                        idScanBuilder.setScanStep(
                                scanStepString.equals("front") ? IdScan.ScanStep.FRONT : IdScan.ScanStep.BACK);
                    }
                    configBuilder.addID(idScanBuilder.build());

                    if (scanStepString.equals("both")) {
                        ProcessId.Builder processBuilder = new ProcessId.Builder();
                        if (idCategory != null) {
                            processBuilder.setIdCategory(IdCategory.valueOf(idCategory));
                        }
                        configBuilder.addProcessId(processBuilder.build());
                    }
                    break;
                case ModuleNames.SELFIE_SCAN:
                    SelfieScan.Builder builder2 = new SelfieScan.Builder();
                    if (showTutorials != null)
                        builder2.setShowTutorials(showTutorials);
                    configBuilder.addSelfieScan(builder2.build());
                    break;
                case ModuleNames.QR_SCAN:
                    configBuilder.addQRScan(showTutorials != null ? showTutorials : true);
                    break;
                case ModuleNames.GLOBAL_WATCHLIST:
                    configBuilder.addGlobalWatchlist();
                    break;
                case ModuleNames.GEOLOCATION:
                    configBuilder.addGeolocation();
                    break;
                case ModuleNames.PHONE:
                    Phone.Builder phoneBuilder = new Phone.Builder();
                    Integer defaultRegionPrefix = (Integer) module.get("defaultRegionPrefix");
                    if (defaultRegionPrefix != null) {
                        phoneBuilder.setDefaultRegionPrefix(defaultRegionPrefix);
                    }
                    configBuilder.addPhone(phoneBuilder.build());
                    break;
                case ModuleNames.VIDEO_SELFIE:
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                        VideoSelfie.Builder vsBuilder = new VideoSelfie.Builder();
                        if (showTutorials != null) {
                            vsBuilder.setShowTutorials(showTutorials);
                        }

                        Boolean selfieLivenessCheck = (Boolean) module.get("selfieLivenessCheck");
                        if (selfieLivenessCheck != null) {
                            vsBuilder.setLivenessEnabled(selfieLivenessCheck);
                        }

                        String selfieScanModeString = (String) module.get("selfieScanMode");
                        if (selfieScanModeString != null) {
                            VideoSelfie.SelfieMode selfieScanMode = "faceMatch".equals(selfieScanModeString) ? VideoSelfie.SelfieMode.FACE_MATCH
                                    : VideoSelfie.SelfieMode.SELFIE_MATCH;
                            vsBuilder.setSelfieMode(selfieScanMode);
                        }

                        String idScanCameraFacingString = (String) module.get("idScanCameraFacing");
                        if (idScanCameraFacingString != null) {
                            CameraFacing idScanCameraFacing = "front".equals(idScanCameraFacingString) ? CameraFacing.FRONT
                                    : CameraFacing.BACK;
                            vsBuilder.setIdScanCameraFacing(idScanCameraFacing);
                        }

                        Boolean showIdScan = (Boolean) module.get("showIdScan");
                        if (showIdScan != null) {
                            vsBuilder.setIdScanEnabled(showIdScan);
                        }

                        Boolean showDocumentScan = (Boolean) module.get("showDocumentScan");
                        if (showDocumentScan != null) {
                            vsBuilder.setDocumentScanEnabled(showDocumentScan);
                        }

                        Boolean showVoiceConsent = (Boolean) module.get("showVoiceConsent");
                        if (showVoiceConsent != null) {
                            vsBuilder.setVoiceConsentEnabled(showVoiceConsent);
                            vsBuilder.setRandomQuestionsEnabled(showVoiceConsent);
                        }

                        Integer voiceConsentQuestionsCount = (Integer) module.get("voiceConsentQuestionsCount");
                        if (voiceConsentQuestionsCount != null) {
                            if (voiceConsentQuestionsCount > 0) {
                                vsBuilder.setRandomQuestionsEnabled(true);
                                vsBuilder.setRandomQuestionsCount(voiceConsentQuestionsCount);
                            } else {
                                vsBuilder.setRandomQuestionsEnabled(false);
                            }
                        }

                        configBuilder.addVideoSelfie(vsBuilder.build());
                    } else {
                        Log.w("INCD", "Video selfie module not available for SDK version " + Build.VERSION.SDK_INT);
                    }
                    // TODO: what to do otherwise
                    break;
                case ModuleNames.ML_CONSENT:
                    MachineLearningConsent.Builder mlBuilder = new MachineLearningConsent.Builder();
                    String type = (String) module.get("type");
                    if (type != null) {
                        MachineLearningConsent.ConsentType consentType = type.equalsIgnoreCase("us")
                                        ? MachineLearningConsent.ConsentType.US
                                        : MachineLearningConsent.ConsentType.GDPR;
                        mlBuilder.setConsentType(consentType);
                    } else {
                        mlBuilder.setConsentType(MachineLearningConsent.ConsentType.GDPR);
                    }
                    configBuilder.addMachineLearningConsent(mlBuilder.build());
                    break;
                case ModuleNames.USER_CONSENT:
                    UserConsent.Builder userConsentBuilder =  new UserConsent.Builder();
                    String title = (String)module.get("title");
                    if (title != null) {
                        userConsentBuilder.setTitle(title);
                    }
                    String content = (String)module.get("content");
                    if (content != null) {
                        userConsentBuilder.setContent(content);
                    }
                    configBuilder.addUserConsent(userConsentBuilder.build());
                    break;
                case ModuleNames.APPROVE:
                    Boolean forceApproval = (Boolean) module.get("forceApproval");
                    if (forceApproval != null) {
                        configBuilder.addApproval(false, false, forceApproval);
                    } else {
                        configBuilder.addApproval(false, false);
                    }
                    break;
                case ModuleNames.USER_SCORE:
                    String modeName = (String) module.get("mode");
                    IncodeWelcome.IDResultsFetchMode mode = "fast".equals(modeName)
                            ? IncodeWelcome.IDResultsFetchMode.FAST
                            : IncodeWelcome.IDResultsFetchMode.ACCURATE;
                    configBuilder.addResults(mode);
                    break;
                case ModuleNames.GOVERNMENT_VALIDATION:
                    GovernmentValidation.Builder governmentValidationBuilder = new GovernmentValidation.Builder();
                    Boolean isBackgroundExecuted = (Boolean) module.get("isBackgroundExecuted");
                    if (isBackgroundExecuted != null) {
                        governmentValidationBuilder.setSkipAnimation(isBackgroundExecuted);
                    }
                    configBuilder.addGovernmentValidation(governmentValidationBuilder.build());
                    break;
                case ModuleNames.ANTIFRAUD:
                    configBuilder.addAntifraud();
                    break;
                case ModuleNames.DOCUMENT_SCAN:
                    DocumentScan.Builder dsBuilder = new DocumentScan.Builder();
                    if (showTutorials != null) {
                        dsBuilder.setShowTutorials(showTutorials);
                    }
                    Boolean showDocumentProviderOptions = (Boolean) module.get("showDocumentProviderOptions");
                    if (showDocumentProviderOptions != null) {
                        dsBuilder.setShowDocumentProviderOptions(showDocumentProviderOptions);
                    }
                    String documentTypeString = (String) module.get("documentType");
                    if (documentTypeString != null) {
                        DocumentType documentType;
                        switch (documentTypeString) {
                            case "paymentProof":
                                documentType = DocumentType.PAYMENT_PROOF;
                                break;
                            case "medicalDoc":
                                documentType = DocumentType.MEDICAL_DOC;
                                break;
                            case "otherDocument1":
                                documentType = DocumentType.OTHER_DOCUMENT_1;
                                break;
                            case "otherDocument2":
                                documentType = DocumentType.OTHER_DOCUMENT_2;
                                break;
                            case "addressStatement":
                            default:
                                documentType = DocumentType.ADDRESS_STATEMENT;
                                break;
                        }
                        dsBuilder.setDocumentType(documentType);
                    }
                    configBuilder.addDocumentScan(dsBuilder.build());
                    break;
                case ModuleNames.SIGNATURE:
                    configBuilder.addSignature();
                    break;
                case ModuleNames.CAPTCHA:
                    configBuilder.addCaptcha();
                    break;
                case ModuleNames.EMAIL:
                    configBuilder.addEmail();
                    break;
                case ModuleNames.FULL_NAME:
                    configBuilder.addName();
                    break;
                case ModuleNames.CURP_VALIDATION:
                    configBuilder.addCurpValidation();
                    break;
                case ModuleNames.PROCESS_ID:
                    ProcessId.Builder processIdBuilder = new ProcessId.Builder();
                    if (idCategory != null) {
                        processIdBuilder.setIdCategory(IdCategory.valueOf(idCategory));
                    }
                    Boolean enableIdSummaryScreen = (Boolean) module.get("enableIdSummaryScreen");
                    if (enableIdSummaryScreen != null) {
                        processIdBuilder.setEnableIdSummaryScreen(enableIdSummaryScreen);
                    }
                    configBuilder.addProcessId(processIdBuilder.build());
            }
        }
        return configBuilder.build();
    }

    private static HashMap<String, String> mapToString(HashMap<?, ?> map) {
        HashMap<String, String> newMap = new HashMap<>();
        for (Map.Entry<?, ?> entry : map.entrySet()) {
            String key = entry.getKey().toString();
            String value = entry.getValue().toString();
            newMap.put(key, value);
        }
        return newMap;
    }
}
