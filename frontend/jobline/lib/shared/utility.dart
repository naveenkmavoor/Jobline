import 'package:hive_flutter/hive_flutter.dart';

String? getUserName() {
  final name = Hive.box('appBox').get('name');
  return name;
}
