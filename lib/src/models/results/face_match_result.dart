import 'package:onboarding_flutter_wrapper/onboarding_flutter_wrapper.dart';
import 'package:onboarding_flutter_wrapper/src/utils/enum_utils.dart';

class FaceMatchResult {
  final bool faceMatched;
  final IdCategory idCategory;
  final bool? existingUser;
  final String? existingInterviewId;
  final bool? nameMatched;

  FaceMatchResult(
    this.faceMatched,
    this.idCategory,
    this.existingUser,
    this.existingInterviewId,
    this.nameMatched,
  );

  factory FaceMatchResult.fromJson(Map<String, dynamic> json) =>
      FaceMatchResult(
        json['faceMatched'],
        EnumUtils.enumDecode(
          IdCategory.values,
          json['idCategory'],
        ),
        json['existingUser'],
        json['existingInterviewId'],
        json['nameMatched'],
      );

  @override
  String toString() =>
      'FaceMatchResult: {faceMatched: $faceMatched, idCategory: $idCategory, existingUser: $existingUser, existingInterviewId: $existingInterviewId, nameMatched: $nameMatched}';
}
