import 'package:flutter/material.dart';

import 'package:jobline/colors.dart';
import 'package:jobline/widgets/custom_avatar.dart';

class StackedAvatars extends StatelessWidget {
  final List<String> avatars;
  final int threshold;
  final double spacing;
  final double? radius;
  const StackedAvatars(
      {Key? key,
      required this.avatars,
      this.threshold = 3,
      this.radius,
      this.spacing = 10})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> firstSetAvatars = avatars.take(threshold).toList();
    return Row(
      children: [
        Stack(
            children: firstSetAvatars.map((element) {
          int index = firstSetAvatars.indexOf(element);
          return Container(
              margin: EdgeInsets.only(left: index * spacing),
              padding: const EdgeInsets.all(1),
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: JoblineColors.white),
              child: CustomAvatar(
                radius: radius,
                name: element,
              ));
        }).toList()),
        if (avatars.length > 3) Text('+${avatars.length - threshold} more..')
      ],
    );
  }
}
