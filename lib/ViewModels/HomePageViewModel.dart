import 'package:flutter/material.dart';

class HomePageViewModel extends ChangeNotifier { //wrap inside Base view model
  String userName = "Manoj";
  String userGreeting = "Good Morning";

  // Future support for dynamic data
  void updateGreeting(String newGreeting) {
    userGreeting = newGreeting;
    notifyListeners();
  }

  void updateUserName(String newName) {
    userName = newName;
    notifyListeners();
  }
}
