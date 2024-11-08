import 'package:flutter/material.dart';

class UpdateTask extends StatelessWidget {
  const UpdateTask({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Task'),
      ),
      body: const Center(
        child: Text('Update Task'),
      ),
    );
  }
}