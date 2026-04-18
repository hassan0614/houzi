class ApprovalStatuesList {
  int? status_code;
  String? status;
  String? label;
  String? description;
  bool? isActionable;

  ApprovalStatuesList({
    this.status_code,
    this.status,
    this.label,
    this.description,
    this.isActionable,
  });

  static ApprovalStatuesList parseUserApprovalStatusesItem(dynamic json) {
  return ApprovalStatuesList(
    description: json["description"] as String? ?? '',
    label: json["label"] as String? ?? '',
    status: json["status"] as String? ?? '',
    isActionable: json["is_actionable"] as bool? ?? false,
    status_code: json["status_code"] as int? ?? 0,
  );
  }}