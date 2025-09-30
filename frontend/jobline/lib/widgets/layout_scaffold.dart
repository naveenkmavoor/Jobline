import 'package:flutter/material.dart';
import 'package:jobline/colors.dart';
import 'package:jobline/typography/text_styles.dart';
import 'package:jobline/widgets/appBarType.dart';
import 'package:jobline/widgets/jobline_title.dart';

class LayoutScaffold extends StatelessWidget {
  final Widget body;
  final AppBarTypes? appBarTypes;
  const LayoutScaffold({super.key, required this.body, this.appBarTypes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      appBar: appBarTypes != null
          ? buildAppBarType(
              context: context,
              type: appBarTypes!,
            )
          : null,
      body: SafeArea(child: body),
    );
  }
}
