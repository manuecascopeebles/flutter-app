import 'package:onboarding_flutter_wrapper/src/models/results/user_score_status.dart';
import 'package:onboarding_flutter_wrapper/src/utils/enum_utils.dart';

class UserScoreResult {
  final String? extendedUserScoreJsonData;
  final _UserScore? overall;
  final _UserScore? faceRecognition;
  final _UserScore? liveness;
  final _UserScore? idValidation;

  UserScoreResult(this.extendedUserScoreJsonData, this.overall,
      this.faceRecognition, this.liveness, this.idValidation);

  factory UserScoreResult.fromJson(Map<String, dynamic> json) =>
      UserScoreResult(
        json['extendedUserScoreJsonData'],
        json['overall'] != null
            ? _UserScore.fromJson(Map<String, dynamic>.from(json['overall']))
            : null,
        json['faceRecognition'] != null
            ? _UserScore.fromJson(
                Map<String, dynamic>.from(json['faceRecognition']))
            : null,
        json['liveness'] != null
            ? _UserScore.fromJson(Map<String, dynamic>.from(json['liveness']))
            : null,
        json['idValidation'] != null
            ? _UserScore.fromJson(
                Map<String, dynamic>.from(json['idValidation']))
            : null,
      );

  @override
  String toString() =>
      'UserScoreResult: {overall: $overall, faceRecognition: $faceRecognition, liveness: $liveness, idValidation: $idValidation, extendedUserScoreJsonData: $extendedUserScoreJsonData}';
}

class _UserScore {
  final String? value;
  final UserScoreStatus? status;

  _UserScore(this.value, this.status);

  factory _UserScore.fromJson(Map<String, dynamic> json) => _UserScore(
        json['value'],
        json['status'] != null
            ? EnumUtils.enumDecode(UserScoreStatus.values, json['status'])
            : null,
      );

  @override
  String toString() => '{value: $value, status: $status}';
}
