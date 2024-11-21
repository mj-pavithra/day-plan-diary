import 'package:day_plan_diary/viewmodels/todoItemViewModel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ToDoItem extends StatelessWidget {
  final TodoItemViewModel viewModel;
  final int taskKey;

  const ToDoItem({super.key, required this.viewModel, required this.taskKey});


  @override
  Widget build(BuildContext context) {
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        // onTap: () => viewModel.onTaskTap(context),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                viewModel.task!.title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(viewModel.task!.date),
                  const SizedBox(width: 10),
                  Icon(Icons.check_circle, color: viewModel.priorityColor),
                  const SizedBox(width: 6),
                  Text(
                    viewModel.task!.priority,
                    style: const TextStyle(color: Colors.blueAccent),
                  ),
                  Spacer(),
                  IconButton(
                    icon: const Icon(Icons.edit_note),
                    color: Colors.blue,
                    tooltip: 'Edit Task',
                    onPressed: () {
                      print('Edit task button pressed');
                      GoRouter.of(context).go(
                    '/updatetask',
                    extra: {
                      'taskIndex': taskKey,
                      'task': viewModel.task,
                    },
                  );
                    },
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
