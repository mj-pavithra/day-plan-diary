import 'package:day_plan_diary/ViewModels/todoItemViewModel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CreateTaskPage extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  String selectedPriority = 'Select Priority';

  CreateTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TodoItemViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Task'),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          context.go('/');
        },
      ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8.0),
            TextField(
  controller: dateController,
  decoration: InputDecoration(
    labelText: 'Date',
    border: const OutlineInputBorder(),
    suffixIcon: IconButton(
      icon: const Icon(Icons.calendar_today),
      onPressed: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(), // Disallow past dates
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
                 DropdownButtonFormField<String>(
                  value: selectedPriority,
                  onChanged: (newValue) {
                    selectedPriority = newValue!;
                  },
                  items: ["Select Priority", "High", "Medium", "Low"]
                      .map((priority) => DropdownMenuItem(
                            value: priority,
                            child: Text(priority),
                          ))
                      .toList(),

              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
                ),

            // (
            //   value: selectedPriority,
            //   onChanged: (newValue) {
            //     selectedPriority = newValue!;
            //   },
            //   items: ['Select Priority', 'High', 'Medium', 'Low']
            //       .map((priority) => DropdownMenuItem(
            //             value: priority,
            //             child: Text(priority),
            //           ))
            //       .toList(),
            // ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                viewModel.saveTask(
                  context: context,
                  title: titleController.text,
                  date: dateController.text,
                  priority: selectedPriority,
                );
              },
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(260, 50),
                  backgroundColor: const Color.fromARGB(206, 87, 39, 176),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              child: const Text('Save Task',
                  style: TextStyle(fontSize: 20, color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }
}
