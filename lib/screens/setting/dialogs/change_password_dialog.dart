import 'package:easy_extension/easy_extension.dart';
import 'package:flutter/material.dart';
import 'package:uniuni/common/extensions/context_extensions.dart';
import 'package:uniuni/common/helpers/api_helper.dart';
import 'package:uniuni/common/helpers/storage_helper.dart';

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({super.key});

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final _curruntPwController = TextEditingController();
  final _newPwController = TextEditingController();
  final _newConfirmPwController = TextEditingController();

  final _currentPwFromKey = GlobalKey<FormState>();
  final _newFromPwKey = GlobalKey<FormState>();
  final _newConfirmPwFromKey = GlobalKey<FormState>();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureNewConfirm = true;
  final bgColor = const Color(0xFFF3F4F6);

  String currentPwValidateMsg = '';

  String? _validator(String? value) {
    if (value == null || value.isEmpty || value.trim().isEmpty) {
      return "이 입력란을 작성하세요";
    }
    return null;
  }

  //비밀번호 변경
  void _onChangedPw() async {
    currentPwValidateMsg = "";
    final cureentValidate = _currentPwFromKey.currentState?.validate() ?? false;
    final newValidate = _newFromPwKey.currentState?.validate() ?? false;
    final newCorfirm = _newConfirmPwFromKey.currentState?.validate() ?? false;
    if (!cureentValidate || !newValidate || !newCorfirm) {
      return;
    }
    final currentPw = _curruntPwController.text;
    final newPw = _newPwController.text;
    // 현재 비밀번호 검사 -> 실패 시 에러 표시

    Log.green("비밀번호 검사");
    final authData = await ApiHelper.signIn(
        email: StorageHelper.authData!.email, password: currentPw);

    if (authData == null) {
      Log.green("비밀번호 실패");
      return setState(() {
        currentPwValidateMsg = "현재 비밀번호가 일치하지 않습니다";
      });
    }
    Log.green("비밀번호 변경시작");

    final (success, err) = await ApiHelper.changePassword(newPw);
    if (!success) {
      Log.red(err);
      if (mounted) {
        return context.buildSnackBarText("비밀번호를 변경할수없습니다");
      }
      return;
    }

    if (!mounted) return;
    ApiHelper.signOut(context);
  }

  //공용위젯
  Widget _buildTextField({
    required String hint,
    required Key key,
    required TextEditingController textController,
    bool obscureText = true,
    String? Function(String? value)? validator,
    VoidCallback? onObscurePressd,
  }) {
    return ListTile(
      dense: true,
      title: Form(
        key: key,
        child: TextFormField(
          validator: validator,
          controller: textController,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            filled: false,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            suffixIcon: InkWell(
              onTap: onObscurePressd,
              child: Icon(obscureText //
                  ? Icons.visibility
                  : Icons.visibility_off),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _curruntPwController.dispose();
    _newPwController.dispose();
    _newConfirmPwController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: bgColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "비빌번호 변경",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            30.heightBox,
            Card(
              elevation: 0,
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: context.themeData.dividerColor,
                ),
              ),
              child: Column(
                children: ListTile.divideTiles(
                  context: context,
                  tiles: [
                    _buildTextField(
                      validator: (value) {
                        return _validator(value);
                      },
                      hint: "현재 비밀번호",
                      key: _currentPwFromKey,
                      textController: _curruntPwController,
                      obscureText: _obscureCurrent,
                      onObscurePressd: () {
                        setState(() {
                          _obscureCurrent = !_obscureCurrent;
                        });
                      },
                    ),
                    Container(
                      height: 20,
                      color: bgColor,
                      child: Text(
                        currentPwValidateMsg,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                    _buildTextField(
                      validator: (value) {
                        final isEmptyValidate = _validator(value);
                        if (isEmptyValidate != null) {
                          return isEmptyValidate;
                        }
                        final newPw = _newPwController.text;
                        if (value!.length < 6) {
                          return "6글자 이상이어야 합니다.";
                        }
                        if (value != newPw) {
                          return "비밀번호가 일치하지 않습니다";
                        }
                        return null;
                      },
                      hint: "새 비밀번호",
                      key: _newFromPwKey,
                      textController: _newPwController,
                      obscureText: _obscureNew,
                      onObscurePressd: () {
                        setState(() {
                          _obscureNew = !_obscureNew;
                        });
                      },
                    ),
                    _buildTextField(
                      validator: (value) {
                        final isEmptyValidate = _validator(value);
                        if (isEmptyValidate != null) {
                          return isEmptyValidate;
                        }
                        final newPw = _newPwController.text;
                        if (value != newPw) {
                          return "비밀번호가 일치하지 않습니다";
                        }
                        return null;
                      },
                      hint: "새 비밀번호 확인",
                      key: _newConfirmPwFromKey,
                      textController: _newConfirmPwController,
                      obscureText: _obscureNewConfirm,
                      onObscurePressd: () {
                        setState(() {
                          _obscureNewConfirm = !_obscureNewConfirm;
                        });
                      },
                    ),
                  ],
                ).toList(),
              ),
            ),
            20.heightBox,
            ElevatedButton(
              onPressed: _onChangedPw,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4E46DC),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "변경하기",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
