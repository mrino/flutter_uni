enum AppScren {
  login,
  main,
}

extension AppScreenExtension on AppScren {
  String get toPath {
    switch (this) {
      case AppScren.login:
        return '/login';
      case AppScren.main:
        return '/main';
    }
  }
}
