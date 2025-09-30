import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:jobline/colors.dart';
import 'package:jobline/shared/utility.dart';
import 'package:jobline/widgets/custom_avatar.dart';
import 'package:jobline/widgets/custom_button.dart';
import 'package:jobline/widgets/jobline_title.dart';

enum AppBarTypes { login, signup, common, general }

// This is the type used by the popup menu below.
enum PopMenuItems { signOut }

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
          Padding(
            padding: EdgeInsets.all(8.0),
            child: PopupMenuButton<PopMenuItems>(
                tooltip: 'Profile',
                icon: CustomAvatar(
                  name: getUserName() ?? ' ',
                ),
                itemBuilder: (context) => [
                      const PopupMenuItem<PopMenuItems>(
                        value: PopMenuItems.signOut,
                        child: Text('Sign out'),
                      ),
                    ],
                onSelected: (PopMenuItems result) {
                  if (result == PopMenuItems.signOut) {
                    signOut(context);
                  }
                }),
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
              child: const Text(
                'Sign up',
              ),
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
              child: const Text(
                'Sign in',
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
          OutlinedButton(
            onPressed: () {
              return context.goNamed('signup');
            },
            child: const Text(
              'SIGN UP',
              style: TextStyle(color: JoblineColors.primaryColor),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(9.0),
            child: CustomButton(
              onPressFunction: () {
                return context.goNamed('login');
              },
              child: const Text(
                'SIGN IN',
              ),
            ),
          )
        ],
      );
    default:
      return AppBar();
  }
}

void signOut(BuildContext context) {
  clearDb().then((value) => context.goNamed(
        'login',
      ));
}
