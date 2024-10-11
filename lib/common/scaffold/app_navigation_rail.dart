import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uniuni/router/app_screen.dart';

class AppNavigationRail extends StatelessWidget {
  final AppScreen appScren;

  const AppNavigationRail({
    super.key,
    required this.appScren,
  });

  @override
  Widget build(BuildContext context) {
    final screens = List<AppScreen>.from(AppScreen.values);
    screens.removeAt(0);

    return NavigationRail(
      onDestinationSelected: (value) {
        final screen = screens[value];
        context.pushNamed(screen.name);
      },
      selectedIndex: appScren.index - 1,
      destinations: screens.map((e) {
        return NavigationRailDestination(
          icon: Icon(e.getIcon),
          label: Text(e.name),
        );
      }).toList(),
    );
  }
}
