class SignUpModel {
  String name;
  String userName;
  String password;

  SignUpModel({this.name = "", this.password = "", this.userName = ""});

  factory SignUpModel.fromJson(Map<String, dynamic> json) {
    return SignUpModel(
      name: json['name'] ?? '',
      password: json['password'] ?? '',
      userName: json['userName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {"name": name, "userName": userName, "password": password};
  }
}
