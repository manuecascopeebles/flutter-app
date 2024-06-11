package com.incode.onboarding_flutter_wrapper;

import android.text.TextUtils;
import android.util.Log;

import com.incode.welcome_sdk.OnboardingValidationModule;
import com.incode.welcome_sdk.results.FaceLoginResult;
import com.incode.welcome_sdk.results.SelfieScanResult;

import java.io.ByteArrayOutputStream;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class TypeHelper {
    public static List<OnboardingValidationModule> getValidationModulesFromArray(List<?> moduleStrings) {

        List<OnboardingValidationModule> sessionModules = new ArrayList<>();

        if (moduleStrings != null) {
            for (Object moduleName : moduleStrings) {
                if (moduleName != null)
                    sessionModules.add(OnboardingValidationModule.valueOf((String) moduleName));
            }
        }
        return sessionModules;
    }

   public static byte[] image(String imagePath) {
        if (TextUtils.isEmpty(imagePath)) {
            return null;
        }
        try {
            FileInputStream fileInputStream = new FileInputStream(imagePath);
            ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
            byte[] bytes = new byte[8192];
            int bytesRead;

            while ((bytesRead = fileInputStream.read(bytes)) != -1) {
                byteArrayOutputStream.write(bytes, 0, bytesRead);
            }

            return byteArrayOutputStream.toByteArray();

        } catch (FileNotFoundException e) {
            Log.e("INCD", "images packing error: ", e);
        } catch (IOException e) {
            Log.e("INCD", "images packing error: ", e);
        }
        return null;
    }

    public static HashMap<String, Object> getFaceLoginResultMap(SelfieScanResult selfieScanResult) {
        final HashMap<String, Object> data = new HashMap<>();

        if (selfieScanResult.isFaceMatched != null) {
            data.put("faceMatched", selfieScanResult.isFaceMatched);
        }
        if (selfieScanResult.isSpoofAttempt != null) {
            data.put("spoofAttempt", selfieScanResult.isSpoofAttempt);
        }

        data.put("image", image(selfieScanResult.fullFrameSelfieImgPath));

        HashMap<String, Object> base64Images = new HashMap<String, Object>() {{
            put("selfieBase64", selfieScanResult.selfieBase64);
            put("selfieEncryptedBase64", selfieScanResult.selfieEncryptedBase64);
        }};
        data.put("base64Images", base64Images);

        FaceLoginResult faceLoginResult = selfieScanResult.faceLoginResult;
        if (faceLoginResult != null) {
            if (faceLoginResult.customerUUID != null) {
                data.put("customerUUID", faceLoginResult.customerUUID);
            }
            if (faceLoginResult.interviewId != null) {
                data.put("interviewId", faceLoginResult.interviewId);
            }
            if (faceLoginResult.interviewToken != null) {
                data.put("interviewToken", faceLoginResult.interviewToken);
            }
            if (faceLoginResult.transactionId != null) {
                data.put("transactionId", faceLoginResult.transactionId);
            }
            if (faceLoginResult.token != null) {
                data.put("token", faceLoginResult.token);
            }
        }
        return data;
    }
}