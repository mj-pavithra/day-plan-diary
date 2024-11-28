import 'package:day_plan_diary/services/session_service.dart';
import 'package:day_plan_diary/view/screens/home/todoBody.dart';
import 'package:day_plan_diary/view/widgets/greeting.dart';
import 'package:day_plan_diary/viewmodels/auth_viewmodel.dart';
import 'package:day_plan_diary/viewmodels/homePageViewModel.dart';
import 'package:day_plan_diary/viewmodels/session_viewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});


  @override
  Widget build(BuildContext context) {

    String userName = FirebaseAuth.instance.currentUser!.displayName! ?? '';
    String displayPhoto = FirebaseAuth.instance.currentUser!.photoURL! ?? '';
    final sessionViewModel = Provider.of<SessionViewModel>(context);
    final viewModel = Provider.of<HomePageViewModel>(context);
    late final authViewModel = Provider.of<AuthViewModel>(context);
    SessionService sessionService = SessionService();

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
          userName,
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
          icon:  CircleAvatar(
            backgroundImage: NetworkImage(displayPhoto),
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
              FirebaseAuth.instance.signOut();
              
              sessionViewModel.clearSession();
              SessionViewModel().clearSession();
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
