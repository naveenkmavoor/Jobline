import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:jobline/colors.dart';
import 'package:jobline/config/constants.dart';
import 'package:jobline/features/authentication/sign_up/cubit/sign_up_cubit.dart';
import 'package:jobline/router.dart';
import 'package:jobline/shared/data/authentication/models/form_inputs/email.dart';
import 'package:jobline/widgets/custom_alert_dialog.dart';
import 'package:jobline/widgets/custom_button.dart';
import 'package:jobline/widgets/custom_snackbar.dart';
import 'package:jobline/widgets/custom_textfield.dart';

enum User { recruiter, candidate }

class SignUpForm extends StatefulWidget {
  final String? email;
  const SignUpForm({Key? key, this.email}) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final emailController = TextEditingController();
  final fnameController = TextEditingController();
  final passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _fnameFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  String? nameRequired;
  String? emailRequired = "Email is required";
  String? passwordRequired = "Password is required";
  final passwordMinChar = null;
  final passwordMaxChar = null;
  final passwordNumChar = null;
  int counter = 0;
  bool showpassword = false;
  User selectUser = User.recruiter;
  ScrollController _scrollController = ScrollController();

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
    if (widget.email != null) {
      emailController.text = widget.email!;
      context.read<SignUpCubit>().emailChanged(widget.email!);
    }
    emailController.text = widget.email ?? "";
    _fnameFocusNode.addListener(() {
      if (!_fnameFocusNode.hasFocus) {
        context.read<SignUpCubit>().onFnameUnfocused();
      }
    });
    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        context.read<SignUpCubit>().onEmailUnfocused();
      }
    });
    _passwordFocusNode.addListener(() {
      if (counter != 0) return;
      if (_passwordFocusNode.hasFocus) {
        counter = 1;
        context.read<SignUpCubit>().onPasswordFocused();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    fnameController.dispose();
    _scrollController.dispose();
    passwordController.dispose();
    _fnameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  // Widget _buildPasswordErrorText(SignUpState state, String text) {
  //   return counter != 0
  //       ? Row(
  //           children: [
  //             state.passVal == PasswordError.bothtrue ||
  //                     state.passVal == PasswordError.onetrueotherfalse
  //                 ? const Icon(
  //                     Icons.check,
  //                     color: JoblineColors.green,
  //                     size: 20,
  //                   )
  //                 : state.password.pure && state.password.value == "e"
  //                     ? const Bullet(
  //                         color: JoblineColors.neutral50,
  //                         size: 6,
  //                       )
  //                     : const Icon(
  //                         Icons.close,
  //                         color: JoblineColors.red25,
  //                         size: 20,
  //                       ),
  //             const SizedBox(width: 10),
  //             Text(
  //               text,
  //               style: Theme.of(context).textTheme.labelLarge!.copyWith(
  //                     color: state.passVal == PasswordError.bothtrue ||
  //                             state.passVal == PasswordError.onetrueotherfalse
  //                         ? JoblineColors.green
  //                         : state.password.pure
  //                             ? JoblineColors.neutral25
  //                             : JoblineColors.red25,
  //                   ),
  //             ),
  //           ],
  //         )
  //       : const SizedBox();
  // }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          if (state.errorMessage == "email_exists") {
            customAlertDialog(
                context: context,
                actions: [
                  CustomButton(
                      onPressFunction: () {
                        context.go(ScreenPaths.login);
                      },
                      child: const Text("Login")),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomButton(
                    onPressFunction: () {
                      Navigator.pop(context);
                      FocusScope.of(context).requestFocus(_emailFocusNode);
                    },
                    child: const Text("Use a different mail id"),
                  ),
                ],
                body: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: state.email.value,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: JoblineColors.blue)),
                  TextSpan(
                      text: " is already registered with us. Try logging in.",
                      style:
                          Theme.of(context).textTheme.titleMedium!.copyWith()),
                ])));
          } else {
            customSnackBar(
                context: context,
                snackBarType: SnackBarType.error,
                title: state.errorMessage == "validation error"
                    ? "Your password doesn't meet the requirements"
                    : state.errorMessage ?? Constants.somethingWentWrong);
          }
        }
        if (state.status.isSubmissionSuccess) {
          customSnackBar(
              context: context,
              snackBarType: SnackBarType.info,
              title: "Account creation successful.");
          return context.goNamed('timeline');
        }
      },
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Align(
          alignment: Alignment.center,
          child: Container(
            constraints: const BoxConstraints(minWidth: 100, minHeight: 100),
            width: 500,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Header
                Text(
                  'Sign up',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const Text('Sign up to your Jobline account'),
                const SizedBox(
                  height: 20,
                ),
                // form
                BlocBuilder<SignUpCubit, SignUpState>(
                  buildWhen: (previous, current) =>
                      previous.fname != current.fname,
                  builder: (context, state) {
                    return CustomTextField(
                      focusNode: _fnameFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_emailFocusNode);
                      },
                      focus: true,
                      label: 'Full name',
                      type: InputType.text,
                      textInputAction: TextInputAction.next,
                      onChanged: (value) {
                        context
                            .read<SignUpCubit>()
                            .fnameChanged(value?.trim() ?? "");
                      },
                      controller: fnameController,
                      hintText: 'Enter your full name',
                      variant: Variant.filled,
                      fillColor: JoblineColors.neutralLight,
                      borderColor: JoblineColors.transparent,
                      inputColor: JoblineColors.accentColor,
                      errorText:
                          state.fname.invalid ? "Full Name is required" : null,
                    );
                  },
                ),
                SizedBox(height: 16),
                BlocBuilder<SignUpCubit, SignUpState>(
                  buildWhen: (previous, current) =>
                      previous.email != current.email,
                  builder: (context, state) {
                    return CustomTextField(
                        label: 'Email ID',
                        focusNode: _emailFocusNode,
                        type: InputType.email,
                        controller: emailController,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_passwordFocusNode);
                        },
                        hintText: 'johndoe@gmail.com',
                        variant: Variant.filled,
                        textInputAction: TextInputAction.next,
                        onChanged: (value) {
                          context
                              .read<SignUpCubit>()
                              .emailChanged(value?.trim() ?? "");
                        },
                        fillColor: JoblineColors.neutralLight,
                        borderColor: JoblineColors.transparent,
                        inputColor: JoblineColors.accentColor,
                        errorText: state.email.invalid
                            ? _showEmailErrorMessage(state.email.error)
                            : null);
                  },
                ),
                SizedBox(height: 16),
                BlocBuilder<SignUpCubit, SignUpState>(
                  buildWhen: (previous, current) =>
                      previous.password != current.password,
                  builder: (context, state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                          label: 'Password',
                          focusNode: _passwordFocusNode,
                          type: InputType.password,
                          controller: passwordController,
                          textInputAction: TextInputAction.done,
                          tap: () {
                            _scrollController.animateTo(
                                MediaQuery.of(context).viewInsets.bottom,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.ease);
                          },
                          onChanged: (value) {
                            context.read<SignUpCubit>().passwordChanged(value!);
                          },
                          hintText: 'Enter your password',
                          variant: Variant.filled,
                          fillColor: JoblineColors.neutralLight,
                          borderColor: JoblineColors.transparent,
                          inputColor: JoblineColors.accentColor,
                          obscureText: !showpassword,
                          errorText: state.password.invalid
                              ? "Password is required"
                              : null,
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
                                color: JoblineColors.lightThemeOutline),
                          ),
                        ),
                        SizedBox(height: 8),
                        // counter != 0
                        //     ? Row(
                        //         children: [
                        //           state.passVal ==
                        //                       PasswordError.bothtrue ||
                        //                   state.passVal ==
                        //                       PasswordError
                        //                           .onetrueotherfalse
                        //               ? const Icon(
                        //                   Icons.check,
                        //                   color: JoblineColors.lightThemeOutline
                        //                 )
                        //               : state.password.pure
                        //                   ? const Bullet(
                        //                       color:
                        //                           JoblineColors.green,
                        //                       size: 6,
                        //                     )
                        //                   : const Icon(
                        //                       Icons.close,
                        //                       color: JoblineColors.error,
                        //                       size: 20,
                        //                     ),
                        //           const SizedBox(width: 10),
                        //           Text(
                        //             'Must be between 6-20 characters long.',
                        //             style: Theme.of(context)
                        //                 .textTheme
                        //                 .labelLarge!
                        //                 .copyWith(
                        //                   color: state.passVal ==
                        //                               PasswordError
                        //                                   .bothtrue ||
                        //                           state.passVal ==
                        //                               PasswordError
                        //                                   .onetrueotherfalse
                        //                       ? JoblineColors.green
                        //                       : state.password.pure
                        //                           ? JoblineColors
                        //                               .lightThemeOutline
                        //                           : JoblineColors.error,
                        //                 ),
                        //           ),
                        //         ],
                        //       )
                        //     : const SizedBox(),
                        // counter != 0
                        //     ? Row(
                        //         children: [
                        //           state.passVal ==
                        //                       PasswordError.bothtrue ||
                        //                   state.passVal ==
                        //                       PasswordError
                        //                           .othertrueonefalse
                        //               ? const Icon(
                        //                   Icons.check,
                        //                   color: JoblineColors.green,
                        //                   size: 20,
                        //                 )
                        //               : state.password.pure
                        //                   ? const Bullet(
                        //                       color:
                        //                           JoblineColors.neutral50,
                        //                       size: 6,
                        //                     )
                        //                   : const Icon(
                        //                       Icons.close,
                        //                       color: JoblineColors.red25,
                        //                       size: 20,
                        //                     ),
                        //           const SizedBox(width: 10),
                        //           Text(
                        //             'Use numbers (0-9) & letters(A-Z)',
                        //             style: Theme.of(context)
                        //                 .textTheme
                        //                 .labelLarge!
                        //                 .copyWith(
                        //                   color: state.passVal ==
                        //                               PasswordError
                        //                                   .bothtrue ||
                        //                           state.passVal ==
                        //                               PasswordError
                        //                                   .othertrueonefalse
                        //                       ? JoblineColors.green50
                        //                       : state.password.pure
                        //                           ? JoblineColors
                        //                               .neutral25
                        //                           : JoblineColors.red25,
                        //                 ),
                        //           ),
                        //         ],
                        //       )
                        // : const SizedBox(),
                      ],
                    );
                  },
                ),
                const SizedBox(
                  height: 7,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Account type'),
                ),
                const SizedBox(
                  height: 7,
                ),
                Row(
                  children: [
                    Expanded(
                      child: SegmentedButton<User>(
                        segments: const <ButtonSegment<User>>[
                          ButtonSegment<User>(
                            value: User.recruiter,
                            label: Text('Recruiter'),
                          ),
                          ButtonSegment<User>(
                            value: User.candidate,
                            label: Text('Candidate'),
                          ),
                        ],
                        selected: <User>{selectUser},
                        onSelectionChanged: (Set<User> newSelection) {
                          setState(() {
                            // By default there is only a single segment that can be
                            // selected at one time, so its value is always the first
                            // item in the selected set.
                            selectUser = newSelection.first;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),

                BlocBuilder<SignUpCubit, SignUpState>(
                  builder: (context, state) {
                    return Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            state: state.status.isSubmissionInProgress
                                ? ButtonState.loading
                                : ButtonState.enabled,
                            onPressFunction: () async {
                              context
                                  .read<SignUpCubit>()
                                  .signUpFormSubmitted(selectUser.name);
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(9.0),
                              child: Text(
                                'Sign up',
                                style: TextStyle(color: JoblineColors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
