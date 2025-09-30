import 'package:flutter/material.dart';
import 'package:jobline/colors.dart';
import 'package:jobline/typography/font_weights.dart';
import 'package:jobline/typography/text_styles.dart';

class JoblineTitle extends StatelessWidget {
  const JoblineTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return RichText(
      text: TextSpan(children: [
        TextSpan(
          text: 'Job',
          style: textTheme.displayMedium!
              .copyWith(fontWeight: JoblineFontWeight.black),
        ),
        TextSpan(
          text: 'line',
          style: textTheme.displayMedium!.copyWith(
              fontWeight: JoblineFontWeight.black,
              decoration: TextDecoration.underline,
              decorationColor: JoblineColors.lightOrange),
        ),
        TextSpan(
          text: '.',
          style: textTheme.displayMedium!.copyWith(
              fontWeight: JoblineFontWeight.black,
              color: JoblineColors.lightOrange),
        ),
      ]),
    );
  }
}
