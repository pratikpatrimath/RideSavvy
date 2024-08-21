class UserMaster {
  int? userId;
  String? name, emailId, password;

  UserMaster({
    this.userId,
    this.name,
    this.emailId,
    this.password,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (userId != null) {
      data["userId"] = userId;
    }
    if (name != null) {
      data["name"] = name;
    }
    if (emailId != null) {
      data["emailId"] = emailId;
    }
    if (password != null) {
      data["password"] = password;
    }
    return data;
  }

  UserMaster.fromMap(Map<String, dynamic> data) {
    userId = data['userId'];
    name = data['name'];
    emailId = data['emailId'];
    password = data['password'];
  }
}
