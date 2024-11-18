import 'package:hive/hive.dart';

part 'test.g.dart';

@HiveType(typeId: 0)
class Test {

  Test({
    required this.title,
    required this.date,
    required this.priority,
    required this.isCompleted,
  });

  @HiveField(0)
  String title;

  @HiveField(1)
  String date;

  @HiveField(2)
  String priority;

  @HiveField(3)
  bool isCompleted;

  
}