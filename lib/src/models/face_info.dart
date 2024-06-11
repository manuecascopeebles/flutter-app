class FaceInfo {
  final String faceTemplate;
  final String customerUUID;
  final String templateId;

  FaceInfo(this.faceTemplate, this.customerUUID, this.templateId);

  factory FaceInfo.fromJson(Map<String, dynamic> json) => FaceInfo(
        json['faceTemplate'],
        json['customerUUID'],
        json['templateId'],
      );

  Map toJson() => {
        'faceTemplate': faceTemplate,
        'customerUUID': customerUUID,
        'templateId': templateId
      };

  @override
  String toString() =>
      'FaceInfo: {faceTemplate: $faceTemplate, customerUUID: $customerUUID, templateId: $templateId}';
}
