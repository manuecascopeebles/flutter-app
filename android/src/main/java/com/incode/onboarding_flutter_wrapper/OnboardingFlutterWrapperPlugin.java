package com.incode.onboarding_flutter_wrapper;

import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.util.Log;

import androidx.annotation.NonNull;

import com.incode.welcome_sdk.CommonConfig;
import com.incode.welcome_sdk.FlowConfig;
import com.incode.welcome_sdk.IncodeWelcome;
import com.incode.welcome_sdk.SdkMode;
import com.incode.welcome_sdk.SessionConfig;
import com.incode.welcome_sdk.data.local.FaceInfo;
import com.incode.welcome_sdk.listeners.AddNOM151ArchiveListener;
import com.incode.welcome_sdk.listeners.FaceInfoListener;
import com.incode.welcome_sdk.listeners.FinishOnboardingListener;
import com.incode.welcome_sdk.listeners.GetUserOCRDataListener;
import com.incode.welcome_sdk.listeners.GetUserScoreListener;
import com.incode.welcome_sdk.listeners.OnboardingSessionListener;
import com.incode.welcome_sdk.listeners.SelfieScanListener;
import com.incode.welcome_sdk.modules.SelfieScan;
import com.incode.welcome_sdk.modules.exceptions.ModuleConfigurationException;
import com.incode.welcome_sdk.results.AddNOM151ArchiveResult;
import com.incode.welcome_sdk.results.IdResults;
import com.incode.welcome_sdk.results.SelfieScanResult;
import com.incode.welcome_sdk.results.UserScoreResult;
import com.incode.welcome_sdk.modules.Modules;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import timber.log.Timber;

import java.util.Locale;


/**
 * OnboardingFlutterWrapperPlugin
 */
public class OnboardingFlutterWrapperPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware, EventChannel.StreamHandler {
    /// The MethodChannel that will the communication between Flutter and native
    /// Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine
    /// and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel methodChannel;
    private Context context;
    private Activity activity;
    private EventChannel eventChannel;
    private EventChannel.EventSink eventSink;

    private CommonConfig commonConfig;

