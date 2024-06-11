class ApprovalResult {
  final bool success;
  final String? uuid;
  final String? customerToken;

  ApprovalResult(this.success, this.uuid, this.customerToken);

  factory ApprovalResult.fromJson(Map<String, dynamic> json) => ApprovalResult(
        json['success'],
        json['uuid'],
        json['customerToken'],
      );

  @override
  String toString() =>
      'ApprovalResult: {success: $success, uuid: $uuid, customerToken: $customerToken}';
}
