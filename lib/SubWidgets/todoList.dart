import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class TodoList extends StatelessWidget {
  final bool isTodoSelected;
  const TodoList({super.key, required this.isTodoSelected});

  @override
  Widget build(BuildContext context) {
    final Box taskBox = Hive.box('tasksBox'); // Access the tasks box

    return ValueListenableBuilder(
      valueListenable: taskBox.listenable(),
      builder: (context, Box box, _) {
        // Filter tasks based on `isCompleted` status and `selectedPriority`
        final tasks = box.values.where((task) {
          final isCompleted = task['isCompleted'] ?? false;
          return isTodoSelected ? !isCompleted : isCompleted;
        }).toList();

        if (tasks.isEmpty) {
          return const Center(
            child: Text('No tasks available'),
          );
        }

        return SingleChildScrollView(
          child: Column(
            children: List.generate(tasks.length, (index) {
              final task = tasks[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ToDoItem(
                  title: task['title'] ?? 'Untitled',
                  description: task['description'] ?? 'No description',
                  priority: task['priority'] ?? 'Medium',
                  isCompleted: task['isCompleted'] ?? false,
                ),
              );
            }),
          ),
        );
      },
    );
  }
}

class ToDoItem extends StatelessWidget {
  final String title;
  final String description;
  final String priority;
  final bool isCompleted;

  const ToDoItem({
    super.key,
    required this.title,
    required this.description,
    required this.priority,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
            Text(
              description,
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Priority: $priority',
                  style: const TextStyle(color: Colors.blueAccent),
                ),
                isCompleted
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : const Icon(Icons.radio_button_unchecked, color: Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
