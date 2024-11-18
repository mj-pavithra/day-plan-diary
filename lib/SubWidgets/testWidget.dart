import 'package:day_plan_diary/ForHive/test.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TestWidget extends StatelessWidget {
  const TestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final Box<Test> testBox = Hive.box<Test>('testBox');
    return Container(
      child: ValueListenableBuilder(
        valueListenable: testBox.listenable(),
        builder: (context, Box<Test> box, _) {
          final tests = box.values; 
          return ListView.builder(
            itemCount: tests.length,
            itemBuilder: (context, index) {
              final test = tests.index;
              return ListTile(
                title: Text(test.title),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    test.delete(test.key);
                  },
                ),
              );
            },
          );
        },
      ),
    );

  }
}