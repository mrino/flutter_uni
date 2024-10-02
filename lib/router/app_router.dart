import 'package:go_router/go_router.dart';
import 'package:uniuni/router/app_screen.dart';
import 'package:uniuni/screens/login/login_screen.dart';
import 'package:uniuni/screens/main/main_screen.dart';

final appRouter = GoRouter(
  initialLocation: AppScren.login.toPath,
  routes: [
    // 로그인 화면
    GoRoute(
      path: AppScren.login.toPath,
      name: AppScren.login.name,
      builder: (context, state) => const LoginScreen(),
    ),
    //메인 화면
    GoRoute(
      path: AppScren.main.toPath,
      name: AppScren.main.name,
      builder: (context, state) => const MainScreen(),
    )
  ],
);
