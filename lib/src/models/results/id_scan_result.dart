import 'dart:typed_data';

import 'package:onboarding_flutter_wrapper/onboarding_flutter_wrapper.dart';
import 'package:onboarding_flutter_wrapper/src/utils/enum_utils.dart';

class IdScanResult {
  final Uint8List? image;
  final String? base64Image;
  final Uint8List? croppedFace;
  final IdType? chosenIdType;
  final String? classifiedIdType;
  final IdCategory? idCategory;
  final IdValidationStatus scanStatus;

  IdScanResult(
    this.image,
    this.base64Image,
    this.croppedFace,
    this.chosenIdType,
    this.classifiedIdType,
    this.idCategory,
    this.scanStatus,
  );

  factory IdScanResult.fromJson(Map<String, dynamic> json) => IdScanResult(
        json['image'],
        json['base64Image'],
        json['croppedFace'],
        EnumUtils.enumDecode(IdType.values, json['chosenIdType']),
        json['classifiedIdType'],
        EnumUtils.enumDecode(IdCategory.values, json['idCategory']),
        EnumUtils.enumDecode(IdValidationStatus.values, json['scanStatus']),
      );

  @override
  String toString() =>
      'IdScanResult: {chosenIdType: $chosenIdType, classifiedIdType: $classifiedIdType, idCategory: $idCategory, scanStatus: $scanStatus, image: $image, base64Image" $base64Image, croppedFace: $croppedFace}';
}
