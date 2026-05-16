import 'package:flutter/material.dart';
import '../Screens/login_screen.dart';
import '../Screens/signup_screen.dart';
import '../Screens/home_screen.dart';
import '../Screens/detail_screen.dart';
import '../Screens/my_list_screen.dart';
import '../models/media_item.dart';
import 'app_routes.dart';

class RouterGenerator {
  static Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case AppRoutes.signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());

      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case AppRoutes.detail:
        final item = settings.arguments as MediaItem;
        return MaterialPageRoute(
          builder: (_) => DetailScreen(item: item),
        );

      case AppRoutes.myList:
        return MaterialPageRoute(builder: (_) => const MyListScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('No Route Found')),
          ),
        );
    }
  }
}
