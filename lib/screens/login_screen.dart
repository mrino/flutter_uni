import 'dart:convert';

import 'package:easy_extension/easy_extension.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uniuni/config.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = "202030420@daelim.ac.kr";
  final _password = "202030420";

  // 로그인 api 호출
  void _onFetchedApi() async {
    final response = await http
        .post(Uri.parse(authUrl),
            body: jsonEncode({
              'email': _email,
              'password': _password,
            }))
        .timeout(20.toSecond)
        .catchError((e, stackTrace) {
      return http.Response('$e', 401);
    });

    Log.green({'statusCode': response.statusCode, "body": response.body});
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ElevatedButton(
            onPressed: _onFetchedApi,
            child: const Text("data"),
          ),
        ),
      ),
    );
  }
}