    private Locale currentLocale = Locale.getDefault();

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        methodChannel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "onboarding_flutter_wrapper/method");
        methodChannel.setMethodCallHandler(this);

        eventChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), "onboarding_flutter_wrapper/event");
        eventChannel.setStreamHandler(this);

        context = flutterPluginBinding.getApplicationContext();
    }

    private CommonConfig.Builder getCommonConfigBuilder() {
        if (commonConfig == null) {
          commonConfig = new CommonConfig.Builder().build(); // Just create empty CommonConfig
        }
    
        return CommonConfig.Builder.from(commonConfig);
    }
    
    private void setCommonConfig(CommonConfig config) {
        commonConfig = config;
        IncodeWelcome.getInstance().setCommonConfig(commonConfig);
    }
    
    private static Map<String, String> getSupportedLanguages() {
        Map<String, String> supportedLanguages = new HashMap<>();
        supportedLanguages.put("en", "en_US");
        supportedLanguages.put("es", "es_ES");
        supportedLanguages.put("pt", "pt_PT");
        return supportedLanguages;
    }
    
    private static Map<String, String> getSupportedLanguagesInverse() {
        Map<String, String> supportedLanguages = new HashMap<>();
        supportedLanguages.put("en_US", "en");
        supportedLanguages.put("es_ES", "es");
        supportedLanguages.put("pt_PT", "pt");
        return supportedLanguages;
    }


    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull final Result result) {
        HashMap<?, ?> arguments = (HashMap<?, ?>) call.arguments;
        if (arguments == null) {
            arguments = new HashMap<>();
        }

        switch (call.method) {
            case "initialize":
                String errorCode = "";
                String errorMsg = "";

                try {

                    String apiUrl = (String) arguments.get("apiUrl");
                    String apiKey = (String) arguments.get("apiKey");
                    Boolean loggingEnabled = (Boolean) arguments.get("loggingEnabled");
                    Boolean testMode = (Boolean) arguments.get("testMode");
                    Boolean waitForTutorials = (Boolean) arguments.get("waitForTutorials");
                    Boolean externalAnalyticsEnabled = (Boolean) arguments.get("externalAnalyticsEnabled");
                    Boolean externalScreenshotsEnabled = (Boolean) arguments.get("externalScreenshotsEnabled");
                    Boolean disableEmulatorDetection = (Boolean) arguments.get("disableEmulatorDetection");
                    Boolean disableRootDetection = (Boolean) arguments.get("disableRootDetection");
                    Boolean disableHookDetection = (Boolean) arguments.get("disableHookDetection");

                    IncodeWelcome.Builder builder;
                    if (apiUrl != null && apiKey != null) {
                        builder = new IncodeWelcome.Builder((Application) context, apiUrl, apiKey);
                    } else if (apiUrl != null) {
                        builder = new IncodeWelcome.Builder((Application) context, apiUrl);
                    } else {
                        builder = new IncodeWelcome.Builder((Application) context);
                    }

                    if (loggingEnabled != null) {
                        builder.setLoggingEnabled(loggingEnabled);
                    }
                    if (testMode != null) {
                        builder.setTestModeEnabled(testMode);
                    }

                    if (externalAnalyticsEnabled != null) {
                        builder.setExternalAnalyticsEnabled(externalAnalyticsEnabled);
                    }

                    if (externalScreenshotsEnabled != null) {
                        builder.setExternalScreenshotsEnabled(externalScreenshotsEnabled);
                    }

                    if (disableEmulatorDetection != null) {
                        builder.disableEmulatorDetection(disableEmulatorDetection);
                    }

                    if (disableRootDetection != null) {
                        builder.disableRootDetection(disableRootDetection);
                    }

                    if (disableHookDetection != null) {
                        builder.disableHookCheck(disableHookDetection);
                    }

                    builder.build();

                    final HashMap<String, Object> initResponse = new HashMap<>();
                    initResponse.put("success", true);
                    result.success(initResponse);

                    Log.d("INCD", "init " + "success");

                } catch (IllegalStateException exc) {
                    errorMsg = exc.getMessage();
                    Log.d("INCD", "init " + errorMsg);

                    if ("Emulator detected. Emulators aren't supported outside of test mode!".equals(errorMsg)) {
                        errorCode = IncodeSdkInitError.SIMULATOR_DETECTED.getValue();
                    } else if ("Root access detected. Rooted devices aren't supported outside of test mode!".equals(errorMsg)) {
                        errorCode = IncodeSdkInitError.ROOT_DETECTED.getValue();
                    } else if ("Hooking framework detected. Devices with hooking frameworks aren't supported outside of test mode!"
                            .equals(errorMsg)) {
                        errorCode = IncodeSdkInitError.HOOK_DETECTED.getValue();
                    } else if ("Please disable test mode before deploying to a real device!".equals(errorMsg)) {
                        errorCode = IncodeSdkInitError.TEST_MODE_ENABLED.getValue();
                    } else {
                        errorCode = IncodeSdkInitError.UNKNOWN.getValue();
                    }

                    final HashMap<String, Object> initResponse = new HashMap<>();
                    initResponse.put("success", false);
                    initResponse.put("error", errorCode.toString());
                    result.success(initResponse);
                }
                break;
            case "startOnboarding":
                try {
                    SessionConfig sessionConfig = OnboardingConfigFactory.getSessionConfigByMap((HashMap<?, ?>) arguments.get("sessionConfig"));
                    FlowConfig flowConfig = OnboardingConfigFactory.getFlowConfigByMap((HashMap<?, ?>) arguments.get("flowConfig"), null, (HashMap<?, ?>) arguments.get("recordSessionConfig"));
                    FlutterOnboardingListener onboardingListenerV2 = new FlutterOnboardingListener(eventSink, activity);

                    IncodeWelcome.getInstance().startOnboarding(activity, sessionConfig, flowConfig, onboardingListenerV2);
                } catch (ModuleConfigurationException e) {
                    final HashMap<String, Object> response = new HashMap<>();
                    response.put("success", false);
                    response.put("error", "Config is not set up properly");
                    result.success(response);
                    return;
                }
                break;
            case "startWorkflow":
                try {
                    SessionConfig sessionConfig = OnboardingConfigFactory.getSessionConfigByMap((HashMap<?, ?>) arguments.get("sessionConfig"));
                    FlutterOnboardingListener onboardingListenerV2 = new FlutterOnboardingListener(eventSink, activity);

                    IncodeWelcome.getInstance().startWorkflow(activity, sessionConfig, onboardingListenerV2);
                } catch (Exception e) {
                    final HashMap<String, Object> response = new HashMap<>();
                    response.put("success", false);
                    response.put("error", "Config is not set up properly");
                    result.success(response);
                    return;
                }
                break;                
            case "startFlow":
                try {
                    SessionConfig sessionConfig = OnboardingConfigFactory.getSessionConfigByMap((HashMap<?, ?>) arguments.get("sessionConfig"));
                    String moduleId = (String) arguments.get("moduleId");
                    FlutterOnboardingListener onboardingListenerV2 = new FlutterOnboardingListener(eventSink, activity);

                    if (moduleId != null) {
                        Modules modules = Modules.safeValueOf(moduleId);
                        Log.d("INCD", "startFlow modules " + modules);
                        IncodeWelcome.getInstance().startFlow(activity, sessionConfig, modules, onboardingListenerV2);
                    } else {
                        Log.d("INCD", "startFlow");
                        IncodeWelcome.getInstance().startFlow(activity, sessionConfig, onboardingListenerV2);
                    }
                } catch (Exception e) {
                    final HashMap<String, Object> response = new HashMap<>();
                    response.put("success", false);
                    response.put("error", "Config is not set up properly");
                    result.success(response);
                    return;
                }
                break;      
            case "startFlowFromDeepLink":
                try {
                    String url = (String) arguments.get("url");

                    FlutterOnboardingListener onboardingListenerV2 = new FlutterOnboardingListener(eventSink, activity);

                    if (url != null) {
                        IncodeWelcome.getInstance().startFlowFromDeeplink(activity, url, onboardingListenerV2);
                    } else {
                        final HashMap<String, Object> response = new HashMap<>();
                        response.put("success", false);
                        response.put("error", "Invalid URL");
                        result.success(response);
                    }
                } catch (Exception e) {
                    final HashMap<String, Object> response = new HashMap<>();
                    response.put("success", false);
                    response.put("error", "Config is not set up properly");
                    result.success(response);
                    return;
                }
                break;                      
            case "startNewOnboardingSection":
                try {
                    String flowTag = (String) arguments.get("flowTag");
                    FlowConfig flowConfig = OnboardingConfigFactory.getFlowConfigByMap((HashMap<?, ?>) arguments.get("flowConfig"), flowTag, (HashMap<?, ?>) arguments.get("recordSessionConfig"));
                    FlutterOnboardingListener onboardingListenerV2 = new FlutterOnboardingListener(eventSink, activity);
                    IncodeWelcome.getInstance().startOnboardingSection(activity, flowConfig, onboardingListenerV2);
                } catch (ModuleConfigurationException e) {
                    final HashMap<String, Object> response = new HashMap<>();
                    response.put("success", false);
                    response.put("error", "Config is not set up properly");
                    result.success(response);
                    return;
                }
                break;
            case "finishFlow":
                IncodeWelcome.getInstance().finishOnboarding(activity, new FinishOnboardingListener() {
                    @Override
                    public void onOnboardingFinished() {
                        final HashMap<String, Object> response = new HashMap<>();
                        response.put("success", true);
                        result.success(response);
                    }

                    @Override
                    public void onError(Throwable throwable) {
                        final HashMap<String, Object> response = new HashMap<>();
                        response.put("success", false);
                        response.put("error", throwable.getMessage());
                        result.success(response);
                    }

                    @Override
                    public void onUserCancelled() {
                        final HashMap<String, Object> response = new HashMap<>();
                        response.put("success", false);
                        response.put("error", "UserCancelled");
                        result.success(response);
                    }
                });
                break;
            case "setupOnboardingSession":
                SessionConfig sessionConfig = OnboardingConfigFactory.getSessionConfigByMap((HashMap<?, ?>) arguments.get("sessionConfig"));
                OnboardingSessionListener onboardingSessionListener1 = new FlutterOnboardingSessionListener(activity, result);
                IncodeWelcome.getInstance().setupOnboardingSession(sessionConfig, onboardingSessionListener1);
                break;
            case "showCloseButton": {
                Boolean shouldShowCloseButton = (Boolean) arguments.get("allowUserToCancel");
                final HashMap<String, Object> response = new HashMap<>();
                if (shouldShowCloseButton != null) {
                    if (commonConfig == null) {
                        commonConfig = new CommonConfig.Builder().build();
                    }
                    commonConfig = CommonConfig.Builder.from(commonConfig)
                                .setShowCloseButton(true)
                                .build();
                    IncodeWelcome.getInstance().setCommonConfig(commonConfig);
                    response.put("success", true);
                } else {
                    response.put("success", false);
                }
                result.success(response);
                break;
            }
            case "setLocalizationLanguage": {
                final HashMap<String, Object> response = new HashMap<>();

                String language = (String) arguments.get("language");

                String outputLanguage = getSupportedLanguages().get(language);
                if (outputLanguage == null) {
                  outputLanguage = "en_US";
                }

                Log.d("INCD", "setLocalizationLanguage " + outputLanguage);
            
                setCommonConfig(getCommonConfigBuilder()
                    .setLocalizationLanguage(outputLanguage)
                    .build());

                if (language != null) {
                    currentLocale = new Locale(language);
                }

                response.put("success", true);
                result.success(response);
                break;                        
            }
            case "setString": {
                final HashMap<String, Object> response = new HashMap<>();
                
                HashMap<String, String> strings = (HashMap<String, String>) arguments.get("strings");

                Log.d("INCD", "setString " + strings.toString());
                IncodeWelcome.getInstance().setStrings(currentLocale, strings);

                response.put("success", true);
                result.success(response);
                break;                        
            }
            case "setSdkMode": {
                String sdkMode = (String) arguments.get("sdkMode");
                final HashMap<String, Object> response = new HashMap<>();
                if (sdkMode != null) {
                    IncodeWelcome.getInstance().setSdkMode(
                        sdkMode.equals("captureOnly") ? SdkMode.CAPTURE_ONLY :
                        sdkMode.equals("submitOnly") ? SdkMode.SUBMIT_ONLY :
                        SdkMode.STANDARD
                    );
                    response.put("success", true);
                } else {
                    response.put("success", false);
                }
                result.success(response);
                break;
            }
            case "startFaceLogin":
                HashMap<?, ?> faceLoginConfig = (HashMap<?, ?>) arguments.get("faceLogin");

                SelfieScan.FaceAuthMode authMode;
                String faceAuthMode = (String) (faceLoginConfig != null ? faceLoginConfig.get("faceAuthMode") : null);
                if (faceAuthMode == null) {
                    faceAuthMode = "server";
                }
                switch (faceAuthMode) {
                    case "local":
                        authMode = SelfieScan.FaceAuthMode.LOCAL;
                        break;
                    case "hybrid":
                        authMode = SelfieScan.FaceAuthMode.HYBRID;
                        break;
                    case "kiosk":
                        authMode = SelfieScan.FaceAuthMode.FR_ONLY;
                        break;
                    default:
                        authMode = SelfieScan.FaceAuthMode.SERVER;
                }

                SelfieScan.Builder selfieScanBuilder = new SelfieScan.Builder()
                        .setMode(SelfieScan.Mode.LOGIN)
                        .setFaceAuthMode(authMode);

                if (faceLoginConfig != null) {
                    String customerUUID = (String) faceLoginConfig.get("customerUUID");
                    if (customerUUID != null) {
                        selfieScanBuilder.setCustomerUUID(customerUUID);
                    }

                    Boolean showTutorials = (Boolean) faceLoginConfig.get("showTutorials");
                    if (showTutorials != null) {
                        selfieScanBuilder.setShowTutorials(showTutorials);
                    }

                    Boolean lensesCheck = (Boolean) faceLoginConfig.get("lensesCheck");
                    if (lensesCheck != null) {
                        selfieScanBuilder.setLensesCheckEnabled(lensesCheck);
                    }

                    Boolean faceMaskCheck = (Boolean) faceLoginConfig.get("faceMaskCheck");
                    if (faceMaskCheck != null) {
                        selfieScanBuilder.setMaskCheckEnabled(faceMaskCheck);
                    }

                    Boolean logAuthenticationEnabled = (Boolean) faceLoginConfig.get("logAuthenticationEnabled");
                    if (logAuthenticationEnabled != null) {
                        selfieScanBuilder.setLogAuthenticationEnabled(logAuthenticationEnabled);
                    }

                    Boolean faceAuthModeFallback = (Boolean) faceLoginConfig.get("faceAuthModeFallback");
                    if (faceAuthModeFallback != null) {
                        selfieScanBuilder.setAllowFaceAuthModeFallback(faceAuthModeFallback);
                    }

                    Double recognitionThreshold = (Double) faceLoginConfig.get("recognitionThreshold");
                    if (recognitionThreshold != null) {
                        if (commonConfig == null) {
                            commonConfig = new CommonConfig.Builder().build();
                        }
                        commonConfig = CommonConfig.Builder.from(commonConfig)
                                .setRecognitionThreshold(recognitionThreshold.floatValue())
                                .build();
                        IncodeWelcome.getInstance().setCommonConfig(commonConfig);
                    }

                    Double spoofThreshold = (Double) faceLoginConfig.get("spoofThreshold");
                    if (spoofThreshold != null) {
                        if (commonConfig == null) {
                            commonConfig = new CommonConfig.Builder().build();
                        }
                        commonConfig = CommonConfig.Builder.from(commonConfig)
                                .setSpoofThreshold(spoofThreshold.floatValue())
                                .build();
                        IncodeWelcome.getInstance().setCommonConfig(commonConfig);
                    }
                }

                IncodeWelcome.getInstance().startFaceLogin(activity, selfieScanBuilder.build(), new SelfieScanListener() {
                    @Override
                    public void onSelfieScanCompleted(SelfieScanResult selfieScanResult) {
                        final HashMap<String, Object> response = new HashMap<>();
                        final HashMap<String, Object> data = TypeHelper.getFaceLoginResultMap(selfieScanResult);
                        response.put("success", selfieScanResult.faceLoginResult != null && selfieScanResult.faceLoginResult.success);
                        response.put("data", data);
                        result.success(response);
                    }

                    @Override
                    public void onError(Throwable throwable) {
                        final HashMap<String, Object> response = new HashMap<>();
                        response.put("success", false);
                        response.put("error", throwable.getMessage());
                        result.success(response);
                    }

                    @Override
                    public void onUserCancelled() {
                        final HashMap<String, Object> response = new HashMap<>();
                        response.put("success", false);
                        response.put("error", "UserCancelled");
                        result.success(response);
                    }
                });
                break;
            case "addFace": {
                final HashMap<String, Object> response = new HashMap<>();
                String faceTemplate = (String) arguments.get("faceTemplate");
                String customerUUID = (String) arguments.get("customerUUID");
                String templateId = (String) arguments.get("templateId");

                if (faceTemplate != null && customerUUID != null && templateId != null) {
                    FaceInfo faceInfo = new FaceInfo(0, templateId, faceTemplate, customerUUID); // '0' will be ignored by Android SDK
                    IncodeWelcome.getInstance().addFace(faceInfo);
                    response.put("success", true);
                } else {
                    response.put("success", false);
                    response.put("error", "Incorrect input values, please make sure faceTemplate, customerUUID, and templateId are provided correctly");
                }
                result.success(response);
                break;
            }
            case "removeFace": {
                final HashMap<String, Object> response = new HashMap<>();
                String customerUUID = (String) arguments.get("customerUUID");
                if (customerUUID != null) {
                    IncodeWelcome.getInstance().removeFace(customerUUID);
                    response.put("success", true);
                } else {
                    response.put("success", false);
                    response.put("error", "Incorrect input value, please make sure customerUUID was provided correctly");
                }
                result.success(response);
                break;
            }
            case "getFaces": {
                final HashMap<String, Object> response = new HashMap<>();
                IncodeWelcome.getInstance().getFaces(new FaceInfoListener() {
                    @Override
                    public void onGetFacesCompleted(@NonNull List<FaceInfo> faceInfoList) {
                        JSONArray jsonArray = new JSONArray();
                        try {
                            for (FaceInfo faceInfo : faceInfoList) {
                                JSONObject jsonObject = new JSONObject();
                                jsonObject.put("faceTemplate", faceInfo.getFaceTemplate());
                                jsonObject.put("customerUUID", faceInfo.getCustomerUUID());
                                jsonObject.put("templateId", faceInfo.getTemplateId());
                                jsonArray.put(jsonObject);
                            }
                            response.put("data", jsonArray.toString());
                            response.put("success", true);
                        } catch (JSONException exc) {
                            Timber.w("Couldn't serialize face info list");
                            response.put("error", "Couldn't serialize face info list");
                            response.put("success", false);
                        }
                        result.success(response);
                    }

                    @Override
                    public void onError(@NonNull Throwable throwable) {
                        response.put("success", false);
                        response.put("error", throwable.getMessage());
                        result.success(response);
                    }
                });

                break;
            }
            case "setFaces":
                final HashMap<String, Object> response = new HashMap<>();
                String facesJSONArrayString = (String) arguments.get("faces");
                List<FaceInfo> faceInfoList = new ArrayList<>();
                try {
                    // Convert the JSON array string to JSONArray
                    JSONArray jsonArray = new JSONArray(facesJSONArrayString);

                    // Iterate over the JSONArray and process the objects
                    for (int i = 0; i < jsonArray.length(); i++) {
                        JSONObject jsonObject = jsonArray.getJSONObject(i);

                        String faceTemplate = jsonObject.getString("faceTemplate");
                        String customerUUID = jsonObject.getString("customerUUID");
                        String templateId = jsonObject.getString("templateId");

                        FaceInfo faceInfo = new FaceInfo(0, templateId, faceTemplate, customerUUID);
                        faceInfoList.add(faceInfo);
                    }

                    IncodeWelcome.getInstance().setFaces(faceInfoList);
                    response.put("success", true);
                } catch (JSONException e) {
                    response.put("success", false);
                    response.put("error", "Couldn't process faces list from flutter");
                }
                result.success(response);
                break;
            case "getUserScore":
                String strFetchMode = (String) arguments.get("fetchMode");
                IncodeWelcome.getInstance().getUserScore(getUserScoreFetchMode(strFetchMode), null, new GetUserScoreListener() {

                    @Override
                    public void onUserCancelled() {
                        final HashMap<String, Object> response = new HashMap<>();
                        response.put("success", false);
                        response.put("error", "UserCancelled");
                        result.success(response);
                    }

                    @Override
                    public void onError(Throwable throwable) {
                        final HashMap<String, Object> response = new HashMap<>();
                        response.put("success", false);
                        response.put("error", throwable.getMessage());
                        result.success(response);
                    }

                    @Override
                    public void onUserScoreFetched(UserScoreResult userScoreResult) {
                        final HashMap<String, Object> response = new HashMap<>();

                        if (userScoreResult.error != null) {
                            response.put("success", false);
                            response.put("error", userScoreResult.error.getMessage());
                        } else {
                            response.put("success", true);
                            response.put("data", new UserScoreMapper().map(userScoreResult));
                        }
                        result.success(response);
                    }
                });
                break;

            case "addNOM151Archive":
                IncodeWelcome.getInstance().addNOM151Archive(null, new AddNOM151ArchiveListener() {
                    @Override
                    public void onAddNOM151ArchiveListener(@NonNull AddNOM151ArchiveResult addNOM151ArchiveResult) {
                        final HashMap<String, Object> response = new HashMap<>();
                        final HashMap<String, Object> dataResponse = new HashMap<>();

                        dataResponse.put("archiveUrl", addNOM151ArchiveResult.getArchiveUrl());
                        dataResponse.put("signature", addNOM151ArchiveResult.getSignature());

                        response.put("success", true);
                        response.put("data", dataResponse);

                        result.success(response);
                    }

                    @Override
                    public void onError(Throwable throwable) {
                        final HashMap<String, Object> response = new HashMap<>();
                        response.put("success", false);
                        response.put("error", throwable.getMessage());

                        result.success(response);
                    }

                    @Override
                    public void onUserCancelled() {
                        final HashMap<String, Object> response = new HashMap<>();
                        response.put("success", false);
                        response.put("error", "UserCancelled");
                        result.success(response);
                    }
                });
                break;
            case "getUserOCRData":
                String token = (String) arguments.get("token");
                IncodeWelcome.getInstance().getUserOCRData(token, new GetUserOCRDataListener() {
                    @Override
                    public void onGetUserOCRDataComplete(@NonNull IncodeWelcome.OCRData ocrData) {
                        final HashMap<String, Object> response = new HashMap<>();
                        final HashMap<String, Object> dataResponse = new HashMap<>();

                        final Map<String, Object> extendedOcrJsonData = ocrData.getExtendedOcrJsonData();
                        HashMap<String, Object> wrappedExtendedOcrJsonData = new HashMap<String, Object>() {{
                            put("ocrData", extendedOcrJsonData);
                        }};

                        if (extendedOcrJsonData.get("extendedData") != null) {
                            try {
                                String dummyDataJSON = new JSONObject("{\"ocrData\":{\"curp\":\"MXMO860324HDFRDM05\",\"cic\":\"153654132\",\"registrationDate\":2004,\"numeroEmisionCredencial\":\"01\",\"birthDate\":512006400000,\"issueDate\":2012,\"claveDeElector\":\"MRMDOM86032409H800\",\"addressFields\":{\"colony\":\"COL JORGE NEGRETE\",\"street\":\"C MARIO MORENO MZ 201E LT 4\",\"city\":\"GUSTAVO A. MADERO\",\"state\":\"D.F.\",\"postalCode\":\"07280\"},\"fullNameMrz\":\"Omar Martinez Madrid\",\"expirationDate\":2022,\"address\":\"C MARIO MORENO MZ 201E LT 4 COL JORGE NEGRETE 07280 GUSTAVO A. MADERO ,D.F.\",\"ocr\":\"3145897456321\",\"gender\":\"M\",\"name\":{\"firstName\":\"Omar\",\"paternalLastName\":\"Martinez\",\"fullName\":\"Omar Martinez Madrid\",\"maternalLastName\":\"Madrid\"}}}").toString();
                                dataResponse.put("ocrData", dummyDataJSON);
                            } catch (JSONException e) {
                                Log.w("INCD", "Couldn't parse extendedOCR: " + e.getMessage());
                            }
                        } else {
                            String ocrDataString = new JSONObject(wrappedExtendedOcrJsonData).toString();
                            dataResponse.put("ocrData", ocrDataString);
                        }

                        response.put("success", true);
                        response.put("data", dataResponse);

                        result.success(response);
                    }

                    @Override
                    public void onError(Throwable throwable) {
                        final HashMap<String, Object> response = new HashMap<>();
                        response.put("success", false);
                        response.put("error", throwable.getMessage());

                        result.success(response);
                    }

                    @Override
                    public void onUserCancelled() {
                        final HashMap<String, Object> response = new HashMap<>();
                        response.put("success", false);
                        response.put("error", "UserCancelled");
                        result.success(response);
                    }
                });
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    IncodeWelcome.IDResultsFetchMode getUserScoreFetchMode(String fetchMode) {
        if (fetchMode == null) return null;

        switch (fetchMode) {
            case "accurate":
                return IncodeWelcome.IDResultsFetchMode.ACCURATE;
            case "fast":
                return IncodeWelcome.IDResultsFetchMode.FAST;
            default: return null;
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        methodChannel.setMethodCallHandler(null);
        eventChannel.setStreamHandler(null);
        eventChannel = null;
    }

    @Override
    public void onDetachedFromActivity() {
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    }

    @Override
    public void onAttachedToActivity(ActivityPluginBinding binding) {
        activity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        eventSink = events;
    }

    @Override
    public void onCancel(Object arguments) {
    }
}

class IdValidationResultMapping {
    static HashMap<Integer, String> validationResultMap = new HashMap<Integer, String>() {
        {
            put(IdResults.RESULT_USER_CANCELLED, "userCancelled");
            put(IdResults.RESULT_ERROR_UNKNOWN, "unknownError");
            put(IdResults.RESULT_OK, "ok");
            put(IdResults.RESULT_ERROR_CLASSIFICATION, "errorClassification");
            put(IdResults.FRONT_ID_RESULT_ERROR_NO_FACES_FOUND, "noFacesFound");
            put(IdResults.RESULT_ERROR_GLARE, "errorGlare");
            put(IdResults.RESULT_ERROR_SHARPNESS, "errorSharpness");
            put(IdResults.RESULT_ERROR_SHADOW, "errorShadow");
            put(IdResults.PASSPORT_RESULT_ERROR_CLASSIFICATION, "errorPassportClassification");
            put(IdResults.RESULT_ERROR_ADDRESS_STATEMENT, "errorAddress");
            put(IdResults.RESULT_ERROR_READABILITY, "errorReadability");
            put(IdResults.RESULT_EMULATOR_DETECTED, "emulatorDetected");
        }
    };

    public static String fromCode(int idValidationResult) {
        return validationResultMap.get(idValidationResult);
    }
}
