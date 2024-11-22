import 'package:day_plan_diary/data/models/task.dart';
import 'package:day_plan_diary/utils/snackbar.dart';
import 'package:day_plan_diary/utils/strings.dart';
import 'package:day_plan_diary/viewmodels/todoItemViewModel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class UpdateTaskPage extends StatelessWidget {
  final int taskIndex;
  final Task task;

  const UpdateTaskPage({
    super.key,
    required this.taskIndex,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final viewModel = TodoItemViewModel();
        viewModel.task = task; // Assign the task directly
        return viewModel;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(uTaskUpdateTitle),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.go('/');
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<TodoItemViewModel>(
            builder: (context, viewModel, child) {
              return Column(
                children: [
                  // Task Title Input
                  TextField(
                    controller: TextEditingController(text: viewModel.task?.title),
                    onChanged: (value) => viewModel.task?.title = value,
                    decoration: const InputDecoration(
                      labelText: uTitleLabel,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  // Task Date Input
                  TextField(
                    controller: TextEditingController(text: viewModel.task?.date),
                    decoration: InputDecoration(
                      labelText: uDateLabel,
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            viewModel.task?.date = pickedDate.toString().split(' ')[0];
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  // Task Priority Dropdown
                  DropdownButtonFormField<String>(
                    value: viewModel.task?.priority,
                    items: [uHighPriority, uMediumPriority, uLowPriority]
                        .map((priority) => DropdownMenuItem(
                              value: priority,
                              child: Text(priority),
                            ))
                        .toList(),
                    onChanged: (value) => viewModel.task?.priority = value!,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  // Completion Checkbox
                  
                  const Spacer(),
                  // Update Button
                  ElevatedButton(
                    onPressed: () async {
                      // Ensure navigation and updates are performed sequentially
                      try {
                        print('Updating task...');
                        await viewModel.updateTask(
                          taskIndex,
                          viewModel.task!,
                        );
                        GoRouter.of(context).go('/');
                        SnackbarUtils.showSnackbar(
                          uSuccessMessage,
                          backgroundColor: Colors.green,
                        );
                        // Pop only once the task is updated
                        if (context.mounted) {
                          context.go('/');
                        }
                      } catch (e) {
                        SnackbarUtils.showSnackbar(
                          'Error updating task: $e',
                          backgroundColor: Colors.red,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(260, 50),
                      backgroundColor: const Color.fromARGB(206, 87, 39, 176),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      uUpdateButtonText,
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
