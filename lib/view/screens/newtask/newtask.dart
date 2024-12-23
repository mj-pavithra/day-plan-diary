import 'package:day_plan_diary/data/models/task.dart';
import 'package:flutter/material.dart';
import 'package:day_plan_diary/viewmodels/todoItemViewModel.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:day_plan_diary/utils/strings.dart';

class CreateTaskPage extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  late TimeOfDay selectedTime = TimeOfDay.now();
  String selectedPriority = 'Select Priority';

  CreateTaskPage({super.key});

  void _selectTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (pickedTime != null) {
      selectedTime = pickedTime;
      timeController.text = pickedTime.format(context); // Update the text field
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TodoItemViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(appBarTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/home');
          },
        ),
      ),
      body: SingleChildScrollView(
        reverse: true, // Prevent layout issues when keyboard pops up
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: titleLabel,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: dateController,
                decoration: InputDecoration(
                  labelText: dateLabel,
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        dateController.text = pickedDate.toString().split(' ')[0];
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      icon: const Icon(Icons.access_time, size: 40),
                      onPressed: () => _selectTime(context),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: timeController,
                      decoration: const InputDecoration(
                        labelText: "Hours (with A.M./P.M.)",
                        border: OutlineInputBorder(),
                      ),
                      readOnly: true, // Prevent manual editing
                      onTap: () => _selectTime(context), // Open clock dialog
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              DropdownButtonFormField<String>(
                value: selectedPriority,
                onChanged: (newValue) {
                  if (newValue != null) {
                    selectedPriority = newValue;
                  }
                },
                items: const [
                  DropdownMenuItem(value: selectPriority, child: Text(selectPriority)),
                  DropdownMenuItem(value: priorityHigh, child: Text(priorityHigh)),
                  DropdownMenuItem(value: priorityMedium, child: Text(priorityMedium)),
                  DropdownMenuItem(value: priorityLow, child: Text(priorityLow)),
                ],
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (titleController.text.isEmpty ||
                      dateController.text.isEmpty ||
                      selectedPriority == 'Select Priority') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please fill all fields'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  Task task = Task(
                    id: -1, // Temporary ID, to be replaced later
                    title: titleController.text,
                    date: dateController.text,
                    priority: selectedPriority,
                    timeToComplete: timeController.text,
                    isCompleted: false,
                  );

                  viewModel.saveTask(
                    context: context,
                    task: task,
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(260, 50),
                  backgroundColor: const Color.fromARGB(206, 87, 39, 176),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  createButtonText,
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
