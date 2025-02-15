import 'package:flutter/material.dart';

class NavigationProvider extends ChangeNotifier {
  String currentPage = 'home';
  void setPage(String name) {
    currentPage = name;
    notifyListeners();
  }
}
