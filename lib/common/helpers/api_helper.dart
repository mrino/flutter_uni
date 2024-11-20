import 'dart:convert';
import 'dart:io';

import 'package:easy_extension/easy_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uniuni/common/helpers/storage_helper.dart';
import 'package:uniuni/config.dart';
import 'package:uniuni/models/auth_data.dart';
import 'package:http/http.dart' as http;
import 'package:uniuni/models/user_data.dart';
import 'package:uniuni/router/app_screen.dart';
import 'package:uniuni/typedef/app_typedef.dart';

class ApiHelper {
  /// GET
  ///
  /// [url] 주소
  static Future<http.Response> get(String url) {
    final authData = StorageHelper.authData;
    return http.get(
      Uri.parse(url),
      headers: {
        HttpHeaders.authorizationHeader:
            "${authData?.tokenType} ${authData?.accessToken}",
      },
    );
  }

  /// Post
  static Future<http.Response> post(
    String url, {
    Map<String, dynamic>? body,
  }) {
    final authData = StorageHelper.authData;

    return http.post(
      Uri.parse(url),
      headers: authData != null
          ? {
              HttpHeaders.authorizationHeader:
                  "${authData.tokenType} ${authData.accessToken}",
            }
          : null,
      body: body != null ? jsonEncode(body) : null,
    );
  }

  /// - [email] 이메일
  /// - [password] 비밀번호
  /// - [retrun]
  /// - authData
  static Future<AuthData?> signIn({
    required String email,
    required String password,
  }) async {
    // TODO: 토큰 관리 준비
    final loginDate = {
      'email': email,
      'password': password,
    };

    final response = await post(
      Config.api.getTokenUrl,
      body: loginDate,
    );

    final statuscode = response.statusCode;
    final body = utf8.decode(response.bodyBytes);
    if (statuscode != 200) return null;

    final bodyJson = jsonDecode(body) as Map<String, dynamic>;
    bodyJson.addAll({"email": email});
    try {
      return AuthData.fromMap(bodyJson);
    } catch (_) {
      return null;
    }
  }

  /// - [newPassword] 새로운 비밀번호
  static Future<Result> changePassword(String newPassword) async {
    final response = await post(
      Config.api.changePasswordUrl,
      body: {
        "password": newPassword,
      },
    );

    final statuscode = response.statusCode;
    final body = utf8.decode(response.bodyBytes);
    if (statuscode != 200) return (false, body);

    return (true, '');
  }

  static Future<List<UserData>> fetchUserList() async {
    final response = await get(Config.api.getUserList);

    final statuscode = response.statusCode;
    final body = utf8.decode(response.bodyBytes);

    if (statuscode != 200) return [];
    final bodyJson = jsonDecode(body);
    final List<dynamic> data = bodyJson['data'] ?? [];

    return data.map((e) => UserData.fromMap(e)).toList();
  }

  static Future signOut(BuildContext context) async {
    await StorageHelper.removeAuthData();

    if (!context.mounted) return;

    context.goNamed(AppScreen.login.name);
  }

  /// - [userId] 상대방 id
  static Future<ResultWithCode> createRoom(String userId) async {
    final response = await post(
      Config.api.createRoom,
      body: {
        "user_id": userId,
      },
    );
    final statuscode = response.statusCode;
    final body = utf8.decode(response.bodyBytes);

    if (statuscode != 200) return (statuscode, body);

    final bodyJson = jsonDecode(body);
    final int code = bodyJson['code'] ?? 404;
    final String msg = bodyJson['message'] ?? '';

    return (code, msg);
  }
}
