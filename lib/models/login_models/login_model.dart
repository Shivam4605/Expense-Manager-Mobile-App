class LoginModel {
  String userName;
  String password;

  LoginModel({this.password = "", this.userName = ""});

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      password: json['userName'] ?? '',
      userName: json['password'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {"userName": userName, "password": password};
  }
}
