import 'package:day_plan_diary/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import '/snackbar_utils.dart';
import '../strings.dart';
import 'package:hive/hive.dart';
import '../ForHive/task.dart';

class UpdateTaskPage extends StatefulWidget {
  final int taskIndex;
  final Map taskData;


  const UpdateTaskPage({super.key, required this.taskIndex, required this.taskData});

  @override
  _UpdateTaskPageState createState() => _UpdateTaskPageState();
}

class _UpdateTaskPageState extends State<UpdateTaskPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  String selectedPriority = SelectPriority;
  bool setCompleted = false;

  @override
  void initState() {
    super.initState();
    titleController.text = widget.taskData['title'];
    dateController.text = widget.taskData['date'];
    selectedPriority = widget.taskData['priority'];
    setCompleted = widget.taskData['isCompleted'];
  }

  void updateTask() async {
    if (titleController.text.isEmpty || dateController.text.isEmpty || selectedPriority == SelectPriority) {
      SnackbarUtils.showSnackbar(
        FillFieldsError,
        backgroundColor: Colors.red,
      );
      return;
    }

    DateTime selectedDate = DateTime.parse(dateController.text);
    if (selectedDate.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
      SnackbarUtils.showSnackbar(
        PastDateError,
        backgroundColor: Colors.red,
      );
      return;
    }

    final taskBox = Hive.box<Task>('tasksBox');
    // final taskBox = Hive.box('tasksBox');
    // var updatedTaskData = {
    //   'title': titleController.text,
    //   'date': dateController.text,
    //   'priority': selectedPriority,
    //   'isCompleted': setCompleted,
    // };

    if ((widget.taskIndex ) < taskBox.length) {
      try {
        final updatedTask = Task(
          title: titleController.text,
          date: dateController.text,
          priority: selectedPriority,
          isCompleted: setCompleted,
        );
        await taskBox.put(widget.taskIndex , updatedTask );
        context.go('/');
        SnackbarUtils.showSnackbar(
          TaskUpdateSuccess,
          backgroundColor: Colors.green,
        );
      } catch (e) {
        SnackbarUtils.showSnackbar(
          '$TaskUpdateError$e',
          backgroundColor: Colors.red,
        );
      }
    } else {
      SnackbarUtils.showSnackbar(
        "${widget.taskIndex}",
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
        title: const SafeArea(child: Text(TaskUpdateTitle)),
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
                  UpdateYourTask,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: TitleLabel,
                    labelStyle: TextStyle(color: Colors.grey),
                    filled: false,
                    border: OutlineInputBorder(gapPadding: 2),
                    fillColor: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: dateController,
                  readOnly: false,
                  decoration: InputDecoration(
                    labelText: DateLabel,
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
                  items: [
                    SelectPriority,
                    HighPriority,
                    MediumPriority,
                    LowPriority
                  ].map((priority) => DropdownMenuItem(
                    value: priority,
                    child: Text(
                      priority,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  )).toList(),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(gapPadding: 2),
                    fillColor: Color.fromARGB(255, 255, 255, 255),
                    filled: true,
                  ),
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 12.0),
                    child: Text(
                      SetAsCompleted,
                      style: TextStyle(fontSize: 16, color: Color.fromARGB(210, 11, 81, 172)),
                    ),
                  ),
                  Checkbox(
                      value: setCompleted,
                      onChanged: (bool? value) {
                        setState(() {
                          setCompleted = value ?? false;
                        });
                      }),
                ],
              ),
              const Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: updateTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(188, 113, 22, 155),
                    minimumSize: const Size(260, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    UpdateButtonText,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
