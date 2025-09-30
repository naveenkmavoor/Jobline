import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RedirectScreen extends StatelessWidget {
  const RedirectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.goNamed('timeline', pathParameters: {'timelineId': " "});
    return const SizedBox();
  }
}
