package com.incode.onboarding_flutter_wrapper;

import android.app.Activity;
import android.util.Log;

import com.incode.welcome_sdk.IdCategory;
import com.incode.welcome_sdk.IncodeWelcome;
import com.incode.welcome_sdk.data.remote.beans.ResponseMedicalDoc;
import com.incode.welcome_sdk.modules.IdScan;
import com.incode.welcome_sdk.results.ApproveResult;
import com.incode.welcome_sdk.results.CaptchaResult;
import com.incode.welcome_sdk.results.CurpValidationResult;
import com.incode.welcome_sdk.results.DocumentValidationResult;
import com.incode.welcome_sdk.results.FaceMatchResult;
import com.incode.welcome_sdk.results.GeolocationResult;
import com.incode.welcome_sdk.results.IdProcessResult;
import com.incode.welcome_sdk.results.IdScanResult;
import com.incode.welcome_sdk.results.NameResult;
import com.incode.welcome_sdk.results.PhoneNumberResult;
import com.incode.welcome_sdk.results.ResultCode;
import com.incode.welcome_sdk.results.SelfieScanResult;
import com.incode.welcome_sdk.results.SignatureFormResult;
import com.incode.welcome_sdk.results.UserScoreResult;
import com.incode.welcome_sdk.results.VideoSelfieResult;
import com.incode.welcome_sdk.results.AntifraudResult;
import com.incode.welcome_sdk.results.MachineLearningConsentResult;
import com.incode.welcome_sdk.results.UserConsentResult;
import com.incode.welcome_sdk.results.QRScanResult;
import com.incode.welcome_sdk.results.GlobalWatchlistResult;
import com.incode.welcome_sdk.results.EmailAddressResult;
import com.incode.welcome_sdk.ui.camera.id_validation.base.DocumentType;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.EventChannel;

public class FlutterOnboardingListener extends IncodeWelcome.OnboardingListener {
    // final double SPOOF_THRESHOLD = 0.0;
    final double FACE_MATCH_THRESHOLD = 0.0;

    private final EventChannel.EventSink eventSink;
    private final Activity activity;

    public FlutterOnboardingListener(EventChannel.EventSink eventSink, Activity activity) {
        this.eventSink = eventSink;
        this.activity = activity;
    }

    @Override
    public void onSuccess() {
        eventSink.endOfStream();
    }

    @Override
    public void onError(Throwable error) {
        eventSink.error("onError", error.getMessage(), error.toString());
    }

    @Override
    public void onIdFrontCompleted(IdScanResult frontIdScanResult) {
        parseIdScanResult("onIdFrontCompleted", frontIdScanResult, eventSink);
    }

    @Override
    public void onIdBackCompleted(IdScanResult backIdScanResult) {
        parseIdScanResult("onIdBackCompleted", backIdScanResult, eventSink);
    }

    @Override
    public void onIdProcessed(IdProcessResult idProcessResult) {
        final HashMap<String, Object> data = new HashMap<>();
        final HashMap<String, Object> response = new HashMap<>();

        final IncodeWelcome.OCRData ocrData = idProcessResult.getOcrData();
        if (ocrData != null) {
            final Map<String, Object> extendedOcrJsonData = ocrData.getExtendedOcrJsonData();
            HashMap<String, Object> wrappedExtendedOcrJsonData = new HashMap<String, Object>() {
                {
                    put("ocrData", extendedOcrJsonData);
                }
            };

            if (extendedOcrJsonData.get("extendedData") != null) {
                try {
                    String dummyDataJSON = new JSONObject(
                            "{\"ocrData\":{\"curp\":\"MXMO860324HDFRDM05\",\"cic\":\"153654132\",\"registrationDate\":2004,\"numeroEmisionCredencial\":\"01\",\"birthDate\":512006400000,\"issueDate\":2012,\"claveDeElector\":\"MRMDOM86032409H800\",\"addressFields\":{\"colony\":\"COL JORGE NEGRETE\",\"street\":\"C MARIO MORENO MZ 201E LT 4\",\"city\":\"GUSTAVO A. MADERO\",\"state\":\"D.F.\",\"postalCode\":\"07280\"},\"fullNameMrz\":\"Omar Martinez Madrid\",\"expirationDate\":2022,\"address\":\"C MARIO MORENO MZ 201E LT 4 COL JORGE NEGRETE 07280 GUSTAVO A. MADERO ,D.F.\",\"ocr\":\"3145897456321\",\"gender\":\"M\",\"name\":{\"firstName\":\"Omar\",\"paternalLastName\":\"Martinez\",\"fullName\":\"Omar Martinez Madrid\",\"maternalLastName\":\"Madrid\"}}}")
                            .toString();
                    data.put("ocrData", dummyDataJSON);
                } catch (JSONException e) {
                    Log.w("INCD", "Couldn't parse extendedOCR: " + e.getMessage());
                }
            } else {
                String ocrDataString = new JSONObject(wrappedExtendedOcrJsonData).toString();
                data.put("ocrData", ocrDataString);
            }
        }

        response.put("code", "onIdProcessed");
        response.put("data", data);
        eventSink.success(response);
    }

