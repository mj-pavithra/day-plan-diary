import 'package:flutter/material.dart';
class ToDoItem extends StatelessWidget {
  final String title;
  final String date;
  final String priority;
  final bool isCompleted;

  const ToDoItem({
    super.key,
    required this.title,
    required this.date,
    required this.priority,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child:GestureDetector(
        onTap: () => print('Task tapped'),
        child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(date),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: (priority == 'High')
                      ? const Icon(Icons.check_circle, color: Color.fromARGB(255, 241, 2, 2))
                      : (priority == 'Medium')
                      ? const Icon(Icons.check_circle, color: Color.fromARGB(255, 250, 233, 0))
                      : (const Icon(Icons.check_circle, color: Color.fromARGB(122, 42, 25, 194))),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 6.0),
                  child: Text(
                    priority,
                    style: const TextStyle(color: Colors.blueAccent),
                  ),
                ),
                
                
                
              ],
            ),
          ],
        ),
      ),
      )
       
    );
  }
}