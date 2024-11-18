import 'package:flutter/material.dart';
import 'package:day_plan_diary/SubWidgets/todoList.dart';


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

