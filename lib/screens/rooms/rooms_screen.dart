import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uniuni/common/scaffold/app_scaffold.dart';
import 'package:uniuni/router/app_screen.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class RoomsScreen extends StatefulWidget {
  const RoomsScreen({super.key});

  @override
  State<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends State<RoomsScreen> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appScren: AppScreen.chattingRooms,
      appBar: AppBar(
        leadingWidth: 0,
        titleSpacing: 0,
        leading: const SizedBox.shrink(),
        title: const Text(
          "채팅",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(LucideIcons.circlePlus))
        ],
      ),
      child: const Column(),
    );
  }
}
