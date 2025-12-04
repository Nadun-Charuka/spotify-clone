import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotify_client/features/auth/view/pages/login_page.dart';
import 'package:spotify_client/features/auth/view/pages/signup_page.dart';
import 'package:spotify_client/home/view/home_page.dart';
import 'package:spotify_client/features/auth/view_model/auth_view_model.dart';

final routerProvider = Provider<GoRouter>((ref) {
  // Watch the user state. If this changes, the router rebuilds/redirects
  final user = ref.watch(currentUserNotifierProvider);

  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupPage(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),
    ],

    // THE MAGIC HAPPENS HERE
    redirect: (context, state) {
      // Is the user logged in?
      final isLoggedIn = user != null;

      // Where is the user trying to go?
      final isLoggingIn = state.uri.toString() == '/login';
      final isSigningUp = state.uri.toString() == '/signup';

      // 1. If user is NOT logged in, but tries to go to Home, send to Login
      if (!isLoggedIn && !isLoggingIn && !isSigningUp) {
        return '/login';
      }

      // 2. If user IS logged in, but is on Login/Signup page, send to Home
      if (isLoggedIn && (isLoggingIn || isSigningUp)) {
        return '/home';
      }

      // 3. Otherwise, let them go where they want
      return null;
    },
  );
});
