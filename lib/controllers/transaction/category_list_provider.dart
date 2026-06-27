import 'dart:developer';
import 'package:flutter/material.dart';

class CategoryListProvider with ChangeNotifier {
  int? _selectedCategory;

  int? get category => _selectedCategory;

  void categorySelect(int? category) {
    _selectedCategory = category;
    log("$_selectedCategory");
    notifyListeners();
  }
}
