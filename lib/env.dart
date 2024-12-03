import 'helpers/urls.dart';

class Env {
  static String getEnv([String defaultValue = ""]) {
    switch (URLS.BASE_URL) {
      case "https://api.carrent.chillo.fr/api/v1":
        return 'TEST INTERNE V.1.0.0';
      default:
        return defaultValue;
    }
  }

  static String getUserManagementApiBaseUrl() {
    String url = URLS.USER_MANAGEMENT;

    return url;
  }
}
