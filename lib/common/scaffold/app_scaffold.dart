import 'package:flutter/material.dart';
import 'package:uniuni/common/scaffold/app_navigation_rail.dart';
import 'package:uniuni/router/app_screen.dart';

class AppScaffold extends StatelessWidget {
  final AppScreen appScren;
  final PreferredSizeWidget? appBar;
  final Widget child;
  const AppScaffold({
    super.key,
    required this.appScren,
    this.appBar,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            AppNavigationRail(appScren: appScren),
            Expanded(
              child: Column(
                children: [
                  if (appBar != null) appBar!,
                  Expanded(child: child),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
