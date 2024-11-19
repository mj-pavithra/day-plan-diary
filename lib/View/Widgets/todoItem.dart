import 'package:flutter/material.dart';
import 'package:day_plan_diary/ViewModels/todoItemViewModel.dart';

class ToDoItem extends StatelessWidget {
  final TodoItemViewModel viewModel;

  const ToDoItem({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: () => viewModel.onTaskTap(context),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                viewModel.title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(viewModel.date),
                  const SizedBox(width: 10),
                  Icon(Icons.check_circle, color: viewModel.priorityColor),
                  const SizedBox(width: 6),
                  Text(
                    viewModel.priority,
                    style: const TextStyle(color: Colors.blueAccent),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
