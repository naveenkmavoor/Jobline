import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:jobline/app/app.dart';
import 'package:jobline/app/app_bloc_observer.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  setPathUrlStrategy();
  Hive.init;
  await Hive.openBox('appBox');
  Bloc.observer = AppBlocObserver();
  runApp(const App());
}
