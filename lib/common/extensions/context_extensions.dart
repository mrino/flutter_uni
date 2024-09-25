import 'package:flutter/material.dart';

extension BuildContextExtensions on BuildContext {
  ThemeData get themeData => Theme.of(this);
  TextTheme get textTheme => themeData.textTheme;
  // ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text("준비중"),
  //         ),
  //       );

  void buildSnackBar({
    required Widget content,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: content,
      ),
    );
  }

  void buildSnackBarText(String text) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.symmetric(
            horizontal: 17,
            vertical: 10,
          ),
          content: Text(text)),
    );
  }
}
