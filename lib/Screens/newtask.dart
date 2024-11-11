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
  String selectedPriority = 'Select Priority';
  
  @override
  void initState() {
    super.initState();
    // dateController.text = DateTime.now().toString().split(' ')[0];
  }

  void saveTask() async {
  if (titleController.text.isEmpty || dateController.text.isEmpty || selectedPriority == 'Select Priority') {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please fill all the fields correctly'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  // Ensure no past date
  DateTime selectedDate = DateTime.parse(dateController.text);
  if (selectedDate.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Dont be stupid, you cant add tasks for past dates'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  var taskBox = Hive.box('tasksBox');
  var taskData = {
    'title': titleController.text,
    'date': dateController.text,
    'priority': selectedPriority,
    'isCompleted': false,
  };

  try {
    await taskBox.add(taskData);
    Navigator.pop(context);
    print('Task saved successfully');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Task saved successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  } catch (e) {
    print(e);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error saving task: $e'),
        backgroundColor: Colors.red,
      ),
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
        title: const Text("Create a New Task"),
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
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
        
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    labelStyle: TextStyle(color: Colors.grey),
                    filled: false,
                    border: OutlineInputBorder(gapPadding: 2),
                    fillColor: Color.fromARGB(255, 255, 255, 255),
                    iconColor:Colors.grey, 
                  ),
                ),
              ),
        
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: dateController,
                          readOnly: false,  
                          decoration: InputDecoration(
                            labelText: 'Date',
                            filled: false,
                            border: const OutlineInputBorder(gapPadding: 2),
                            labelStyle: const TextStyle(color: Colors.grey),
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
                      ),
        
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  value: selectedPriority,
                  onChanged: (newValue) {
                    setState(() {
                      selectedPriority = newValue!;
                    });
                  },
                  items: ['Select Priority','High', 'Medium', 'Low']
                      .map((priority) => DropdownMenuItem(
                            value: priority,
                            child: Text(priority, style: const TextStyle(color: Colors.grey),),
                          ))
                      .toList(),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(gapPadding: 2),
                    fillColor: Color.fromARGB(255, 255, 255, 255),
                    filled: true,
                  ),
                ),
              ),
              const Spacer(),
              Center(
                child:  ElevatedButton(
                        onPressed: saveTask,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(188, 113, 22, 155),
                          minimumSize: const Size(260, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), 
                          ),
                        ),
                        child: const Text('Create', style: TextStyle(fontSize: 20, color: Colors.white)),
                      ),

                    ),
            ],
          ),
        ),
      ),
    );
  }
}
