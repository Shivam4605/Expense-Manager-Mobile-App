import 'dart:convert';
import 'dart:developer';
import 'package:expence_manager/controllers/category/category_model.dart';
import 'package:expence_manager/controllers/transaction/transaction_controller.dart';
import 'package:expence_manager/controllers/wellcome/user_controller.dart';
import 'package:expence_manager/services/request_service.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class CategoryController with ChangeNotifier {
  String baseURL = 'http://biencaps.in/expense-manager';

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<CategoryData> list = [];

  Future<Map<String, dynamic>> getAllCategoryData({
    required String userName,
  }) async {
    String url = "$baseURL/category/all?userName=$userName";

    _isLoading = true;
    notifyListeners();

    RequestService requestService = RequestService(url: url);

    try {
      http.Response response = await requestService.getRequest();
      log(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        log("${response.statusCode}");

        Map<String, dynamic> map = jsonDecode(response.body);
        CategoryModel categoryModel = CategoryModel.fromJson(map);

        list.clear();
        list = categoryModel.data ?? [];
        log("${list.length}");

        notifyListeners();

        return map;
      }
    } on Exception catch (e) {
      log("$e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return {};
  }

  Future<Map<String, dynamic>> addUserCategory({
    required Map<String, dynamic> data,
  }) async {
    UserController userController = UserController();
    await userController.getuserData();

    _isLoading = true;
    notifyListeners();

    String url = "http://biencaps.in/expense-manager/category/add";

    RequestService requestService = RequestService(url: url, body: data);

    try {
      log("Request Body => $data");

      http.Response response = await requestService.post();

      log("Status Code => ${response.statusCode}");
      log("Response Body => ${response.body}");

      Map<String, dynamic> map = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        log("data added successfully");

        await getAllCategoryData(userName: userController.userName);

        notifyListeners();
      }

      return map;
    } on Exception catch (e) {
      log("$e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return {};
  }

  Future<Map<String, dynamic>> deleteUserCategory({
    required int catId,
    required String userName,
    required TransactionController obj,
  }) async {
    String url =
        "http://biencaps.in/expense-manager/category/delete/$catId?userName=$userName";

    _isLoading = true;
    notifyListeners();

    try {
      RequestService requestService = RequestService(url: url);

      http.Response response = await requestService.deleteCategory();

      Map<String, dynamic> map = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        log("Data deleted Successfully");
        list.removeWhere((item) => item.categoryId == catId);

        await getAllCategoryData(userName: userName);

        notifyListeners();
      }

      notifyListeners();

      return map;
    } on Exception catch (e) {
      log("$e");
    } finally {
      _isLoading = false;
      await obj.getAllTransaction(userName: userName);
      log("transaction get method are call");
      obj.allTransactionList.clear();
      notifyListeners();
    }

    return {};
  }
}
