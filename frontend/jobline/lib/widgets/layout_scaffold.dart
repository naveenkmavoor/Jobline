import 'package:flutter/material.dart';
import 'package:jobline/colors.dart';

class LayoutScaffold extends StatelessWidget {
  final Widget body;
  const LayoutScaffold({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Jobline',
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              maxRadius: 15,
              backgroundColor: JoblineColors.neutral25,
            ),
          )
        ],
      ),
      body: SafeArea(child: body),
    );
  }
}
