import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:jobline/colors.dart';
import 'package:jobline/widgets/custom_button.dart';
import 'package:jobline/widgets/jobline_title.dart';

enum AppBarTypes { login, signup, common, general }

AppBar buildAppBarType(
    {required BuildContext context, required AppBarTypes type}) {
  switch (type) {
    case AppBarTypes.common:
      return AppBar(
        flexibleSpace: Container(
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: JoblineColors.neutralLight)))),
        title: const JoblineTitle(),
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
      );

    case AppBarTypes.signup:
      return AppBar(
        automaticallyImplyLeading: false,
        title: const JoblineTitle(),
        actions: [
          const Text("Don't have an account?"),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomButton(
              onPressFunction: () {
                context.go('/signup');
              },
              radius: 30,
              child: const Text('Sign up',
                  style: TextStyle(color: JoblineColors.white)),
            ),
          )
        ],
      );
    case AppBarTypes.login:
      return AppBar(
        automaticallyImplyLeading: false,
        title: const JoblineTitle(),
        actions: [
          const Text("Already have an account?"),
          Padding(
            padding: const EdgeInsets.all(9.0),
            child: CustomButton(
              onPressFunction: () {
                return context.goNamed('login');
              },
              radius: 30,
              child: const Text(
                'Sign in',
                style: TextStyle(color: JoblineColors.white),
              ),
            ),
          )
        ],
      );

    case AppBarTypes.general:
      return AppBar(
        automaticallyImplyLeading: false,
        title: const JoblineTitle(),
        actions: [
          TextButton(
            onPressed: () {
              return context.goNamed('signup');
            },
            child: const Text(
              'SIGN UP',
              style: TextStyle(color: JoblineColors.accentColor),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(9.0),
            child: CustomButton(
              onPressFunction: () {
                return context.goNamed('login');
              },
              radius: 30,
              child: const Text(
                'SIGN IN',
                style: TextStyle(color: JoblineColors.white),
              ),
            ),
          )
        ],
      );
    default:
      return AppBar();
  }
}
