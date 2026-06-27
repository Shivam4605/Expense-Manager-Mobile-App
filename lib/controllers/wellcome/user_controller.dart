import 'package:shared_preferences/shared_preferences.dart';

class UserController {
  String name = "";
  bool isLoggedIn = false;
  String userName = "";

  Future<void> setuserData(Map<String, dynamic> map) async {
    SharedPreferences setusersharedPreferences =
        await SharedPreferences.getInstance();

    await setusersharedPreferences.setString("name", map['name']);
    await setusersharedPreferences.setBool("isLoggedIn", map['isLoggedIn']);
    await setusersharedPreferences.setString("userName", map['userName']);

    await getuserData();
  }

  Future<SharedPreferences> getuserData() async {
    SharedPreferences setusersharedPreferences =
        await SharedPreferences.getInstance();

    name = setusersharedPreferences.getString("name") ?? '';
    isLoggedIn = setusersharedPreferences.getBool("isLoggedIn") ?? false;
    userName = setusersharedPreferences.getString("userName") ?? '';

    return setusersharedPreferences;
  }
}
