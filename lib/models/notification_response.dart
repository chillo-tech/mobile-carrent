import 'dart:convert';

LocalNotificationResponse notificationResponseFromJson(String str) =>
    LocalNotificationResponse.fromJson(json.decode(str));

List<LocalNotificationResponse> notificationResponsefromJsonList(
    List<dynamic> jsonList) {
  return jsonList
      .map((json) => LocalNotificationResponse.fromJson(json))
      .toList();
}

class LocalNotificationResponse {
  final String? id;
  final String title;
  final String description;
  final String date;

  LocalNotificationResponse({
    this.id,
    required this.title,
    required this.description,
    required this.date,
  });

  // Méthode pour créer une instance à partir d'une map
  factory LocalNotificationResponse.fromJson(Map<String, dynamic> map) {
    return LocalNotificationResponse(
      id: map['title'].hashCode.toString(),
      title: map['title'] as String,
      description: map['description'] as String,
      date: map['date'] as String,
    );
  }

  // Méthode pour convertir l'instance en map
  Map<String, String> toJson() {
    return {
      'id': title.hashCode.toString(),
      'title': title,
      'description': description,
      'date': date,
    };
  }
}
