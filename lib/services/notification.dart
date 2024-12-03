import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/notification_response.dart';
import '../src/features/notifications/controllers/notifications_controller.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final NotificationsController notificationController =
      Get.put<NotificationsController>(NotificationsController());

  // Initialisation des notifications locales
  Future<void> initialize() async {
    await Firebase.initializeApp();

    // Initialiser les notifications locales
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    // var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      // iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Demander la permission pour iOS
    await _firebaseMessaging.requestPermission();

    // Obtenir le token d'enregistrement pour les notifications push
    _firebaseMessaging.getToken().then((String? token) {
      if (token != null) {
        print("Token FCM: $token");
        // Vous pouvez envoyer ce token à votre backend pour l'utiliser pour les notifications push ciblées
      }
    });

    // Écouter les notifications lorsque l'application est au premier plan
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(
          "Message reçu : ${message.notification?.title} - ${message.notification?.body}");
      _showLocalNotification(message);

      // Créer une notification et l'ajouter au NotificationController
      var notification = LocalNotificationResponse(
        title: message.notification?.title ?? "No Title",
        description: message.notification?.body ?? "No Body",
        date: DateTime.now().toString(),
      );
      notificationController.addNotification(notification);
    });

    // Gérer les notifications ouvertes lorsque l'application est en arrière-plan
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Notification ouverte : ${message.notification?.title}");
      _handleNotificationClick(message);
    });

    // Gérer les messages reçus quand l'application est complètement fermée
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  // Fonction pour afficher une notification locale
  Future<void> _showLocalNotification(RemoteMessage message) async {
    var androidDetails = AndroidNotificationDetails(
      message.hashCode.toString(),
      message.notification!.title!,
      channelDescription: message.notification!.body,
      importance: Importance.high,
      priority: Priority.high,
    );

    // var iOSDetails = IOSNotificationDetails();

    var platformDetails = NotificationDetails(
      android: androidDetails,
      // iOS: iOSDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title,
      message.notification?.body,
      platformDetails,
      payload: message.data
          .toString(), // Données supplémentaires dans la notification
    );
  }

  // Fonction pour gérer l'action après avoir cliqué sur une notification
  void _handleNotificationClick(RemoteMessage message) {
    // Vous pouvez ici naviguer vers une page ou effectuer une action spécifique
    print("Action après clic sur la notification");
    // Par exemple, vous pouvez naviguer vers une page spécifique
    // Navigator.pushNamed(context, '/specificPage');
  }

  // Fonction de gestion des messages reçus en arrière-plan
  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print("Message reçu en arrière-plan : ${message.notification?.title}");
    // Vous pouvez ici gérer des actions lorsque l'application est en arrière-plan
  }
}
