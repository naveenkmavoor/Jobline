import 'package:flutter/material.dart';
import 'package:flash/flash.dart';
import 'package:jobline/colors.dart';

enum SnackBarType {
  success,
  error,
  warning,
  info,
  custom,
}

void customSnackBar(
    {required final BuildContext context,
    final Color? bgColor,
    final Color? foregroundColor,
    required final SnackBarType snackBarType,
    required final String title,
    final String? text,
    final IconData? icon,
    final Widget? iconWidget,
    final int duration = 4}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  showFlash(
    context: context,
    duration: Duration(seconds: duration),
    builder: (context, controller) {
      return Flash(
        controller: controller,
        position: FlashPosition.bottom,
        dismissDirections: const [FlashDismissDirection.startToEnd],
        child: FlashBar(
          controller: controller,
          icon: iconWidget,
          behavior: FlashBehavior.floating,
          elevation: 0.5,
          backgroundColor: bgColor,
          margin: const EdgeInsets.symmetric(horizontal: 12),
          title: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      title,
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge!
                          .copyWith(color: JoblineColors.primaryColor),
                    ),
                  ),
                  InkWell(
                    child: const Icon(
                      Icons.close,
                      color: JoblineColors.black,
                      size: 20,
                    ),
                    onTap: () {
                      controller.dismiss();
                    },
                  )
                ],
              )),
          content: text == null
              ? const SizedBox()
              : Text(
                  text,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: JoblineColors.black),
                ),
        ),
      );
    },
  );
}
