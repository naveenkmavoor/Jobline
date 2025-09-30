import 'package:flutter/material.dart';
import 'package:jobline/colors.dart';

class CustomAvatar extends StatelessWidget {
  final String name;
  final double? radius;
  const CustomAvatar({super.key, required this.name, this.radius});
  static const List<Color> avatarColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
  ];

  Color getAvatarColor(String name) {
    int index = name.codeUnitAt(0) % avatarColors.length;
    return avatarColors[index];
  }

  @override
  Widget build(BuildContext context) {
    final avatarColor = getAvatarColor(name);
    final textTheme = Theme.of(context).textTheme;
    return CircleAvatar(
      radius: radius,
      backgroundColor: avatarColor,
      child: Text(
        name[0].toUpperCase(),
        style: textTheme.bodyLarge!.copyWith(color: JoblineColors.white),
      ),
    );
  }
}
