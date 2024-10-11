import 'package:go_router/go_router.dart';
import 'package:uniuni/common/helpers/storage_helper.dart';
import 'package:uniuni/router/app_screen.dart';
import 'package:uniuni/screens/login/login_screen.dart';
import 'package:uniuni/screens/main/main_screen.dart';
import 'package:uniuni/screens/setting/setting_screen.dart';

final appRouter = GoRouter(
  initialLocation: AppScreen.login.toPath,
  redirect: (context, state) {
    if (state.fullPath == AppScreen.login.toPath) {
      return null;
    }
    if (StorageHelper.authData == null) {
      return AppScreen.login.toPath;
    }
    return null;
  },
  routes: [
    // 로그인 화면
    GoRoute(
      path: AppScreen.login.toPath,
      name: AppScreen.login.name,
      builder: (context, state) => const LoginScreen(),
    ),
    //메인 화면
    GoRoute(
      path: AppScreen.main.toPath,
      name: AppScreen.main.name,
      pageBuilder: (context, state) => const NoTransitionPage(
        child: MainScreen(),
      ),
    ),
    GoRoute(
      path: AppScreen.setting.toPath,
      name: AppScreen.setting.name,
      pageBuilder: (context, state) => const NoTransitionPage(
        child: SettingScreen(),
      ),
    )
  ],
);
