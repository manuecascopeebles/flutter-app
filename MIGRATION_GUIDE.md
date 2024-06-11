# Migration Guide

## Migration to 3.0.0

1) Remove `core-light` dependency in your Android project's `build.gradle`:

```diff
dependencies {
- implementation 'com.incode.sdk:core-light:2.6.2' // Required core dependency
}
```

`com.incode.sdk:core-light` dependency is now part of the Flutter SDK itself.

2) Gradle versions should be updated to 7.+, ie. :

```diff
     dependencies {
-        classpath 'com.android.tools.build:gradle:4.2.0'
+        classpath 'com.android.tools.build:gradle:7.4.2'
     }
```

Update gradle distributionUrl in your `gradle-wrapper.properties`:
```diff
-        distributionUrl=https\://services.gradle.org/distributions/gradle-6.9-all.zip
+        distributionUrl=https\://services.gradle.org/distributions/gradle-7.5-all.zip
```

## Migration to 2.8.0

1) Update dependency in your Android project's `build.gradle`:
```diff
dependencies {
- implementation 'com.incode.sdk:core-light:2.6.1' // Required core dependency
+ implementation 'com.incode.sdk:core-light:2.6.2' // Required core dependency
}
```

## Migration to 2.7.0

1) Update dependency in your Android project's `build.gradle`:
```diff
dependencies {
- implementation 'com.incode.sdk:core-light:2.5.1' // Required core dependency
+ implementation 'com.incode.sdk:core-light:2.6.1' // Required core dependency
}
```

2) The following dependencies are optional and needed only in very specific use cases.
   Make sure you are using the features they provide before adding the dependencies below.
   Update dependency in your Android project's `build.gradle`:

```diff
dependencies {
+ implementation 'com.incode.sdk:kiosk-login:1.3.1' // Optional kiosk-login dependency is only necessary if you are using Kiosk Login feature of the SDK.
+ implementation 'com.incode.sdk:model-liveness-detection:3.0.0' // Optional model-liveness-detection dependency is only necessary if you are using liveness detection feature that runs locally on device. This feature can be used within IncodeOnboardingSdk.startFaceLogin method
+ implementation 'com.incode.sdk:model-face-recognition:3.0.0' // Optional model-face-recognition dependency is only necessary if you are using face recognition feature that runs locally on device. This feature can be used within IncodeOnboardingSdk.startFaceLogin method
}
```


## Migration to 2.6.0

1) Update dependency in your Android project's `build.gradle`:
```diff
dependencies {
- implementation 'com.incode.sdk:core-light:2.5.0' // Required core dependency
+ implementation 'com.incode.sdk:core-light:2.5.1' // Required core dependency
}
```

## Migration to 2.4.0

1) Update dependency in your Android project's `build.gradle`:
```diff
dependencies {
- implementation 'com.incode.sdk:core-light:2.4.0' // Required core dependency
+ implementation 'com.incode.sdk:core-light:2.5.0' // Required core dependency
}
```

2) Update `compileSdkVersion` and `targetSdkVersion` in your Android project's `build.gradle` to 33.

3) Bumped `minSdkVersion` into 21 from 17

## Migration to 2.2.0

1) Update dependency in your Android project's `build.gradle`:
```diff
dependencies {
- implementation 'com.incode.sdk:core-light:2.3.0' // Required core dependency
+ implementation 'com.incode.sdk:core-light:2.4.0' // Required core dependency
}
```


## Migration to 2.1.0

1) Update dependency in your Android project's `build.gradle`:
```diff
dependencies {
- implementation 'com.incode.sdk:core-light:2.2.0' // Required core dependency
+ implementation 'com.incode.sdk:core-light:2.3.0' // Required core dependency
}
```

## Migration to 2.x

1) Added `setupOnboardingSession` that replaces `creatingNewOnboardingSession` and `setOnboardingSession`

```diff
- IncodeOnboardingSdk.creatingNewOnboardingSession
+ IncodeOnboardingSdk.setupOnboardingSession
```

```diff
- IncodeOnboardingSdk.setOnboardingSession
+ IncodeOnboardingSdk.setupOnboardingSession
```

2) iOS app setup changed - it is no longer needed to add these lines to the Podfile, so these should be removed when upgrading to 2.x:

```diff
-source 'https://github.com/CocoaPods/Specs.git'
-source 'git@github.com:Incode-Technologies-Example-Repos/IncdDistributionPodspecs.git'
```