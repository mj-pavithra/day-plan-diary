import 'package:day_plan_diary/helpers/dateFormatter.dart';
import 'package:day_plan_diary/viewmodels/todoItemViewModel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ToDoItem extends StatelessWidget {
  final TodoItemViewModel viewModel;
  final int taskKey;
  final bool isTodoSelected;

  const ToDoItem({
    super.key, 
    required this.viewModel, 
    required this.taskKey,
    required this.isTodoSelected,
    });



  @override
  Widget build(BuildContext context) {

    final testText = viewModel.task!.title.toString();
print(isTodoSelected) ;

    return Card(
      color: Colors.white,
      elevation: 5,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        // onTap: () => ,
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
                  Text(formatDate(viewModel.task!.date),
                      style: const TextStyle(color: Colors.grey)),
                  const SizedBox(width: 10),
                  Icon(Icons.check_circle, color: viewModel.priorityColor),
                  const SizedBox(width: 6),
                  Text(
                    viewModel.task!.priority,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const Spacer(),
                  isTodoSelected ?
                    IconButton(
                      icon: const Icon(Icons.edit_note),
                      color: const Color.fromARGB(255, 0, 0, 0),
                      tooltip: 'Edit Task',
                      onPressed: () {
                        print('You tappes on ,Itile:-  $testText, index:- $taskKey');
                        GoRouter.of(context).go(
                      '/updatetask',
                      extra: {
                        'task': viewModel.task,
                      },
                    );

                      },
                  ):const Spacer(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
