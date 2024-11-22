import 'base_viewmodel.dart';

class HomePageViewModel extends BaseViewModel { //wrap inside Base view model
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
