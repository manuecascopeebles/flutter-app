package com.incode.onboarding_flutter_wrapper;

import android.util.Log;

import com.incode.welcome_sdk.data.remote.beans.FacialRecognitionResults;
import com.incode.welcome_sdk.data.remote.beans.IdVerificationResults;
import com.incode.welcome_sdk.data.remote.beans.LivenessCheckResults;
import com.incode.welcome_sdk.results.UserScoreResult;

import org.json.JSONObject;

import java.util.HashMap;

public class UserScoreMapper {
    public HashMap<String, Object> map(UserScoreResult userScoreResult) {
        final HashMap<String, Object> map = new HashMap<>();

        String jsonDataString = new JSONObject(userScoreResult.extendedUserScoreJsonData).toString();
        map.put("extendedUserScoreJsonData", jsonDataString);


        final HashMap<String, Object> overall = new HashMap<>();
        overall.put("value", userScoreResult.overallScore);
        overall.put("status", userScoreResult.overallStatus.name().toLowerCase());
        map.put("overall", overall);

        FacialRecognitionResults facialRecognitionResults = userScoreResult.facialRecognitionResults;
        final HashMap<String, Object> faceRecognition = new HashMap<>();
        String faceRecognitionResult = "";
        String faceRecognitionStatus = "";
        if (facialRecognitionResults != null) {
            faceRecognitionResult = facialRecognitionResults.getOverallScore();
            if (facialRecognitionResults.getOverallScoreAndResultStatus().second != null) {
                faceRecognitionStatus = facialRecognitionResults.getOverallScoreAndResultStatus().second.name().toLowerCase();
            }
            faceRecognition.put("value", faceRecognitionResult);
            faceRecognition.put("status", faceRecognitionStatus);
            map.put("faceRecognition", faceRecognition);
        }


        final HashMap<String, Object> idValidation = new HashMap<>();
        IdVerificationResults idValidationResults = userScoreResult.idVerificationResults;
        String idValidationResult = "";
        String idValidationStatus = "";
        if (idValidationResults != null) {
            idValidationResult = idValidationResults.getOverallScore();
            if (idValidationResults.getOverallScoreAndResultStatus().second != null) {
                idValidationStatus = idValidationResults.getOverallScoreAndResultStatus().second.name().toLowerCase();
            }

            idValidation.put("value", idValidationResult);
            idValidation.put("status", idValidationStatus);
            map.put("idValidation", idValidation);
        }


        final HashMap<String, Object> liveness = new HashMap<>();
        LivenessCheckResults livenessCheckResults = userScoreResult.livenessCheckResults;
        String livenessResult = "";
        String livenessStatus = "";
        if (livenessCheckResults != null) {
            livenessResult = livenessCheckResults.getOverallScore();
            if (livenessCheckResults.getOverallScoreAndResultStatus().second != null) {
                livenessStatus = livenessCheckResults.getOverallScoreAndResultStatus().second.name().toLowerCase();
            }
            liveness.put("value", livenessResult);
            liveness.put("status", livenessStatus);
            map.put("liveness", liveness);
        }

        return map;
    }
}