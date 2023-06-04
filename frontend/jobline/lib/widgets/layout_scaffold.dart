import 'package:flutter/material.dart';
import 'package:jobline/colors.dart';
import 'package:jobline/typography/text_styles.dart';

class LayoutScaffold extends StatelessWidget {
  final Widget body;
  const LayoutScaffold({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: JoblineColors.neutralLight)))),
        title: RichText(
          text: TextSpan(children: [
            TextSpan(
              text: 'Job',
              style: JoblineTextStyle.mainHeadline,
            ),
            TextSpan(
              text: 'line',
              style: JoblineTextStyle.mainHeadline.copyWith(
                  decoration: TextDecoration.underline,
                  decorationColor: JoblineColors.lightOrange),
            ),
            TextSpan(
              text: '.',
              style: JoblineTextStyle.mainHeadline
                  .copyWith(color: JoblineColors.lightOrange),
            ),
          ]),
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
