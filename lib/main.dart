import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
// import 'network/deep_link_middleware.dart';
import 'services/notification.dart';
// import 'src/features/notifications/controllers/notifications_controller.dart';
import 'theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logging/logging.dart';
import 'controllers/countries_controller.dart';
import 'routes/router.dart' as RouterFile;

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void _setupLogging() {
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init(); // initialize persistence storage
  _setupLogging();
  NotificationService().initialize();
  // DeeplinkMiddleware().initDeeplinks();
  // Get.put(NotificationsController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  CountriesController countriesController = Get.put(CountriesController());
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('fr', 'FR'),
      ],
      title: 'Car rental',
      theme: Themes.lightTheme,
      defaultTransition: Transition.downToUp,
      getPages: RouterFile.Router.route,
      initialRoute: '/splash', // /splash
    );
  }
}
