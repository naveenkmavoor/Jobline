import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:jobline/colors.dart';
import 'package:jobline/config/constants.dart';
import 'package:jobline/features/authentication/login/login.dart';
import 'package:jobline/shared/data/authentication/models/form_inputs/email.dart';

import 'package:jobline/widgets/custom_alert_dialog.dart';
import 'package:jobline/widgets/custom_button.dart';
import 'package:jobline/widgets/custom_snackbar.dart';
import 'package:jobline/widgets/custom_textfield.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String? nameRequired;
  String? emailRequired = 'Email is required';
  String? passwordRequired = 'Password is required';
  final passwordMinChar = null;
  final passwordMaxChar = null;
  final passwordNumChar = null;
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  bool showpassword = false;
  bool useEmail = true;

  String _showEmailErrorMessage(EmailValidationError? error) {
    switch (error) {
      case EmailValidationError.invalid:
        return 'Invalid Email';
      case EmailValidationError.empty:
        return 'Email is Required';
      default:
        return 'Invalid Email';
    }
  }

  @override
  void initState() {
    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        context.read<LoginCubit>().onEmailUnfocused();
      }
    });
    _passwordFocusNode.addListener(() {
      if (!_passwordFocusNode.hasFocus) {
        context.read<LoginCubit>().onPasswordUnfocused();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  // String deviceIdd = "";
  // Future<void> deviceId() async {
  //   deviceIdd = (await getUserDeviceId())!;
  //   setState(() {});
  //   log(deviceIdd);
  //   return;
  // }

  @override
  void didChangeDependencies() {
    // deviceId();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          if (state.errorMessage == "email_not_found") {
            customAlertDialog(
                context: context,
                actions: [
                  CustomButton(
                      onPressFunction: () {
                        emailController.clear();
                        passwordController.clear();
                        FocusScope.of(context).requestFocus(_emailFocusNode);
                        Navigator.pop(context);
                      },
                      child: const Text("Use a different mail id")),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomButton(
                      onPressFunction: () {
                        context.goNamed('signup');
                      },
                      child: const Text("Create your Jobline account"))
                ],
                body: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                    text: state.email.value,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  const TextSpan(
                    text: " isn't registered with us",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ])));
          } else {
            customSnackBar(
                context: context,
                snackBarType: SnackBarType.error,
                title: state.errorMessage ?? Constants.somethingWentWrong);
          }
        }
        if (state.status.isSubmissionSuccess) {
          context.goNamed('timeline', pathParameters: {'timelineId': " "});
          customSnackBar(
              context: context,
              snackBarType: SnackBarType.info,
              title: "Successfully logged in.");
        }
      },
      child: Align(
        alignment: Alignment.center,
        child: Container(
          constraints: const BoxConstraints(minWidth: 100, minHeight: 100),
          width: 500,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Sign in',
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge!
                      .copyWith(fontSize: 33),
                ),
                const Text('Sign in to your Jobline account'),
                const SizedBox(
                  height: 20,
                ),
                BlocBuilder<LoginCubit, LoginState>(
                  buildWhen: (previous, current) =>
                      previous.email != current.email,
                  builder: (context, state) {
                    return CustomTextField(
                        focusNode: _emailFocusNode,
                        borderRadius: 10,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_passwordFocusNode);
                        },
                        focus: true,
                        textInputAction: TextInputAction.next,
                        label: 'Email ID',
                        type: InputType.email,
                        onChanged: (value) {
                          BlocProvider.of<LoginCubit>(context)
                              .emailChanged(value?.trim() ?? "");
                        },
                        controller: emailController,
                        hintText: 'Enter your email',
                        variant: Variant.filled,
                        onSaved: (value) {
                          context.read<LoginCubit>().emailChanged(value!);
                        },
                        fillColor: JoblineColors.neutralLight,
                        borderColor: JoblineColors.transparent,
                        inputColor: JoblineColors.primaryColor,
                        errorText: state.email.invalid && state.showTextFieldErr
                            ? _showEmailErrorMessage(state.email.error)
                            : null);
                  },
                ),
                const SizedBox(height: 10),
                BlocBuilder<LoginCubit, LoginState>(
                  buildWhen: (previous, current) =>
                      previous.password != current.password,
                  builder: (context, state) {
                    return CustomTextField(
                      focusNode: _passwordFocusNode,
                      borderRadius: 10,
                      textInputAction: TextInputAction.done,
                      focus: false,
                      label: 'Password',
                      type: InputType.password,
                      controller: passwordController,
                      hintText: 'Enter your password',
                      onChanged: (value) {
                        context.read<LoginCubit>().emailPasswordChanged(value!);
                      },
                      variant: Variant.filled,
                      fillColor: JoblineColors.neutralLight,
                      borderColor: JoblineColors.transparent,
                      inputColor: JoblineColors.primaryColor,
                      obscureText: !showpassword,
                      errorText:
                          state.password.invalid ? passwordRequired : null,
                      suffix: InkWell(
                        onTap: () {
                          setState(() {
                            showpassword = !showpassword;
                          });
                        },
                        child: Icon(
                          showpassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: JoblineColors.primaryColor,
                        ),
                      ),
                    );
                  },
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Forgot password?',
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              color: JoblineColors.lightThemeOutline,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                BlocBuilder<LoginCubit, LoginState>(
                  buildWhen: (previous, current) =>
                      previous.status != current.status,
                  builder: (context, state) {
                    return Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            state: state.status.isSubmissionInProgress
                                ? ButtonState.loading
                                : ButtonState.enabled,
                            onPressFunction: () {
                              context.read<LoginCubit>().logInWithCredentials(
                                    useEmail,
                                  );
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(9.0),
                              child: Text(
                                'Sign in',
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ]),
        ),
      ),
    );
  }
}
