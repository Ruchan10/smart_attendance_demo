import 'package:Smart_Attendance/view/attendance_view.dart';
import 'package:Smart_Attendance/view/dashboard_view.dart';
import 'package:Smart_Attendance/view/forgot_password_view.dart';
import 'package:Smart_Attendance/view/home_view.dart';
import 'package:Smart_Attendance/view/login_view.dart';
import 'package:Smart_Attendance/view/settings_page.dart';
import 'package:Smart_Attendance/view/splash_view.dart';
import 'package:Smart_Attendance/view/terms_and_condition.dart';

class AppRoute {
  AppRoute._();

  static const String splashRoute = '/splash';
  static const String homeRoute = '/home';
  static const String attendenceRoute = '/att';
  static const String loginRoute = '/login';
  static const String forgotRoute = '/forgot';
  static const String settingRoute = '/setting';
  static const String navRoute = '/navRoute';
  static const String testRoute = '/test';
  static const String policyRoute = '/policy';

  static getAppRoutes() {
    return {
      homeRoute: (context) => const HomePageView(),
      splashRoute: (context) => const SplashView(),
      forgotRoute: (context) => const ForgotPassword(),
      loginRoute: (context) => const LoginPageView(),
      attendenceRoute: (context) => const WebAttendanceView(),
      settingRoute: (context) => const SettingsPage(),
      navRoute: (context) => const DashBoardView(),
      policyRoute: (context) => const TermsAndPoliciesPage(),
    };
  }
}
