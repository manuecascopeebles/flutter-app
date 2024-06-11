import 'dart:typed_data';

import 'package:onboarding_flutter_wrapper/src/models/modules/document_scan_module.dart';
import 'package:onboarding_flutter_wrapper/src/utils/enum_utils.dart';

class DocumentScanResult {
  final Uint8List? image;
  final DocumentType documentType;
  final Map<String, dynamic>? address;
  final String? ocrData;

  DocumentScanResult(this.image, this.documentType, this.address, this.ocrData);

  factory DocumentScanResult.fromJson(Map<String, dynamic> json) =>
      DocumentScanResult(
          json['image'],
          EnumUtils.enumDecode(
            DocumentType.values,
            json['documentType'],
          ),
          json['address'] != null
              ? Map<String, dynamic>.from(json['address'])
              : null,
          json['ocrData']);

  @override
  String toString() =>
      'DocumentScanResult: {documentType: $documentType, address: $address, ocrData: $ocrData, image: $image}';
}
