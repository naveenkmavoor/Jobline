import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jobline/colors.dart';
import 'package:jobline/features/authentication/sign_up/cubit/sign_up_cubit.dart';
import 'package:jobline/features/authentication/sign_up/view/signup_form.dart';
import 'package:jobline/shared/data/authentication/authentication_repository.dart';
import 'package:jobline/widgets/custom_button.dart';

class SignUpScreen extends StatelessWidget {
  static const routeName = '/signup';
  final String? email;
  const SignUpScreen({Key? key, this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            'Jobline',
          ),
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
        ),
        body: SafeArea(
          child: BlocProvider(
            create: (_) =>
                SignUpCubit(context.read<AuthenticationRepository>()),
            child: SignUpForm(
              email: email,
            ),
          ),
        ),
      ),
    );
  }
}
