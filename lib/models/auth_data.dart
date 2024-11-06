// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AuthData {
  final String email;
  final String accessToken;
  final String tokenType;
  final DateTime expiresAt; // expires_in 필드를 제거하고 expiresAt만 남깁니다.

  AuthData({
    required this.email,
    required this.accessToken,
    required this.tokenType,
    required this.expiresAt,
  });

  AuthData copyWith({
    String? email,
    String? accessToken,
    String? tokenType,
    DateTime? expiresAt,
  }) {
    return AuthData(
      email: email ?? this.email,
      accessToken: accessToken ?? this.accessToken,
      tokenType: tokenType ?? this.tokenType,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'access_token': accessToken,
      'token_type': tokenType,
      'expires_at': expiresAt.millisecondsSinceEpoch,
    };
  }

  factory AuthData.fromMap(Map<String, dynamic> map) {
    return AuthData(
      email: map['email'] as String,
      accessToken: map['access_token'],
      tokenType: map['token_type'],
      expiresAt: DateTime.fromMillisecondsSinceEpoch(map['expires_at']),
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthData.fromJson(String source) =>
      AuthData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AuthData(email: $email, accessToken: $accessToken, tokenType: $tokenType, expiresAt: $expiresAt)';
  }

  @override
  bool operator ==(covariant AuthData other) {
    if (identical(this, other)) return true;

    return other.email == email &&
        other.accessToken == accessToken &&
        other.tokenType == tokenType &&
        other.expiresAt == expiresAt;
  }

  @override
  int get hashCode {
    return email.hashCode ^
        accessToken.hashCode ^
        tokenType.hashCode ^
        expiresAt.hashCode;
  }
}
