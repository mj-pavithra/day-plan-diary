import 'package:day_plan_diary/viewmodels/todoItemViewModel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:day_plan_diary/utils/strings.dart';

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
        title: const Text(appBarTitle),
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
              child: const Text(
                createButtonText,
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );

  }
}
