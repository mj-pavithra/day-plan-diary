import 'package:flutter/material.dart';

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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
  String selectedPriority = 'High'; 
  bool isTodoSelected = true; 

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height :700,
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
                ),
                DropdownButton<String>(
                  value: selectedPriority,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedPriority = newValue!;
                    });
                  },
                  items: <String>['All', 'High', 'Medium', 'Low']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
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
                      color: isTodoSelected ? Colors.black : Colors.grey,
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
                      color: !isTodoSelected ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TodoList(isTodoSelected: isTodoSelected), 
          ),
        ],
      ),
    );
  }
}

class TodoList extends StatelessWidget {
  final bool isTodoSelected;
  const TodoList({super.key, required this.isTodoSelected});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: List.generate(10, (index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ToDoItem(
              title: 'Task ${index + 1}',
              description: 'Description of task ${index + 1}',
              priority: 'High',
              isCompleted: !isTodoSelected,
            ),
          );
        }),
      ),
    );
  }
}


class ToDoItem extends StatelessWidget {
  final String title;
  final String description;
  final String priority;
  final bool isCompleted;

  const ToDoItem({super.key, 
    required this.title,
    required this.description,
    required this.priority,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
            Text(
              description,
              style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Priority: $priority',
                  style: const TextStyle(color: Colors.blueAccent),
                ),
                isCompleted
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : const Icon(Icons.radio_button_unchecked, color: Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }
}




// import 'package:flutter/material.dart';

// class Home extends StatelessWidget {
//   const Home({super.key});

//   @override

//   Widget build(BuildContext context) {
//     return Scaffold(
      
//       appBar: AppBar(
//         actions: [
//           Padding(
//             padding: const EdgeInsets.all(6.0),
//             child: SizedBox(
//               width: 380,
//               height: 80,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                
//                 children: [
//                   const Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Hello",
//                       style: TextStyle(
//                         fontSize: 12.0,
//                         color: Colors.black45
//                       ),),
//                       Text("Name", style: TextStyle(
//                         fontSize: 18.0,
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold
//                       ),),
//                     ],
//                   ),
//                   CircleAvatar(
//                     radius: 20.0,
//                     child: ClipOval(
//                       child: Image.network(
//                         'https://avatars.githubusercontent.com/u/83787860?v=4',
//                         width: 40,
//                         height: 40,
//                         fit: BoxFit.cover,
                        
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           )
//         ],
//       ),
//       body: Container(
//         padding: const EdgeInsets.all(20.0),
//           child: const Column(
//             children: [
//               Row(children: [
//                 Text("Today", style: TextStyle(
//                   fontSize: 32.0,
//                   fontWeight: FontWeight.bold
//                 ),),
//                 Spacer(),
//                 Text("View All", style: TextStyle(
//                   fontSize: 16.0,
//                   color: Colors.blue
//                 ),)
//               ],)
//             ],
//           )
//       ),
//     );
//   }
// }