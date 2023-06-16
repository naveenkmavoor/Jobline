import 'package:flutter/material.dart';
import 'package:jobline/colors.dart';

Future<void> customAlertDialog({
  required BuildContext context,
  required List<Widget> actions,
  required Widget body,
  final String title = '',
  final String? iconAsset,
  final IconData? icon,
  final bool outsideDismissible = true,
  final bool barrierDismissible = true,
  final Color iconColor = JoblineColors.blue,
  final Function? popFunction,
}) async {
  final result = await showDialog(
    barrierDismissible: barrierDismissible,
    context: context,
    builder: (BuildContext context) {
      final textTheme = Theme.of(context).textTheme;
      return WillPopScope(
        onWillPop: () async {
          if (popFunction != null) {
            popFunction();
          }
          return outsideDismissible;
        },
        child: SimpleDialog(
          contentPadding: const EdgeInsets.all(25),
          elevation: 1,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          backgroundColor: JoblineColors.white,
          children: <Widget>[
            Row(
              children: [
                title.isNotEmpty
                    ? Expanded(
                        child: Text(
                          title,
                          style: textTheme.headlineMedium,
                        ),
                      )
                    : const SizedBox(),
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    iconSize: 20,
                    icon: const Icon(
                      Icons.close,
                      color: JoblineColors.neutral25,
                    ),
                    onPressed: () {
                      if (popFunction != null) {
                        popFunction();
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            body,
            actions.isNotEmpty
                ? const SizedBox(
                    height: 20,
                  )
                : const SizedBox(),
            ...actions,
          ],
        ),
      );
    },
  );

  return result;
}
