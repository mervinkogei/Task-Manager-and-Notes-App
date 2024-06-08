import 'package:flutter/material.dart';

import '../../Widgets/drawer.dart';
import '../../Widgets/task_builder.dart';

class AllTask extends StatelessWidget {
  const AllTask({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Tasks'),
      ),
      drawer: const MyDrawer(),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 20),
          child: TaskBuilder(
            filter: 'NoGroup',
          ),
        ),
      ),
    );
  }
}