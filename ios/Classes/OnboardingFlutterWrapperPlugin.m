#import "OnboardingFlutterWrapperPlugin.h"
#if __has_include(<onboarding_flutter_wrapper/onboarding_flutter_wrapper-Swift.h>)
#import <onboarding_flutter_wrapper/onboarding_flutter_wrapper-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "onboarding_flutter_wrapper-Swift.h"
#endif

@implementation OnboardingFlutterWrapperPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftOnboardingFlutterWrapperPlugin registerWithRegistrar:registrar];
}
@end
