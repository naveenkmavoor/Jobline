import 'package:flutter/material.dart';
import 'package:jobline/colors.dart';
import 'package:jobline/typography/text_styles.dart';

class JoblineTitle extends StatelessWidget {
  const JoblineTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
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
    );
  }
}
