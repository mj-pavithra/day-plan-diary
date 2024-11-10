import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class CreateTaskPage extends StatefulWidget {
  const CreateTaskPage({super.key});

  @override
  _CreateTaskPageState createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  String selectedPriority = 'Medium';
  
  @override
  void initState() {
    super.initState();
    dateController.text = DateTime.now().toString().split(' ')[0]; // Set default date
  }

  void saveTask() async {
    var taskBox = Hive.box('tasksBox'); // Reference the tasks box
    var taskData = {
      'title': titleController.text,
      'date': dateController.text,
      'priority': selectedPriority,
    };

    await taskBox.add(taskData); // Save task as a map to Hive
    Navigator.pop(context); // Go back to home screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Create a New Task"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Create a new task',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                fillColor: Colors.grey[200],
                filled: true,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: dateController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Date',
                fillColor: Colors.grey[200],
                filled: true,
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedPriority,
              onChanged: (newValue) {
                setState(() {
                  selectedPriority = newValue!;
                });
              },
              items: ['High', 'Medium', 'Low']
                  .map((priority) => DropdownMenuItem(
                        value: priority,
                        child: Text(priority),
                      ))
                  .toList(),
              decoration: InputDecoration(
                labelText: 'Priority',
                fillColor: Colors.grey[200],
                filled: true,
              ),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: saveTask,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(188, 113, 22, 155),
                  minimumSize: const Size(200, 50),
                ),
                child: const Text('Create', style: TextStyle(fontSize: 20, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
