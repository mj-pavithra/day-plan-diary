import 'package:cached_network_image/cached_network_image.dart';
import 'package:day_plan_diary/view/screens/home/todoBody.dart';
import 'package:day_plan_diary/view/widgets/greeting.dart';
import 'package:day_plan_diary/viewmodels/todoListViewModel.dart';
import 'package:day_plan_diary/viewmodels/base_viewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final todoListViewModel = Provider.of<TodoListViewModel>(context);
    final BaseViewModel baseViewModel = Provider.of<BaseViewModel>(context);

    User user = FirebaseAuth.instance.currentUser!;

    bool isUserLoggedIn = baseViewModel.isTodoSelected;
    print('*********** $isUserLoggedIn *****');
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: SafeArea(
          child:  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Greeting(),
                  Text(
                    user.displayName!,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    icon: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(user.photoURL!),
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
                        await FirebaseAuth.instance.signOut();
                        await FirebaseAuth.instance.signOut();
                        GoRouter.of(context).go('/login');
                      }
                    },
                  ),
                )
          ),
        ],
      ),
      body: const ToDoBody(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: todoListViewModel.isTodoSelected
        ? FloatingActionButton(
            onPressed: () => context.go('/newtask'),
            child: const Icon(Icons.add),
          )
        : const Spacer(),
        );
  }

}
