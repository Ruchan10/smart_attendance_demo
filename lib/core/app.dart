import 'package:flutter/material.dart';
import 'package:Smart_Attendance/core/app_routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Attendance',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorKey: MyApp.navigatorKey,
      initialRoute: AppRoute.splashRoute,
      routes: AppRoute.getAppRoutes(),
    );
  }
}