    @Override
    public void onSelfieScanCompleted(final SelfieScanResult selfieScanResult) {
        if (selfieScanResult == null) {
            return;
        }
        final HashMap<String, Object> data = new HashMap<>();
        final HashMap<String, Object> response = new HashMap<>();

        if (selfieScanResult.isSpoofAttempt != null) {
            data.put("spoofAttempt", selfieScanResult.isSpoofAttempt);
        }
        data.put("image", TypeHelper.image(selfieScanResult.fullFrameSelfieImgPath));

        HashMap<String, Object> base64Images = new HashMap<String, Object>() {
            {
                put("selfieBase64", selfieScanResult.selfieBase64);
                put("selfieEncryptedBase64", selfieScanResult.selfieEncryptedBase64);
            }
        };
        data.put("base64Images", base64Images);

        response.put("code", "onSelfieScanCompleted");
        response.put("data", data);
        eventSink.success(response);
    }

    @Override
    public void onFaceMatchCompleted(FaceMatchResult faceMatchResult) {
        final HashMap<String, Object> data = new HashMap<>();
        final HashMap<String, Object> response = new HashMap<>();

        String idCategory = "primary";
        if (!faceMatchResult.idCategories.isEmpty()) {
            IdCategory firstIdCategory = faceMatchResult.idCategories.get(0);
            idCategory = firstIdCategory.equals(IdCategory.FIRST) ? "primary" : "secondary";
        }

        data.put("faceMatched", faceMatchResult.isFaceMatched);
        data.put("idCategory", idCategory);
        data.put("existingUser", faceMatchResult.isExistingUser);
        data.put("existingInterviewId", faceMatchResult.existingInterviewId);
        data.put("nameMatched", faceMatchResult.isNameMatched);

        response.put("code", "onFaceMatchCompleted");
        response.put("data", data);
        eventSink.success(response);
    }

    @Override
    public void onGeolocationUnavailable(Throwable error) {
        eventSink.error("onGeolocationUnavailable", error.getMessage(), "permissionsDenied");
    }

    @Override
    public void onGeolocationFetched(GeolocationResult geolocationResult) {
        final HashMap<String, Object> data = new HashMap<>();
        final HashMap<String, Object> response = new HashMap<>();

        addAllAddressFields(data, geolocationResult.addressFields);

        response.put("code", "onGeolocationCompleted");
        response.put("data", data);
        eventSink.success(response);
    }

    @Override
    public void onAddPhoneCompleted(PhoneNumberResult phoneNumberResult) {
        final HashMap<String, Object> data = new HashMap<>();
        final HashMap<String, Object> response = new HashMap<>();

        data.put("phone", phoneNumberResult.phone);
        data.put("resultCode", phoneNumberResult.resultCode.name());

        response.put("code", "onAddPhoneNumberCompleted");
        response.put("data", data);
        eventSink.success(response);
    }

    @Override
    public void onVideoRecorded(VideoSelfieResult videoSelfieResult) {
        final HashMap<String, Object> data = new HashMap<>();
        final HashMap<String, Object> response = new HashMap<>();

        data.put("success", true);

        response.put("code", "onVideoSelfieCompleted");
        response.put("data", data);
        eventSink.success(response);
    }

