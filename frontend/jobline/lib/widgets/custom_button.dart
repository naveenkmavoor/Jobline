import 'package:flutter/material.dart';

typedef OnPressFunction = Function();

enum ButtonState { enabled, loading, failure, success, disabled }

enum ButtonVariant { primary, secondary, tertiary, outlined }

class CustomButton extends StatelessWidget {
  final OnPressFunction onPressFunction;
  final Widget child;
  final ButtonState state;
  final Color? backgroundColor;
  final OutlinedBorder? shape;
  const CustomButton(
      {super.key,
      required this.onPressFunction,
      required this.child,
      this.backgroundColor,
      this.shape,
      this.state = ButtonState.enabled});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          shape: shape, backgroundColor: backgroundColor),
      onPressed: onPressFunction,
      child: state == ButtonState.enabled
          ? child
          : const CircularProgressIndicator(),
    );
  }
}

class JerkingButton extends StatefulWidget {
  final bool isJerking;
  const JerkingButton({this.isJerking = false});
  @override
  _JerkingButtonState createState() => _JerkingButtonState();
}

class _JerkingButtonState extends State<JerkingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Function to trigger the button jerking animation
  void triggerAnimation() {
    _animationController.reset();
    _animationController.forward();
    _animationController.isCompleted ? _animationController.reverse() : null;
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: Duration(seconds: 1),
      builder: (context, value, child) {
        return Transform.translate(offset: Offset(value * 10, 0.0));
      },
      tween: Tween(begin: 1.0, end: 0.0),
      curve: Curves.elasticOut,
      child: ElevatedButton(
        onPressed: () {
          // Handle button press
        },
        child: Text('Button'),
      ),
    );
  }
}
