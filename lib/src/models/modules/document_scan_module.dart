import 'package:flutter/foundation.dart';
import 'package:onboarding_flutter_wrapper/src/models/modules/base_module.dart';

class DocumentScanModule extends BaseModule {
  @override
  String get name => 'DocumentScan';

  final bool? showTutorials;
  final bool? showDocumentProviderOptions;
  final DocumentType? documentType;

  DocumentScanModule({
    this.showTutorials,
    this.showDocumentProviderOptions,
    this.documentType,
  });

  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        if (showTutorials != null) 'showTutorials': showTutorials,
        if (showDocumentProviderOptions != null)
          'showDocumentProviderOptions': showDocumentProviderOptions,
        'documentType':
            documentType != null ? describeEnum(documentType!) : null,
      };
}

enum DocumentType {
  addressStatement,
  paymentProof,
  medicalDoc,
  otherDocument1,
  otherDocument2,
}
