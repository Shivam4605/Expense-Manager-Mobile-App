import 'dart:convert';
import 'dart:developer';
import 'package:expence_manager/controllers/transaction/transaction_model.dart';
import 'package:expence_manager/controllers/wellcome/user_controller.dart';
import 'package:expence_manager/services/request_service.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class TransactionController with ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<DataModel> allTransactionList = [];

  // Get All Transactions
  Future<void> getAllTransaction({required String userName}) async {
    String url =
        "http://biencaps.in/expense-manager/expense/all?userName=$userName&month=${DateFormat.MMMM().format(DateTime.now())}&year=${DateFormat.y().format(DateTime.now())}";

    _isLoading = true;
    notifyListeners();

    try {
      RequestService requestService = RequestService(url: url);

      http.Response response = await requestService.getRequest();

      log("Status Code : ${response.statusCode}");
      log("Response Body : ${response.body}");
      log("Url => $url");

      if (response.body.isEmpty) {
        throw Exception("API returned empty response");
      }

      Map<String, dynamic> json = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        TransactionModel transactionModel = TransactionModel.fromJson(json);

        if (response.body.isEmpty) {
          notifyListeners();
        }

        log("Before Clear: ${allTransactionList.length}");

        allTransactionList.clear();

        log("After Clear: ${allTransactionList.length}");

        log("API Data Length: ${transactionModel.data?.length}");
        log("Response Body: ${response.body}");

        allTransactionList.addAll(transactionModel.data ?? []);

        log("After Add: ${allTransactionList.length}");

        notifyListeners();
      }
    } on Exception catch (e) {
      log("$e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add User Transaction
  Future<Map<String, dynamic>> postUserTransaction({
    required Map<String, dynamic> json,
  }) async {
    String url = "http://biencaps.in/expense-manager/expense/add";

    _isLoading = true;
    notifyListeners();

    UserController userController = UserController();
    await userController.getuserData();

    try {
      RequestService requestService = RequestService(url: url, body: json);

      http.Response response = await requestService.post();

      Map<String, dynamic> map = jsonDecode(response.body);

      log("response body : s${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        log("Response : ${response.body}");

        await getAllTransaction(userName: userController.userName);
      }

      notifyListeners();
      return map;
    } catch (e) {
      log("$e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return {};
  }

  Future<Map<String, dynamic>> deleteTransaction({
    required int? expId,
    required String userName,
    required TransactionController obj,
  }) async {
    String url = "http://biencaps.in/expense-manager/expense/delete/$expId";

    _isLoading = true;
    notifyListeners();

    try {
      RequestService requestService = RequestService(url: url);

      http.Response response = await requestService.deleteCategory();

      Map<String, dynamic> json = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        log("API Called Successfully");
        log("Response : ${response.body}");

        obj.allTransactionList.clear();
        await obj.getAllTransaction(userName: userName);
        notifyListeners();
      }

      return json;
    } catch (e) {
      log("$e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return {};
  }
}
