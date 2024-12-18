import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Example Model
class GreetingViewModel extends ChangeNotifier {
  String _greetingMessage = "Good Morning";

  String get greetingMessage => _greetingMessage;

  void updateGreeting() {
    int currentHour = DateTime.now().hour;
    if (currentHour >= 0 && currentHour < 12) {
      _greetingMessage = 'Good Morning';
    } else if (currentHour >= 12 && currentHour < 17) {
      _greetingMessage = 'Good Afternoon';
    } else if (currentHour >= 17 && currentHour < 20) {
      _greetingMessage = 'Good Evening';
    } else {
      _greetingMessage = 'Good Night';
    }
    notifyListeners();
  }
}

class Greeting extends StatelessWidget {
  const Greeting({super.key});

  @override
  Widget build(BuildContext context) {
    // Use ChangeNotifierProvider and ensure it's at a higher level in the widget tree
    return ChangeNotifierProvider<GreetingViewModel>(
      create: (context) => GreetingViewModel(),
      child: Builder(
        builder: (context) {
          // Now we can safely access GreetingViewModel here
          return Consumer<GreetingViewModel>(
            builder: (context, viewModel, child) {
              return Text(
                viewModel.greetingMessage, // Access the greeting message dynamically
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
