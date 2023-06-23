import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jobline/shared/data/timeline/models/current_timeline.dart';

String? getUserName() {
  final name = Hive.box('appBox').get('name');
  return name;
}

Map<String, String?> getUserInfo() {
  final name = Hive.box('appBox').get('name');
  final email = Hive.box('appBox').get('email');
  final id = Hive.box('appBox').get('id');
  final role = Hive.box('appBox').get('accType');
  return {'name': name, 'email': email, 'id': id, 'accType': role};
}

String? getUserRole() {
  final role = Hive.box('appBox').get('accType') as String?;
  return role ?? '';
}

String? getTimelineId() {
  final timelineId = Hive.box('appBox').get('timelineId');
  return timelineId;
}

String getEmail() {
  final email = Hive.box('appBox').get('email', defaultValue: '');
  return email;
}

putVerified(bool isVerified) {
  Hive.box('appBox').put('isVerified', isVerified);
}

bool isVerified() {
  final isVerified = Hive.box('appBox').get('isVerified', defaultValue: false);
  return isVerified;
}

putTimelineId(String timelineId) {
  Hive.box('appBox').put('timelineId', timelineId);
}

deleteTimelineId() {
  Hive.box('appBox').delete('timelineId');
}

bool isAuthenticated() {
  final isAuth = Hive.box('appBox').get('token') != null;
  return isAuth;
}

Future<int> clearDb() async {
  final isClear = await Hive.box('appBox').clear();
  return isClear;
}
