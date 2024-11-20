import 'package:easy_extension/easy_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:uniuni/common/extensions/context_extensions.dart';
import 'package:uniuni/common/helpers/api_helper.dart';
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

    return Column(
      children: [
        Expanded(
          child: NavigationRail(
            backgroundColor: context.themeData.scaffoldBackgroundColor,
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
          ),
        ),
        10.heightBox,
        IconButton(
          onPressed: () => ApiHelper.signOut(context),
          icon: const Icon(LucideIcons.logOut),
        ),
        10.heightBox,
      ],
    );
  }
}
