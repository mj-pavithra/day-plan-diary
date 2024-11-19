import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:day_plan_diary/ViewModels/todoBodyViewModel.dart';
import 'package:day_plan_diary/View/Widgets/todoList.dart';

class ToDoBody extends StatelessWidget {
  const ToDoBody({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TodoBodyViewModel>(context);

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
                      child: DropdownButton<String>(
                        borderRadius: BorderRadius.circular(10),
                        value: viewModel.selectedPriority,
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            viewModel.updatePriority(newValue);
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
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () => viewModel.toggleTodoSelection(true),
                    child: Text(
                      'TODO',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: viewModel.isTodoSelected
                            ? const Color.fromARGB(206, 87, 39, 176)
                            : Colors.grey,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => viewModel.toggleTodoSelection(false),
                    child: Text(
                      'COMPLETED',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: viewModel.isTodoSelected
                            ? Colors.grey
                            : const Color.fromARGB(206, 87, 39, 176),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TodoList(
                isTodoSelected: viewModel.isTodoSelected,
                selectedPriority: viewModel.selectedPriority,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
