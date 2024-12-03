import 'package:day_plan_diary/view/screens/home/todoList.dart';
import 'package:day_plan_diary/viewmodels/todoItemViewModel.dart';
import 'package:day_plan_diary/viewmodels/todoListViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ToDoBody extends StatelessWidget {
  const ToDoBody({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TodoItemViewModel>(context);
    final todoListViewModel = Provider.of<TodoListViewModel>(context);

    return Container(
      color: Colors.white,
      child: SizedBox(
        height: 630,
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
                  SizedBox(
                    width: 100,
                    height: 35,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey),
                      ),
                      alignment: Alignment.center,
                      child:DropdownButton<String>(
                            borderRadius: BorderRadius.circular(10),
                            value: todoListViewModel.selectedPriority, // Get values from model
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                todoListViewModel.setSelectedPriority(newValue); // Update priority
                              }
                            },
                            items: <String>['All', 'High', 'Medium', 'Low']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: const TextStyle(color: Color.fromARGB(146, 0, 0, 0)),
                                ),
                              );
                            }).toList(),
                          ),

                    ),
                  ),
                ],
              ),
            ),
            Consumer<TodoListViewModel>(
              builder: (context, todoListViewModel, child) => Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextButton(
                      onPressed: () => todoListViewModel.setTodoSelection(true),
                      child: Text(
                        'TODO',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: todoListViewModel.isTodoSelected
                                  ?  const Color.fromARGB(206, 87, 39, 176)
                                  : Colors.grey,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: todoListViewModel.isTodoSelected
                              ? () {
                                  todoListViewModel.setTodoSelection(false);
                                }
                              : null, // Disables the button if the condition is not met
                          child: Text(
                            'COMPLETED',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: !todoListViewModel.isTodoSelected
                                  ?  const Color.fromARGB(206, 87, 39, 176)
                                  : Colors.grey,
                            ),
                          ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TodoList(
                isTodoSelected: todoListViewModel.isTodoSelected,
                selectedPriority: viewModel.selectedPriority,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
