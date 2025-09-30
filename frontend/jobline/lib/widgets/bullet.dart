import 'package:flutter/material.dart';
import 'package:jobline/colors.dart';

class Bullet extends StatelessWidget {
  final Color color;
  final double size;
  const Bullet(
      {Key? key, this.color = JoblineColors.lightThemeOutline, this.size = 10})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
