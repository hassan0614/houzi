class UserLoginInfo {
  String? token;
  String? userEmail;
  String? userNiceName;
  String? userDisplayName;
  int? userId;
  List<String>? userRole;
  String? avatar;

  UserLoginInfo({
    this.token,
    this.userEmail,
    this.userNiceName,
    this.userDisplayName,
    this.userId,
    this.userRole,
    this.avatar,
  });
}
