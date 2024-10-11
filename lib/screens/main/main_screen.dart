import 'package:flutter/material.dart';
import 'package:uniuni/common/scaffold/app_scaffold.dart';
import 'package:uniuni/router/app_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      appScren: AppScreen.main,
      child: Center(
        child: Text("메인 화면"),
      ),
    );
  }
}
