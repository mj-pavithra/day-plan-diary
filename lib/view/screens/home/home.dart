import 'package:day_plan_diary/services/session_service.dart';
import 'package:day_plan_diary/view/screens/home/todoBody.dart';
import 'package:day_plan_diary/view/widgets/greeting.dart';
import 'package:day_plan_diary/viewmodels/auth_viewmodel.dart';
import 'package:day_plan_diary/viewmodels/base_viewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  final bool isTodoSelected;

  const HomePage({
    super.key,
    required this.isTodoSelected
  });

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final BaseViewModel baseViewModel = Provider.of<BaseViewModel>(context);

    bool isUserLoggedIn = baseViewModel.isTodoSelected;
    print('*********** $isUserLoggedIn *****');
    print('++++++ $isTodoSelected ++++++');
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: SafeArea(
          child: FutureBuilder<Map<String, dynamic>>(
            future: _fetchUserDetails(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(); // Show loading spinner
              }
              if (snapshot.hasError) {
                return const Text('Error fetching user details');
              }

              final userName = snapshot.data?['userName'] ?? 'User Name';
              print('User name: $userName');
              return Column(
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
              );
            },
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder<Map<String, dynamic>>(
              future: _fetchUserDetails(),
              builder: (context, snapshot) {
                final displayPhoto = snapshot.data?['userPhotoUrl'] ?? 'https://cdn-icons-png.flaticon.com/128/3135/3135715.png';
              print ('User photo: $displayPhoto ');
                return DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    icon: CircleAvatar(
                    backgroundImage: NetworkImage(displayPhoto ),
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
                        final session = await SessionService.getInstance();
                        await session?.clearUserDetails();
                        GoRouter.of(context).go('/login');
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: const ToDoBody(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: isTodoSelected
        ? FloatingActionButton(
            onPressed: () => context.go('/newtask'),
            child: const Icon(Icons.add),
          )
        : const Spacer(),
        );
  }

  Future<Map<String, dynamic>> _fetchUserDetails() async {
    final session = await SessionService.getInstance();
    return await session?.getUserDetails() ?? {};
  }

  Future<String> _fetchUserPhoto() async {
    final session = await SessionService.getInstance();
    return session?.getUserName() ??
        'https://cdn-icons-png.flaticon.com/128/3135/3135715.png';
  }

}
