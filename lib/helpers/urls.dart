import '../flavors.env.dart';

class URLS {
  static final String BASE_URL = _getBaseUrl();

  static String _getBaseUrl() {
    switch (F.appFlavor) {
      case Flavor.internaltest:
        return 'http://test.com';
      case Flavor.production:
        return 'https://prod.com';
      default:
        return 'http://172.26.5.28';
    }
  }

  // ------------------------------------------- Micro Services

  static String KEY_CLOAK_STAGING_URL = "$BASE_URL/user-management/"; // Externe
}