    @Override
    public void onOnboardingSessionCreated(String token, String interviewId, String region) {
        final HashMap<String, Object> data = new HashMap<>();
        final HashMap<String, Object> response = new HashMap<>();

        data.put("interviewId", interviewId);
        data.put("regionCode", region);
        data.put("token", token);

        response.put("code", "onOnboardingSessionCreated");
        response.put("data", data);

        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                eventSink.success(response);
            }
        });
    }

    @Override
    public void onApproveCompleted(ApproveResult approveResult) {
        final HashMap<String, Object> data = new HashMap<>();
        final HashMap<String, Object> response = new HashMap<>();

        boolean success = approveResult.isSuccess;

        data.put("success", success);
        data.put("uuid", approveResult.uuid);
        data.put("customerToken", approveResult.token);

        response.put("code", "onApproveCompleted");
        response.put("data", data);
        eventSink.success(response);
    }

    @Override
    public void onResultsShown(UserScoreResult userScoreResult) {
        final HashMap<String, Object> response = new HashMap<>();

        response.put("code", "onUserScoreFetched");
        response.put("data", new UserScoreMapper().map(userScoreResult));
        eventSink.success(response);
    }

    @Override
    public void onUserCancelled() {
        final HashMap<String, Object> response = new HashMap<>();
        response.put("code", "onUserCancelled");
        eventSink.success(response);
    }

    @Override
    public void onGovernmentValidationCompleted(boolean success) {
        final HashMap<String, Object> response = new HashMap<>();
        final HashMap<String, Object> data = new HashMap<>();

        data.put("success", success);
        response.put("code", "onGovernmentValidationCompleted");
        response.put("data", data);
        eventSink.success(response);
    }

    @Override
    public void onAntifraudCompleted(AntifraudResult result) {
        final HashMap<String, Object> response = new HashMap<>();
        final HashMap<String, Object> data = new HashMap<>();

        data.put("success", result.result);
        response.put("code", "onAntifraudCompleted");
        response.put("data", data);
        eventSink.success(response);
    }

    @Override
    public void onOnboardingSectionCompleted(String flowTag) {
        final HashMap<String, Object> response = new HashMap<>();
        final HashMap<String, Object> data = new HashMap<>();

        data.put("flowTag", flowTag);
        response.put("code", "onOnboardingSectionCompleted");
        response.put("data", data);
        eventSink.success(response);
    }

    @Override
    public void onDocumentValidationCompleted(DocumentType documentType,
            DocumentValidationResult documentValidationResult) {
        final HashMap<String, Object> response = new HashMap<>();
        final HashMap<String, Object> data = new HashMap<>();
        final HashMap<String, Object> documentData = new HashMap<>();

        data.put("image", TypeHelper.image(documentValidationResult.documentPath));

        String documentTypeAsString;
        switch (documentType) {
            case MEDICAL_DOC:
                documentTypeAsString = "medicalDoc";
                break;
            case PAYMENT_PROOF:
                documentTypeAsString = "paymentProof";
                break;
            case OTHER_DOCUMENT_1:
                documentTypeAsString = "otherDocument1";
                break;
            case OTHER_DOCUMENT_2:
                documentTypeAsString = "otherDocument2";
                break;
            default:
                documentTypeAsString = "addressStatement";
        }

        data.put("documentType", documentTypeAsString);
        IncodeWelcome.AddressFields fields = documentValidationResult.addressFields;
        if (fields != null) {
            documentData.put("city", fields.getCity());
            documentData.put("colony", fields.getColony());
            documentData.put("state", fields.getState());
            documentData.put("postalCode", fields.getPostalCode());
            documentData.put("street", fields.getStreet());

            data.put("address", documentData);
        }

        ResponseMedicalDoc insuranceCardData = documentValidationResult.getMedicalDocData();
        if (insuranceCardData != null) {
            data.put("ocrData", insuranceCardData.getRawData());
        }

        response.put("data", data);
        response.put("code", "onDocumentScanCompleted");
        eventSink.success(response);
        super.onDocumentValidationCompleted(documentType, documentValidationResult);
    }

    @Override
    public void onSignatureCollected(SignatureFormResult signatureFormResult) {
        final HashMap<String, Object> response = new HashMap<>();
        final HashMap<String, Object> data = new HashMap<>();

        data.put("signature", TypeHelper.image(signatureFormResult.signaturePath));
        response.put("code", "onSignatureCollected");
        response.put("data", data);
        eventSink.success(response);
    }

    @Override
    public void onCaptchaCollected(CaptchaResult captchaResult) {
        final HashMap<String, Object> response = new HashMap<>();
        final HashMap<String, Object> data = new HashMap<>();

        data.put("captcha", captchaResult.captchaResponse);
        response.put("code", "onCaptchaCompleted");
        response.put("data", data);
        eventSink.success(response);
    }

    @Override
    public void onCurpValidationCompleted(CurpValidationResult curpValidationResult) {
        final HashMap<String, Object> response = new HashMap<>();
        final HashMap<String, Object> data = new HashMap<>();

        data.put("curp", curpValidationResult.curp);
        data.put("valid", curpValidationResult.isValid);
        data.put("data", curpValidationResult.data);
        response.put("code", "onCURPValidationCompleted");
        response.put("data", data);
        eventSink.success(response);
    }

    @Override
    public void onAddEmailCompleted(EmailAddressResult emailAddressResult) {
        final HashMap<String, Object> response = new HashMap<>();
        final HashMap<String, Object> data = new HashMap<>();

        data.put("email", emailAddressResult.email);
        response.put("code", "onAddEmailCompleted");
        response.put("data", data);
        eventSink.success(response);
    }

    @Override
    public void onAddNameCompleted(NameResult nameResult) {
        final HashMap<String, Object> response = new HashMap<>();
        final HashMap<String, Object> data = new HashMap<>();

        data.put("name", nameResult.name);
        response.put("code", "onAddFullNameCompleted");
        response.put("data", data);
        eventSink.success(response);
    }

    @Override
    public void onMachineLearningConsentCompleted(MachineLearningConsentResult result) {
        final HashMap<String, Object> data = new HashMap<>();
        final HashMap<String, Object> response = new HashMap<>();

        boolean success = result.isSuccess;

        data.put("success", success);

        response.put("code", "onMLConsentCompleted");
        response.put("data", data);
        eventSink.success(response);
    }

    @Override
    public void onUserConsentCompleted() {
        final HashMap<String, Object> data = new HashMap<>();
        final HashMap<String, Object> response = new HashMap<>();

        data.put("success", true);

        response.put("code", "onUserConsentCompleted");
        response.put("data", data);
        eventSink.success(response);
    }

    @Override
    public void onQRScanCompleted(QRScanResult qrScanResult) {
        final HashMap<String, Object> data = new HashMap<>();
        final HashMap<String, Object> response = new HashMap<>();

        data.put("success", qrScanResult.resultCode == ResultCode.SUCCESS);

        response.put("code", "onQRScanCompleted");
        response.put("data", data);
        eventSink.success(response);

    }

    @Override
    public void onGlobalWatchlistProcessed(GlobalWatchlistResult result) {
       final HashMap<String, Object> data = new HashMap<>();
       final HashMap<String, Object> response = new HashMap<>();

       data.put("success", result.resultCode == ResultCode.SUCCESS);

       response.put("code", "onGlobalWatchlistCompleted");
       response.put("data", data);
       eventSink.success(response);
   }

    private static void addAllAddressFields(HashMap<String, Object> resultsMap,
            IncodeWelcome.AddressFields addressFields) {
        if (addressFields != null) {
            resultsMap.put("city", addressFields.getCity());
            resultsMap.put("colony", addressFields.getColony());
            resultsMap.put("postalCode", addressFields.getPostalCode());
            resultsMap.put("state", addressFields.getState());
            resultsMap.put("street", addressFields.getStreet());
        }
    }

    private static void parseIdScanResult(String code, IdScanResult result, EventChannel.EventSink eventSink) {
        final HashMap<String, Object> data = new HashMap<>();
        final HashMap<String, Object> response = new HashMap<>();

        IdScan.IdType chosenIdType = result.chosenIdType;
        IdCategory idCategory = result.idCategory;
        Integer scanStatus = result.scanStatus;

        data.put("image", TypeHelper.image(result.idImagePath));
        data.put("base64Image", result.idImageBase64);
        data.put("croppedFace", TypeHelper.image(result.croppedFacePath));
        data.put("chosenIdType", chosenIdType != null ? chosenIdType.name().toLowerCase() : null);
        data.put("classifiedIdType", result.classifiedIdType);
        data.put("idCategory",
                idCategory != null ? idCategory.equals(IdCategory.FIRST) ? "primary" : "secondary" : null);
        data.put("scanStatus", scanStatus != null ? IdValidationResultMapping.fromCode(scanStatus) : null);

        response.put("code", code);
        response.put("data", data);
        eventSink.success(response);
    }
}
