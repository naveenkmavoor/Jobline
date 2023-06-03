import 'package:flutter/material.dart';

typedef OnPressFunction = Function();

enum ButtonState { enabled, loading, failure, success, disabled }

enum ButtonVariant { primary, secondary, tertiary, outlined }

class CustomButton extends StatelessWidget {
  final OnPressFunction onPressFunction;
  final Widget child;
  final ButtonState state;
  final Color? backgroundColor;
  final double radius;
  const CustomButton(
      {super.key,
      required this.onPressFunction,
      required this.child,
      this.backgroundColor,
      this.radius = 5,
      this.state = ButtonState.enabled});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          backgroundColor: backgroundColor),
      onPressed: onPressFunction,
      child: state == ButtonState.enabled
          ? child
          : const CircularProgressIndicator(),
    );
  }
}
