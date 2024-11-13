import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leadingWidth: 10,
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good Morning', 
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            Text(
              'Manoj', 
              style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage('https://avatars.githubusercontent.com/u/83787860?v=4'), 
              radius: 20,
            ),
          ),
        ],
      ),
      body: const ToDoBody(), 
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(3.0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/newtask');
          },
          backgroundColor: const Color.fromARGB(206, 87, 39, 176),
          child: const Icon(Icons.add, color: Colors.white,size: 40,),
        ),
      ),
    );
  }
}

class ToDoBody extends StatefulWidget {
  const ToDoBody({super.key});

  @override
  _ToDoBodyState createState() => _ToDoBodyState();
}

class _ToDoBodyState extends State<ToDoBody> {
  String selectedPriority = 'All'; 
  bool isTodoSelected = true; 


  @override
  Widget build(BuildContext context) {
    
    return Container(

      color: Colors.white,
      child: SizedBox(
        height :630,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Tasks',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ), SizedBox(
                    width: 100,
                    height: 35,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey),
                      ),
                      alignment: Alignment.center,
                      child: DropdownButton<String>(
                          borderRadius: BorderRadius.circular(10),
                          value: selectedPriority,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedPriority = newValue!;
                            } );
                          },
                          items: <String>['All', 'High', 'Medium', 'Low']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style: const TextStyle(color: Color.fromARGB(146, 0, 0, 0))),
                            );
                          }).toList(),
                        ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isTodoSelected = true;
                      });
                    },
                    child: Text(
                      'TODO',
                      
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isTodoSelected ?  const Color.fromARGB(206, 87, 39, 176) : Colors.grey,
                        
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isTodoSelected = false;
                      });
                    },
                    child: Text(
                      'COMPLETED',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isTodoSelected ?Colors.grey:  const Color.fromARGB(206, 87, 39, 176) ,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TodoList(isTodoSelected: isTodoSelected, selectedPriority: selectedPriority), 
            ),
          ],
        ),
      ),
    );
  }
}

class TodoList extends StatelessWidget {
  String selectedPriority;
  bool isTodoSelected;
  TodoList({super.key, required this.isTodoSelected, required this.selectedPriority});

  void _confirmDelete(BuildContext context, Box taskBox, task) {

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
                taskBox.delete(task);
                print(task);
                Navigator.of(context).pop(); 
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Task deleted successfully"),
                    backgroundColor: Colors.red,
                  ),
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
    final Box taskBox = Hive.box('tasksBox'); 

    return ValueListenableBuilder(
      valueListenable: taskBox.listenable(),
      builder: (context, Box box, _) {
        final tasks = box.values.where((task) {
          if (task is Map) {
            if (selectedPriority == 'All') {
              return task['isCompleted'] == !isTodoSelected;
            }
            return task['isCompleted'] == !isTodoSelected && ( task['priority'] == selectedPriority );
          }
          return false;
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
              final task = tasks[index] as Map; 

              return Padding(
                padding: const EdgeInsets.all(3),
                child: GestureDetector(
                 
          onLongPress: (){
            _confirmDelete(context, taskBox, box.keys.toList()[index]);
          },
          onDoubleTap: (){

                print(task);
                    Navigator.pushNamed(context, '/updatetask', arguments: {
                      'taskIndex': box.keys.toList()[index],
                      'taskData': task,
                    });
          },
                  child:  ToDoItem(
                    title: task['title'] ?? 'Untitled',
                    date: task['date'] ?? 'No date',
                    priority: task['priority'] ?? 'Medium',
                    isCompleted: task['isCompleted'] ?? false,
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


class ToDoItem extends StatelessWidget {
  final String title;
  final String date;

  final String priority;
  final bool isCompleted;

  const ToDoItem({
    super.key,
    required this.title,
    required this.date,
    required this.priority,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child:GestureDetector(
        onTap: () => print('Task tapped'),
        child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(date),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: (priority == 'High')
                      ? const Icon(Icons.check_circle, color: Color.fromARGB(255, 241, 2, 2))
                      : (priority == 'Medium')
                      ? const Icon(Icons.check_circle, color: Color.fromARGB(255, 250, 233, 0))
                      : (const Icon(Icons.check_circle, color: Color.fromARGB(122, 42, 25, 194))),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 6.0),
                  child: Text(
                    priority,
                    style: const TextStyle(color: Colors.blueAccent),
                  ),
                ),
                
                
                
              ],
            ),
          ],
        ),
      ),
      )
       
    );
  }
}