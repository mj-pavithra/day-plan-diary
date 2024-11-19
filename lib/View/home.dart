import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:day_plan_diary/ViewModels/HomePageViewModel.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomePageViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(viewModel.userGreeting, style: TextStyle(color: Colors.black, fontSize: 18)),
              Text(viewModel.userName, style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage('https://avatars.githubusercontent.com/u/83787860?v=4'),
              radius: 20,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/newtask'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
