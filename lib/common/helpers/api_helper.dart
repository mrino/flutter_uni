import 'dart:convert';
import 'dart:io';

import 'package:easy_extension/easy_extension.dart';
import 'package:uniuni/common/helpers/storage_helper.dart';
import 'package:uniuni/config.dart';
import 'package:uniuni/models/auth_data.dart';
import 'package:http/http.dart' as http;
import 'package:uniuni/models/user_data.dart';

class ApiHelper {
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

    final response = await http.post(
      Uri.parse(Config.api.getTokenUrl),
      body: jsonEncode(loginDate),
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
  static Future<(bool success, String err)> changePassword(
      String newPassword) async {
    final authData = StorageHelper.authData;

    final response = await http.post(
      Uri.parse(Config.api.changePasswordUrl),
      headers: {
        HttpHeaders.authorizationHeader:
            "${authData!.tokenType} ${authData.accessToken}",
      },
      body: jsonEncode(
        {"password": newPassword},
      ),
    );

    final statuscode = response.statusCode;
    final body = utf8.decode(response.bodyBytes);
    if (statuscode != 200) return (false, body);

    return (true, '');
  }

  static Future<List<UserData>> fetchUserList() async {
    final authData = StorageHelper.authData;

    final response = await http.get(
      Uri.parse(Config.api.getUserList),
      headers: {
        HttpHeaders.authorizationHeader:
            "${authData!.tokenType} ${authData.accessToken}",
      },
    );

    final statuscode = response.statusCode;
    final body = utf8.decode(response.bodyBytes);

    if (statuscode != 200) return [];
    final bodyJson = jsonDecode(body);
    final List<dynamic> data = bodyJson['data'] ?? [];

    return data.map((e) => UserData.fromMap(e)).toList();
  }
}
