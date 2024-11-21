import 'package:flutter/material.dart';
import 'base_viewmodel.dart';

class TodoBodyViewModel extends ChangeNotifier {
  String selectedPriority = 'All';
  bool isTodoSelected = true;

  void updatePriority(String newPriority) {
    selectedPriority = newPriority;
    notifyListeners();
  }

  void toggleTodoSelection(bool isTodo) {
    isTodoSelected = isTodo;
    notifyListeners();
  }
}
