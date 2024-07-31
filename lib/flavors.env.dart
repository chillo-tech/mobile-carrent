enum Flavor {
  internaltest,
  production,
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.internaltest:
        return 'CAR RENTAL';
      case Flavor.production:
        return 'CAR RENTAL';
      default:
        return 'title';
    }
  }
}
