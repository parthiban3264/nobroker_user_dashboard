import 'package:flutter/material.dart';
import 'package:noBroker_user_dashboard/views/dashboard/edit_user_screen.dart';
import 'package:noBroker_user_dashboard/views/dashboard/manage_user_screen.dart';
import '../views/auth/login_screen.dart';
import '../views/auth/register_screen.dart';
import '../views/dashboard/create_user_screen.dart';
import '../views/dashboard/dashboard_screen.dart';
import '../views/splash_screen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String manageUser = '/ManageUsersScreen';
  static const String createUser = '/createUser';
  static const String updateUser = '/updateUser';

  static final routes = <String, WidgetBuilder>{
    splash: (context) => const SplashScreen(),
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    dashboard: (context) => const DashboardScreen(),
    manageUser: (context) => const ManageUsersScreen(),
    createUser: (context) => const CreateUser(),
    updateUser: (context) => const EditUserScreen(),
  };
}
