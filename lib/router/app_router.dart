import 'package:easy_extension/easy_extension.dart';
import 'package:go_router/go_router.dart';
import 'package:uniuni/common/helpers/storage_helper.dart';
import 'package:uniuni/router/app_screen.dart';
import 'package:uniuni/screens/chat/chat_screen.dart';
import 'package:uniuni/screens/login/login_screen.dart';
import 'package:uniuni/screens/rooms/rooms_screen.dart';
import 'package:uniuni/screens/users/users_screen.dart';
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
      path: AppScreen.users.toPath,
      name: AppScreen.users.name,
      pageBuilder: (context, state) => const NoTransitionPage(
        child: UsersScreen(),
      ),
    ),
    //채팅 화면 목록
    GoRoute(
      path: AppScreen.chattingRooms.toPath,
      name: AppScreen.chattingRooms.name,
      pageBuilder: (context, state) => const NoTransitionPage(
        child: RoomsScreen(),
      ),
    ),
    //채팅
    GoRoute(
      path: "${AppScreen.chat.toPath}/:roomId",
      name: AppScreen.chat.name,
      pageBuilder: (context, state) {
        final roomId = state.pathParameters['roomId'];
        Log.black(roomId);
        return NoTransitionPage(
          child: ChatScreen(roomId: roomId!),
        );
      },
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
