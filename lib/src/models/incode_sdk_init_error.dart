enum IncodeSdkInitError {
  simulatorDetected,
  testModeEnabled,
  rootDetected,
  hookDetected,
  unknown,
}

extension ParseEnumValue on String {
  IncodeSdkInitError? toIncodeSdkInitError() {
    switch (this) {
      case 'simulatorDetected':
        return IncodeSdkInitError.simulatorDetected;
      case 'testModeEnabled':
        return IncodeSdkInitError.testModeEnabled;
      case 'rootDetected':
        return IncodeSdkInitError.rootDetected;
      case 'hookDetected':
        return IncodeSdkInitError.hookDetected;
      case 'unknown':
        return IncodeSdkInitError.unknown;
      default:
        return null;
    }
  }
}
