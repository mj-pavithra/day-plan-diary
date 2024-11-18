import 'package:day_plan_diary/SubWidgets/todoItem.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../ForHive/task.dart';
import 'package:day_plan_diary/snackbar_utils.dart';
import '';

class TodoList extends StatelessWidget {
  final String selectedPriority;
  final bool isTodoSelected;

  const TodoList({super.key, required this.isTodoSelected, required this.selectedPriority});


  void _confirmDelete(BuildContext context, Box taskBox, dynamic taskKey) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Task"),
          content: const Text("Are you sure you want to delete this task?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                taskBox.delete(taskKey);
                print('Task deleted: $taskKey');
                Navigator.of(context).pop();
                SnackbarUtils.showSnackbar(
                  'Task deleted successfully',
                  backgroundColor: Colors.red,
                );
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Box<Task> taskBox = Hive.box<Task>('tasksBox'); 
    print(taskBox.values);

    // return(const Text('Hello'));
    return ValueListenableBuilder(
      valueListenable: taskBox.listenable(),
      builder: (context, Box<Task> box, _) {
        final tasks = box.values.where((task) {
          if (selectedPriority == 'All') {
            return task.isCompleted == !isTodoSelected;
          }
          return task.isCompleted == !isTodoSelected && task.priority == selectedPriority;
        }).toList();

        if (tasks.isEmpty) {
          return const Center(
            child: Text('No tasks available'),
          );
        }

        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: List.generate(tasks.length, (index) {
              final task = tasks[index];
              Task taskData = Task(
                title: task.title,
                date: task.date,
                priority: task.priority,
                isCompleted: task.isCompleted,
              );

              Map<String, dynamic> taskMap = taskData.toMap();
              return Padding(
                padding: const EdgeInsets.all(3),
                child:
              //   Dismissible(
              //     key: Key(box.keys.toList()[index].toString()),
              //     direction: DismissDirection.horizontal,
              //     onDismissed: (direction) {
              //       if (direction == DismissDirection.endToStart) {
              //         _confirmDelete(context, taskBox, box.keys.toList()[index]);
              //       } else if (direction == DismissDirection.startToEnd) {
              //         Navigator.pushNamed(context, '/updatetask', arguments: {
              //           'taskIndex': box.keys.toList()[index],
              //           'taskData': task,
              //         });
              //       }
              //     },
              //     background: Container(
              //       alignment: Alignment.centerLeft,
              //       color: Colors.green,
              //       padding: const EdgeInsets.only(left: 20),
              //       child: const Icon(Icons.edit, color: Colors.white),
              //     ),
              //     secondaryBackground: Container(
              //       alignment: Alignment.centerRight,
              //       color: Colors.red,
              //       padding: const EdgeInsets.only(right: 20),
              //       child: const Icon(Icons.delete, color: Colors.white),
              //     ),
              // child: ToDoItem(
              //     title: task.title,
              //     date: task.date,
              //     priority: task.priority,
              //     isCompleted: task.isCompleted,
              //   ),
              //   ),

                GestureDetector(
                  onLongPress: () {
                  },
                  onHorizontalDragEnd: (details) {
                    if (details.primaryVelocity! > 0) {

                      print("Right");
                      Navigator.pushNamed(context, '/updatetask', arguments: {
                        'taskIndex': box.keys.toList()[index],
                        'taskData': taskMap,
                        'taskBox': taskBox
                      });
                    }
                    else{
                      print("left");
                      _confirmDelete(context, taskBox, box.keys.toList()[index]);
                    }
                  },
                  onDoubleTap: () {
                    print(box.keys.toList()[index]);
                    print(taskMap);
                    Navigator.pushNamed(context, '/updatetask', arguments: {
                      'taskIndex': box.keys.toList()[index],
                      'taskData': taskMap,
                    });
                  },
                  child: ToDoItem(
                    title: task.title,
                    date: task.date,
                    priority: task.priority,
                    isCompleted: task.isCompleted,
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
