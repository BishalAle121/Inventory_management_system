// Dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/application/providers/auth_provider.dart';
import '../../features/auth/application/states/auth_state.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/forgot_password/presentation/OtpVerificationScreen/otp_verification_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';

import '../../features/installation/prestntation/screens/installation_screen.dart';
import '../../features/project_inventory_history/prestntation/screens/inventory_hostory.dart';
import '../../features/register/presentation/screens/registration_screen.dart';
import '../../features/shared/components/component_button_navigation_bar.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/stock_in_and_out/prestntation/screens/stockinoutscreen.dart';
import '../exceptions/navigation_error_handler.dart';

// App-level GoRouter provider
final routerProvider = Provider<GoRouter>((ref) {
  final router = RouterNotifier(ref);

  return GoRouter(
    refreshListenable: router,
    debugLogDiagnostics: true,
    initialLocation: '/splash',
    routes: [
      // Public / top-level routes
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/register',
        builder: (context, state) => RegistrationScreen(),
      ),
      GoRoute(
        path: '/otp_verification',
        builder: (context, state) => const OtpVerifyScreen(),
      ),
      // GoRoute(
      //   path: '/ResetPasswordScreen',
      //   builder: (context, state) => const ResetPasswordScreen(),
      // ),

      // ShellRoute: persistent bottom navigation with nested tab routes
      ShellRoute(
        builder: (context, state, child) => Scaffold(
          body: child,
          bottomNavigationBar: const CustomBottomNavigationBar(),
        ),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/stock-in-out',
            builder: (context, state) => const StockInOutScreen(),
          ),
          GoRoute(
            path: '/installation',
            builder: (context, state) => const InstallationScreen(),
          ),
          GoRoute(
            path: '/history',
            builder: (context, state) => const InventoryHistory(),
          ),
        ],
      ),
      // other non-shell protected routes can go here
    ],
    redirect: router._redirect,
    errorBuilder: NavigationErrorHandler.errorScreen,
    observers: [NavigationObserver()],
  );
});

class NavigationObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    debugPrint('Navigation: Pushed ${route.settings.name}');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    debugPrint('Navigation: Popped ${route.settings.name}');
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    debugPrint('Navigation: Removed ${route.settings.name}');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    debugPrint(
      'Navigation: Replaced ${oldRoute?.settings.name} with ${newRoute?.settings.name}',
    );
  }

  @override
  void didStartUserGesture(
    Route<dynamic> route,
    Route<dynamic>? previousRoute,
  ) {
    debugPrint('Navigation: Started gesture on ${route.settings.name}');
  }
}

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;
  bool _isAuth = false;

  RouterNotifier(this._ref) {
    _ref.listen(authProvider, (_, state) {
      if (state is AuthAuthenticated != _isAuth) {
        _isAuth = state is AuthAuthenticated;
        notifyListeners();
      }
    });
  }

  // redirect logic: keep splash accessible; if not authenticated and
  // requesting a non-public route, send to /login
  String? _redirect(BuildContext context, GoRouterState state) {
    try {
      final path = state.matchedLocation;

      if (path == '/splash') return null;

      if (!_isAuth && !_isPublicRoute(path)) {
        return '/login';
      }

      // if authenticated and on an auth route (optional) you could redirect to home
      if (_isAuth && _isAuthRoute(path)) {
        // return '/home';
        return '/home';
      }

      return null;
    } catch (e, stackTrace) {
      debugPrint('Navigation error: $e\n$stackTrace');
      return '/error';
    }
  }

  bool _isPublicRoute(String path) {
    return [
      '/splash',
      '/login',
      '/register',
      '/forgot-password',
      '/otp_verification',
      '/ResetPasswordScreen',
    ].contains(path);
  }

  bool _isAuthRoute(String path) {
    return ['/login', '/register'].contains(path);
  }
}
