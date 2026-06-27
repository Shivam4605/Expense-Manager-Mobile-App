import 'dart:convert';
import 'dart:developer';
import 'package:expence_manager/controllers/trash/trash_model.dart';
import 'package:expence_manager/controllers/wellcome/user_controller.dart';
import 'package:expence_manager/services/request_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class TrashController with ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<TrashData> listOfTrashData = [];

  //Get Trash API
  Future<void> getTrashDetails({required String userName}) async {
    String url =
        "http://biencaps.in/expense-manager/trash/all/${DateFormat('yyyy-MM-dd').format(DateTime.now())}?userName=$userName";

    _isLoading = true;
    notifyListeners();

    try {
      RequestService requestService = RequestService(url: url);

      http.Response response = await requestService.getRequest();

      Map<String, dynamic> json = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        TrashModel trashModel = TrashModel.fromJson(json);

        log("status Code ${response.statusCode}");
        log("API response : ${response.body}");

        listOfTrashData.clear();
        listOfTrashData.addAll(trashModel.data ?? []);

        log("API called successfully");
      }
    } catch (e) {
      log("$e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //Delete Trash API
  Future<void> deleteTrash({required int trashId}) async {
    String url = "http://biencaps.in/expense-manager/trash/delete/$trashId";

    _isLoading = true;
    notifyListeners();

    UserController userController = UserController();
    await userController.getuserData();

    try {
      RequestService requestService = RequestService(url: url);

      http.Response response = await requestService.deleteCategory();

      // ignore: unused_local_variable
      Map<String, dynamic> json = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        log("API Called Successfully");
        log("${response.statusCode}");
        log("response body : ${response.body}");
      }
    } catch (e) {
      log("$e");
    } finally {
      _isLoading = false;
      listOfTrashData.clear();
      await getTrashDetails(userName: userController.userName);
      notifyListeners();
    }
  }

  //Restore Trash API
  Future<void> restoreTrash({required int trashId}) async {
    String url = "http://biencaps.in/expense-manager/trash/restore/$trashId";

    _isLoading = true;
    notifyListeners();

    UserController userController = UserController();
    await userController.getuserData();

    try {
      RequestService requestService = RequestService(url: url);

      http.Response response = await requestService.deleteCategory();

      // ignore: unused_local_variable
      Map<String, dynamic> json = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        log("API Called Successfully");
        log("${response.statusCode}");
        log("response body : ${response.body}");
      }
    } catch (e) {
      log("$e");
    } finally {
      _isLoading = false;
      listOfTrashData.clear();
      await getTrashDetails(userName: userController.userName);
      notifyListeners();
    }
  }
}
