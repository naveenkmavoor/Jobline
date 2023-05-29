import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jobline/colors.dart';
import 'package:jobline/features/authentication/login/login.dart';
import 'package:jobline/shared/data/authentication/authentication_repository.dart';
import 'package:jobline/widgets/custom_button.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';
  const LoginPage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: LoginPage());

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text(
              'Jobline',
            ),
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
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: BlocProvider(
                create: (_) =>
                    LoginCubit(context.read<AuthenticationRepository>()),
                child: LoginForm(),
              ),
            ),
          ),
        );
      }),
    );
  }
}
