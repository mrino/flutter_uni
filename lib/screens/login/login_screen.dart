import 'dart:convert';

import 'package:easy_extension/easy_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:uniuni/common/enums/sso_enum.dart';
import 'package:uniuni/common/extensions/context_extensions.dart';
import 'package:uniuni/common/helpers/api_helper.dart';
import 'package:uniuni/common/helpers/storage_helper.dart';
import 'package:uniuni/common/widgets/gradient_divider.dart';
import 'package:uniuni/config.dart';
import 'package:uniuni/models/auth_data.dart';
import 'package:uniuni/router/app_screen.dart';

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

  bool _isObscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 패스워드 재설정
  void _onRecoveryPassword() {}

  // 로그인
  void _onSignIn() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    // TODO: 토큰 관리 준비
    final authData = await ApiHelper.signIn(email: email, password: password);

    if (authData == null) {
      if (mounted) {
        return context.buildSnackBar(
          content: const Text("로그인 실패했습니다"),
        );
      }
    }

    await StorageHelper.setAuthData(authData!);

    final saveAuth = StorageHelper.authData;
    //변환

    Log.black(saveAuth);

    // 화면 이동
    if (mounted) context.goNamed(AppScreen.users.name);

    return;
  }

  void _onSsoSignIn(SsoEnum type) {
    switch (type) {
      case SsoEnum.google:
        context.buildSnackBarText("준비중인 기능입니다.");
        break;
      case SsoEnum.github:
        context.buildSnackBarText("준비중인 기능입니다.");
        break;
      case SsoEnum.apple:
        context.buildSnackBarText("준비중인 기능입니다.");
    }
  }

  // 타이틀 텍스트 위젯
  List<Widget> _buildTitleText() => [
        const Text(
          "Hello Again",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        1.sizedBox,
        const Text(
          'Wellcome back you\'re\nbeen missed!',
          textAlign: TextAlign.center,
          style: TextStyle(
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

  // sso 버튼 위젯
  Widget _buildSsoButton({
    required String iconUrl,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        padding: const EdgeInsets.all(10),
        child: Image.network(iconUrl),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe4dde2),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: DefaultTextStyle(
            style:
                GoogleFonts.poppins(color: context.textTheme.bodyMedium?.color),
            child: Center(
              child: SizedBox(
                width: 300,
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
                        child: const Text(
                          "Recovery Password",
                          style: TextStyle(
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
                            shadowColor: const Color(0xffe46a61)),
                        child: const Text(
                          "Sign in",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    40.heightBox,
                    Row(
                      children: [
                        const Expanded(
                          child: GradientDivider(),
                        ),
                        15.widthBox,
                        const Text("Or continue with"),
                        15.widthBox,
                        const Expanded(
                          child: GradientDivider(
                            reverse: true,
                            width: 70,
                          ),
                        ),
                      ],
                    ),
                    40.heightBox,
                    // sso Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildSsoButton(
                          iconUrl: Config.icon.icGoogle,
                          onTap: () => _onSsoSignIn(SsoEnum.google),
                        ),
                        _buildSsoButton(
                          iconUrl: Config.icon.icApple,
                          onTap: () => _onSsoSignIn(SsoEnum.apple),
                        ),
                        _buildSsoButton(
                          iconUrl: Config.icon.icGithub,
                          onTap: () => _onSsoSignIn(SsoEnum.github),
                        ),
                      ],
                    ),
                    40.heightBox,
                    const Text("Not a member?")
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
