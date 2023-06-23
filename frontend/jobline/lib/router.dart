import 'package:go_router/go_router.dart';
import 'package:jobline/features/timeline/timeline_create.dart';
import 'package:jobline/screens/authentication/signin/login_page.dart';
import 'package:jobline/screens/authentication/signup/sign_up.dart';
import 'package:jobline/screens/error/error.dart';
import 'package:jobline/screens/redirect/redirect_screen.dart';
import 'package:jobline/screens/splash/splash.dart';
import 'package:jobline/shared/utility.dart';

/// Shared paths / urls used across the app
class ScreenPaths {
  static const String home = '/';
  static const String login = 'login';
  static const String signup = '/signup';
  static const String timeLine = '/timeline/:timelineId';
  static const String settings = 'settings';
  static const String redirect = '/redirect';
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
        if (isAuthenticated()) {
          return "/${ScreenPaths.redirect}}";
        } else {
          return "/${ScreenPaths.login}";
        }

//refer sample code for redirect
        //     redirect: (context, state) {
        //   final userAutheticated = sessionCubit.state is Authenticated;
        //   if (userAutheticated) {
        //     if (state.subloc == '/login') return '/home';
        //     if (state.subloc == '/profile') return '/profile';
        //     if (state.subloc.contains('/order')) return '/order_history';
        //     return null;
        //   } else {
        //     if (state.subloc == '/profile' || state.subloc == '/order_history') {
        //       return '/login';
        //     } else {
        //       return null;
        //     }
        //   }
        // }
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
      name: 'redirect',
      path: ScreenPaths.redirect,
      builder: (context, state) => const RedirectScreen(),
    ),
    GoRoute(
      name: 'signup',
      path: ScreenPaths.signup,
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      name: 'timeline',
      path: ScreenPaths.timeLine,
      redirect: (context, state) {
        if (!isAuthenticated()) {
          return "/${ScreenPaths.login}";
        }
      },
      builder: (context, state) => TimelineCreate(
        timelineId: state.pathParameters['timelineId'] ?? " ",
      ),
    ),
  ],
  errorBuilder: (context, state) => const ErrorScreen(),
);
