import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medmap/cubit/signup/sign_up_page.dart';
import 'package:medmap/cubit/signin/sign_in_page.dart';
import 'package:medmap/views/dashboard.dart';
import 'package:medmap/views/submenu.dart';
import 'app_routes.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: AppRoutes.submenu,
      builder: (context, state) => Submenu(),
    ),
    GoRoute(
      path: AppRoutes.signUp,
      builder: (context, state) {
        return SignUpPage();
      },
    ),
    GoRoute(
      path: AppRoutes.signIn,
      builder: (context, state) {
        print('Sign-in route is being used');
        return SignInPage();
      },
    ),
    GoRoute(
      path: AppRoutes.dashboard,
      pageBuilder: (context, state) => MaterialPage(child: Dashboard()),
      // builder: (context, state) => DashboardPage(),
      // pageBuilder: (context, state) => MaterialPage(child: SignInPage()),
    ),
  ],
);
