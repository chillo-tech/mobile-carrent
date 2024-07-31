import 'package:carrent/views/home/home.dart';
import 'package:carrent/views/login/login.dart';
import 'package:get/route_manager.dart';

import 'views/splash/splash.dart';

class Router {
  static final route = [
    GetPage(name: '/splash', page: () => SplashScreen()),
    GetPage(name: '/login', page: () => const Login()),
    GetPage(name: '/home', page: () => const Home()),
  ];
}
