import 'package:go_router/go_router.dart';
import 'package:jobline/features/timeline/timeline_create.dart';
import 'package:jobline/screens/authentication/signin/login_page.dart';
import 'package:jobline/screens/authentication/signup/sign_up.dart';
import 'package:jobline/screens/error/error.dart';
import 'package:jobline/screens/splash/splash.dart';

/// Shared paths / urls used across the app
class ScreenPaths {
  static const String home = '/';
  static const String login = 'login';
  static const String signup = '/signup';
  static const String timeLine = '/timeline';
  static const String settings = 'settings';
  // static String wonderDetails(WonderType type, {int tabIndex = 0}) => '/wonder/${type.name}?t=$tabIndex';
  // static String video(String id) => '/video/$id';
  // static String highlights(WonderType type) => '/highlights/${type.name}';
  // static String search(WonderType type) => '/search/${type.name}';
  // static String artifact(String id) => '/artifact/$id';
  // static String collection(String id) => '/collection?id=$id';
  // static String maps(WonderType type) => '/maps/${type.name}';
  // static String timeline(WonderType? type) => '/timeline?type=${type?.name ?? ''}';
  // static String wallpaperPhoto(WonderType type) => '/wallpaperPhoto/${type.name}';
}

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      name: 'home',
      path: ScreenPaths.home,
      redirect: (context, state) {
        bool isAuthenticate = 2 == 2;
        // if (isAuthenticate) {
        //   return "/${ScreenPaths.timeLine}";
        // }
        return "/${ScreenPaths.login}";
      },
      builder: (context, state) => const SplashScreen(),
      routes: [
        GoRoute(
          name: 'login',
          path: ScreenPaths.login,
          builder: (context, state) => const LoginPage(),
        ),
      ],
    ),
    GoRoute(
      name: 'signup',
      path: ScreenPaths.signup,
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      name: 'timeline',
      path: ScreenPaths.timeLine,
      builder: (context, state) => const TimelineCreate(),
    )
  ],
  errorBuilder: (context, state) => const ErrorScreen(),
);
