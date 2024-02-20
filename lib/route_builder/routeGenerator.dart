import 'package:assingment/Authentication/login_register.dart';
import 'package:assingment/Splash/splash_screen.dart';
import 'package:assingment/components/page_routeBuilder.dart';
import 'package:assingment/screen/cities_page.dart';
import 'package:assingment/screen/ev_dashboard.dart';
import 'package:assingment/screen/demand%20energy%20management/demandScreen.dart';
import 'package:assingment/screen/split_dashboard/split_dashboard.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/evDashboard':
        String userId = settings.arguments.toString();
        return CustomPageRoute(page: EvDashboardScreen(userId: userId));

      case '/demand':
        String userId = settings.arguments.toString();
        return CustomPageRoute(
            page: DemandEnergyScreen(
          userId: userId,
        ));

      case '/cities':
        return CustomPageRoute(page: const CitiesPage());

      case '/login':
        return MaterialPageRoute(builder: (context) => LoginRegister());
      // CustomPageRoute(page: const LoginRegister());

      case '/splash':
        return CustomPageRoute(page: const SplashScreen());

      case '/splitDashboard':
        String userId = settings.arguments.toString();
        return CustomPageRoute(
            page: SplitDashboard(
          userId: userId,
        ));
    }
    return CustomPageRoute(
        page: SplitDashboard(
      userId: 'Default Id',
    ));
  }
}
