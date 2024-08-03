import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medmap/cubit/partnership/request_page.dart';
import 'package:medmap/cubit/signup/sign_up_page.dart';
import 'package:medmap/cubit/signin/sign_in_page.dart';
import 'package:medmap/cubit/submenu/submenu_page.dart';
import 'package:medmap/main.dart';
import 'package:medmap/views/dashboard.dart';
import 'app_routes.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: AppRoutes.partnership,
      builder: (context, state) => RequestPage(),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => HomePage(),
    ),
    GoRoute(
      path: AppRoutes.dashboard,
      builder: (context, state) => Dashboard(),
    ),
    GoRoute(
      path: AppRoutes.submenu,
      builder: (context, state) => SubmenuPage(),
    ),
    GoRoute(
      path: AppRoutes.signUp,
      builder: (context, state) => SignUpPage(),
    ),
    GoRoute(
      path: AppRoutes.signIn,
      builder: (context, state) {
        return SignInPage();
      },
    ),
  ],
  errorPageBuilder: (context, state) {
    return MaterialPage(child: HomePage());
  },
);