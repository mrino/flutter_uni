import 'dart:convert';

import 'package:uniuni/config.dart';
import 'package:uniuni/models/auth_data.dart';
import 'package:http/http.dart' as http;

class ApiHelper {
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
      Uri.parse(getTokenUrl),
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
}
