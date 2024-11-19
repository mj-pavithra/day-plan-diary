import 'package:day_plan_diary/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:day_plan_diary/SubWidgets/todoBody.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leadingWidth: 10,
        elevation: 0,
        title: const SafeArea(
          child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good Morning',
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
              Text(
                'Manoj',
                style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
              ),
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(3.0),
        child: FloatingActionButton(
          onPressed: () {
            context.go('/newtask');
          },
          backgroundColor: const Color.fromARGB(206, 87, 39, 176),
          child: const Icon(Icons.add, color: Colors.white,size: 40,),
        ),
      ),
    );
  }
}
