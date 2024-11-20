import 'package:day_plan_diary/View/Widgets/todoBody.dart';
import 'package:day_plan_diary/ViewModels/HomePageViewModel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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
              Text(viewModel.userGreeting, style: const TextStyle(color: Colors.black, fontSize: 18)),
              Text(viewModel.userName, style: const TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage('https://avatars.githubusercontent.com/u/83787860?v=4'),
              radius: 20,
            ),
          ),
        ],
      ),
            body: const ToDoBody(), 
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(

        onPressed: () => context.go('/newtask'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
