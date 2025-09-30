import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:url_strategy/url_strategy.dart';

import 'package:jobline/app/app.dart';
import 'package:jobline/app/app_bloc_observer.dart';

void main() async {
  setPathUrlStrategy();
  Hive.init;
  await Hive.openBox('appBox');
  Bloc.observer = AppBlocObserver();
  runApp(const App());
}

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:jobline/sample/showcase_timeline_tile.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'TimelineTile Showcase',
//       theme: ThemeData(
//         brightness: Brightness.dark,
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: ShowcaseTimelineTile(),
//     );
//   }
// }
