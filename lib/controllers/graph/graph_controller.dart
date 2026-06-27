import 'dart:convert';
import 'dart:developer';
import 'package:expence_manager/controllers/graph/graph_model.dart';
import 'package:expence_manager/controllers/transaction/transaction_controller.dart';
import 'package:expence_manager/services/request_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class GraphController with ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<DataModelClass> graphDataList = [];

  Future<void> getAllGraphData({
    required String userName,
    required TransactionController transactionController,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      String url =
          "http://biencaps.in/expense-manager/category/all/amount"
          "?userName=$userName"
          "&month=${DateFormat.MMMM().format(DateTime.now())}"
          "&year=${DateFormat.y().format(DateTime.now())}";

      RequestService requestService = RequestService(url: url);

      http.Response response = await requestService.getRequest();

      if (response.statusCode == 204) {
        graphDataList.clear();
        notifyListeners();
        return;
      }

      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);

        GraphModel graphModel = GraphModel.fromJson(json);

        graphDataList.clear();
        graphDataList.addAll(graphModel.data ?? []);
        notifyListeners();
      }

      log("DataModelClass list : ${graphDataList.length}");
    } catch (e) {
      log(e.toString());
    } finally {
      await transactionController.getAllTransaction(userName: userName);

      _isLoading = false;
      notifyListeners();
    }
  }
}
