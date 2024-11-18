import 'package:flutter/material.dart';
import 'package:day_plan_diary/snackbar_utils.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../ForHive/task.dart';
import '../strings.dart';

class CreateTaskPage extends StatefulWidget {
  const CreateTaskPage({super.key});

  @override
  _CreateTaskPageState createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  String selectedPriority = selectPriority;

  @override
  void initState() {
    super.initState();
  }

  void saveTask() async {
    // Validation checks
    if (titleController.text.isEmpty ||
        dateController.text.isEmpty ||
        selectedPriority == selectPriority) {
      SnackbarUtils.showSnackbar(
        snackbarFillAllFields,
        backgroundColor: Colors.red,
      );
      return;
    }

    DateTime selectedDate = DateTime.parse(dateController.text);
    if (selectedDate.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
      SnackbarUtils.showSnackbar(
        snackbarFutureDate,
        backgroundColor: Colors.red,
      );
      return;
    }

    // Create a Task object
    final task = Task(
      title: titleController.text,
      date: dateController.text,
      priority: selectedPriority,
      isCompleted: false,
    );

    try {
      // Save Task object to Hive
      final taskBox = Hive.box<Task>('tasksBox');
      await taskBox.add(task);

      // Navigate back and show success message
      Navigator.pop(context);
      SnackbarUtils.showSnackbar(
        snackbarSaveSuccess,
        backgroundColor: Colors.green,
      );
    } catch (e) {
      print(e);
      SnackbarUtils.showSnackbar(
        '$snackbarSaveError $e',
        backgroundColor: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(appBarTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(
                createTaskHeader,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
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
                      firstDate: DateTime(2000),
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
                setState(() {
                  selectedPriority = newValue!;
                });
              },
              items: [selectPriority, priorityHigh, priorityMedium, priorityLow]
                  .map((priority) => DropdownMenuItem(
                value: priority,
                child: Text(priority),
              ))
                  .toList(),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: saveTask,
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
            ),
          ],
        ),
      ),
    );
  }
}
