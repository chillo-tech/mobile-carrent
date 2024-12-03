import '../flavors.env.dart';

class URLS {
  static final String BASE_URL = _getBaseUrl();

  static String _getBaseUrl() {
    switch (F.appFlavor) {
      case Flavor.internaltest:
        return 'https://api.carrent.chillo.fr/api/v1';
      case Flavor.production:
        return 'https://api.carrent.chillo.fr/api/v1';
      default:
        return 'https://api.carrent.chillo.fr/api/v1';
    }
  }

  // ------------------------------------------- Micro Services

  static String USER_MANAGEMENT = "$BASE_URL/"; // Externe
  // static String USER_MANAGEMENT = "$BASE_URL/users/"; // Externe
}
