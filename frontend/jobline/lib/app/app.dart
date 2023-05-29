import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jobline/router.dart';
import 'package:jobline/screens/authentication/signin/login_page.dart';
import 'package:jobline/shared/data/authentication/authentication_repository.dart';
import 'package:jobline/theme.dart';
import 'package:jobline/widgets/animated_fade_in.dart';
import 'package:jobline/widgets/responsive_layout_builder.dart';

class App extends StatelessWidget {
  const App({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (ctx) => AuthenticationRepository()),
      ],
      child: AnimatedFadeIn(
        child: ResponsiveLayoutBuilder(
          small: (_, __) => _App(theme: JoblineTheme.small),
          medium: (_, __) => _App(theme: JoblineTheme.medium),
          large: (_, __) => _App(theme: JoblineTheme.standard),
        ),
      ),
    );
  }
}

class _App extends StatelessWidget {
  const _App({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Jobline',
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      theme: theme,
    );
  }
}
