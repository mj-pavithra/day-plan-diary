import 'package:day_plan_diary/Models/task.dart';
import 'package:day_plan_diary/Utils/snackbar.dart';
import 'package:day_plan_diary/Utils/strings.dart';
// import 'package:day_plan_diary/ViewModels/todoListViewModel.dart';
import 'package:day_plan_diary/ViewModels/updateTaskViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateTaskPage extends StatelessWidget {
  final int taskIndex;
  final Task task;

  const UpdateTaskPage({
    super.key,
    required this.taskIndex,
    required this.task,
  });




  // void _updateTask(BuildContext context) async {
  //   final viewModel = Provider.of<UpdateTaskViewModel>(context, listen: false);
  //   final todoListViewModel = Provider.of<TodoListViewModel>(context, listen: false);

  //   if (viewModel.titleController.text.isEmpty ||
  //       viewModel.dateController.text.isEmpty ||
  //       viewModel.selectedPriority == SelectPriority) {
  //     SnackbarUtils.showSnackbar(FillFieldsError, backgroundColor: Colors.red);
  //     return;
  //   }

  //   await todoListViewModel.updateTask(
  //     taskIndex,
  //     viewModel.getUpdatedTask(),
  //   );

  //   Navigator.pop(context);
  //   SnackbarUtils.showSnackbar(TaskUpdateSuccess, backgroundColor: Colors.green);
  // }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UpdateTaskViewModel(taskId: taskIndex, task: task)..initialize(task),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(TaskUpdateTitle),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<UpdateTaskViewModel>(
            builder: (context, viewModel, child) {
              return Column(
                children: [
                  TextField(
                    controller: viewModel.titleController,
                    decoration: const InputDecoration(labelText: TitleLabel),
                  ),
                  TextField(
                    controller: viewModel.dateController,
                    decoration: InputDecoration(
                      labelText: DateLabel,
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
                            viewModel.dateController.text =
                                pickedDate.toString().split(' ')[0];
                          }
                        },
                      ),
                    ),
                  ),
                  DropdownButtonFormField<String>(
                    value: viewModel.selectedPriority,
                    items: [HighPriority, MediumPriority, LowPriority]
                        .map((priority) => DropdownMenuItem(
                              value: priority,
                              child: Text(priority),
                            ))
                        .toList(),
                    onChanged: (value) {
                      viewModel.setPriority(value!);
                    },
                  ),
                  CheckboxListTile(
                    title: const Text(SetAsCompleted),
                    value: viewModel.isCompleted,
                    onChanged: (value) {
                      viewModel.setCompletion(value!);
                    },
                  ),
                  ElevatedButton(
                    onPressed: () => {SnackbarUtils.showSnackbar( 'We are having tiny issue with updating tasks', backgroundColor: Colors.red)},
                  //   viewModel.updateTask(
                  //     context:context,
                  //     title: titleController.text,
                  //     date: dateController.text,
                  //     priority: selectedPriority,
                  //     isCompleted: isCompleted,
                  // ),
                    child: const Text(UpdateButtonText),
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
