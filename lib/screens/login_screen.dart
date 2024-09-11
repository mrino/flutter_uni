import 'dart:convert';

import 'package:easy_extension/easy_extension.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:uniuni/config.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide.none,
  );

  final String _email = "202030420@daelim.ac.kr";
  final _password = "202030420";
  bool _isObscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 로그인 api 호출
  void _onFetchedApi() async {
    final response = await http.post(Uri.parse(authUrl),
        body: jsonEncode({
          'email': _emailController.toString(),
          'password': _passwordController.toString(),
        }));

    Log.green({'statusCode': response.statusCode, "body": response.body});
    return;
  }

  // 패스워드 재설정
  void _onRecoveryPassword() {}

  // 로그인
  void _onSignIn() async {
    return;
  }

  // 타이틀 텍스트 위젯
  List<Widget> _buildTitleText() => [
        Text(
          "Hello Again",
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        1.sizedBox,
        Text(
          'Wellcome back you\'re\nbeen missed!',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 16,
          ),
        ),
      ];

  // 텍스트 위젯 입력들
  List<Widget> _buildTextFields() => [
        _buildTextField(
          controller: _emailController,
          hintText: "Enter email",
        ),
        5.heightBox,
        _buildTextField(
          onObscure: (down) {
            setState(() {
              _isObscure = !down;
              Log.black(_isObscure);
            });
          },
          controller: _passwordController,
          hintText: "Password",
          obscure: _isObscure,
        )
      ];

  // 입력폼 위젯
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool? obscure,
    Function(bool down)? onObscure,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        enabledBorder: border,
        focusedBorder: border,
        fillColor: Colors.white,
        hintText: hintText,
        suffixIcon: obscure != null
            ? GestureDetector(
                onTapDown: (details) => onObscure?.call(true),
                onTapUp: (details) => onObscure?.call(false),
                child: Icon(
                  obscure
                      //
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
              )
            : null,
      ),
      obscureText: obscure ?? false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe4dde2),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              double.infinity.widthBox,
              36.heightBox,
              ..._buildTitleText(),
              20.heightBox,
              ..._buildTextFields(),
              16.heightBox,
              //Recovery Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _onRecoveryPassword,
                  child: Text(
                    "Recovery Password",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              16.heightBox,
              //Sign in
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onSignIn,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                    ),
                    backgroundColor: const Color(0xffe46a61),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    "Sign in",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
