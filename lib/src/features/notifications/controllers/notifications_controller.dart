import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../common/storage_constants.dart';
import '../../../../models/notification_response.dart';

class NotificationsController extends GetxController {
  final RxList<LocalNotificationResponse> notifications =
      <LocalNotificationResponse>[].obs;
  final RxList<LocalNotificationResponse> storedNotifications =
      <LocalNotificationResponse>[].obs;

  final GetStorage _storage = GetStorage();
  static const String notificationsKey = StorageConstants.notifications;

  void addNotification(LocalNotificationResponse notification) {
    notifications.add(notification);
  }

  List<Map<String, String>> settingsLinks = [
    {
      'title': 'Message de bienvenue',
      'description': 'Bienvenue sur Carrent',
      'date': '25/09/2021 13:00',
    },
  ];

  @override
  void onInit() {
    super.onInit();
    notifications.addAll([
      LocalNotificationResponse(
        title: 'Message de bienvenue',
        description: 'Bienvenue sur Carrent',
        date: '25/09/2021 13:00',
      ),
    ]);
  }

  // Charger les notifications depuis GetStorage
  List<LocalNotificationResponse> loadNotifications() {
    var storedNotifications =
        _storage.read<List<dynamic>>(notificationsKey) ?? [];
    print(storedNotifications);
    return notificationResponsefromJsonList(storedNotifications);
  }

  // Sauvegarder les notifications dans GetStorage
  void saveNotifications() {
    List<Map<String, String>> notificationsToSave =
        notifications.map((notification) => notification.toJson()).toList();
    _storage.write(notificationsKey, notificationsToSave);
  }
}
