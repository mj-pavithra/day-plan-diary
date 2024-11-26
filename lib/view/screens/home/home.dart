import 'package:day_plan_diary/view/screens/home/todoBody.dart';
import 'package:day_plan_diary/view/widgets/greeting.dart';
import 'package:day_plan_diary/viewmodels/auth_viewmodel.dart';
import 'package:day_plan_diary/viewmodels/homePageViewModel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HomePageViewModel>(context);
    late final authViewModel = Provider.of<AuthViewModel>(context); 

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
  backgroundColor: Colors.white,
  elevation: 0,
  title: SafeArea(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Greeting(),
        Text(
          viewModel.userName,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  ),
  actions: [
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          icon: const CircleAvatar(
            backgroundImage: NetworkImage('https://avatars.githubusercontent.com/u/83787860?v=4'),
            radius: 20,
          ),
          items: const [
            DropdownMenuItem(
              value: 'logout',
              child: Row(
                children: [
                  Icon(Icons.logout, color: Colors.purple),
                  SizedBox(width: 8),
                  Text('Log out'),
                ],
              ),
            ),
          ],
          onChanged: (value) async {
            if (value == 'logout') {
              await authViewModel.logout(); // Replace with your logout logic
              GoRouter.of(context).go('/login');
            }
          },
        ),
      ),
    ),
  ],
),

      // appBar: AppBar( 
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   title: SafeArea(
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //          const Greeting(),
      //         Text(viewModel.userName, style: const TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold)),
      //       ],
      //     ),
      //   ),
      //   actions: const [
      //     Padding(
      //       padding: EdgeInsets.all(8.0),
      //       child: CircleAvatar(
      //         backgroundImage: NetworkImage('https://avatars.githubusercontent.com/u/83787860?v=4'),
      //         radius: 20,
      //       ),
      //     ),
      //   ],
      // ),
            body: const ToDoBody(), 
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(

        onPressed: () => context.go('/newtask'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
