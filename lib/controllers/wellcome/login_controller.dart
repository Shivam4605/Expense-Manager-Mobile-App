import 'dart:convert';
import 'dart:developer';

import 'package:expence_manager/controllers/wellcome/user_controller.dart';
import 'package:expence_manager/services/request_service.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class LoginController with ChangeNotifier {
  bool isLoading = false;
  bool isSuccessFlag = false;

  static const String _baseURL = 'http://biencaps.in/expense-manager';

  // Login
  Future<void> loginUser({required Map<String, dynamic> map}) async {
    isLoading = true;
    isSuccessFlag = false;
    notifyListeners();

    try {
      final requestService = RequestService(
        url: "$_baseURL/user/login",
        body: map,
      );

      final response = await requestService.post();
      log("Login response: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final userController = UserController();
        await userController.getuserData();

        Map<String, dynamic> data = jsonDecode(response.body);

        if (data['success'] == true) {
          await userController.setuserData({
            "name": userController.name,
            "userName": userController.userName,
            "isLoggedIn": true,
          });

          isSuccessFlag = true;
          notifyListeners();
        }

        log("isSuccessFlag = $isSuccessFlag");
        log("name = ${userController.name}");
        log("userName = ${userController.userName}");
        log("isLoggedIn = ${userController.isLoggedIn}");

        log("Login success");
      }
    } catch (e) {
      isSuccessFlag = false;
      log("Login error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Sign Up
  Future<void> signUpUser({required Map<String, dynamic> map}) async {
    isLoading = true;

    notifyListeners();

    try {
      final requestService = RequestService(
        url: "$_baseURL/user/signup",
        body: map,
      );

      http.Response response = await requestService.post();
      log("SignUp response: ${response.body}");
      log("SignUp status code: ${response.statusCode}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> data = jsonDecode(response.body);

        if (data['success'] == true) {
          await UserController().setuserData({
            "name": map['name'] ?? "",
            "userName": map["userName"] ?? "",
            "isLoggedIn": false,
          });

          isSuccessFlag = true;
          notifyListeners();
        }

        UserController userController = UserController();
        await userController.getuserData();

        log(userController.name);
        log(userController.userName);
        log("${userController.isLoggedIn}");

        log("Sign up success");
      }
    } catch (e) {
      isSuccessFlag = false;
      log("Sign up error: $e");
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }
}
