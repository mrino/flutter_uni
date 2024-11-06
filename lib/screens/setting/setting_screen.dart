import 'dart:convert';
import 'dart:io';

import 'package:easy_extension/easy_extension.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';
import 'package:uniuni/common/helpers/storage_helper.dart';
import 'package:uniuni/common/scaffold/app_scaffold.dart';
import 'package:uniuni/config.dart';
import 'package:uniuni/router/app_screen.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:uniuni/screens/setting/dialogs/change_password_dialog.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String? _name;
  String? _studentNumber;
  String? _profileImg;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final token = StorageHelper.authData!.accessToken;
    final tokenType = StorageHelper.authData!.tokenType.firstUpperCase;

    final response = await http.get(
      Uri.parse(getUserDataUrl),
      headers: {
        HttpHeaders.authorizationHeader: '$tokenType $token',
      },
    );

    final statuscode = response.statusCode;
    final body = utf8.decode(response.bodyBytes);
    if (statuscode != 200) {
      setState(() {
        _name = '데이터를 불러올수없습니다';
        _studentNumber = body;
        _profileImg = '';
      });
      return;
    }

    final userData = jsonDecode(body);

    setState(() {
      _name = userData['name'];
      _studentNumber = userData['student_number'];
      _profileImg = userData['profile_image'];
    });
  }

  Future<void> _uploadProfileImage() async {
    if (_profileImg == null || _profileImg?.isEmpty == true) {
      return;
    }

    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result == null) return;

    final imageFile = result.files.single;
    final imageName = imageFile.name;
    final imageMime = lookupMimeType(imageName) ?? 'image/jpeg';
    Uint8List? imageBytes;

    String? imagePath;

    if (kIsWeb) {
      imageBytes = imageFile.bytes;
    } else {
      imagePath = imageFile.path!;
    }

    Log.green(
        '이미지 업로드: $imageName / Bytes: ${imageBytes?.length} / Path: $imagePath');

    final tokenType = StorageHelper.authData!.tokenType.firstUpperCase;
    final token = StorageHelper.authData!.accessToken;

    final uploadRequest = http.MultipartRequest(
      'POST',
      Uri.parse(setProfileImageUrl),
    )
      ..headers.addAll(
        {
          HttpHeaders.authorizationHeader: '$tokenType $token',
        },
      )
      ..files.add(
        imageBytes != null
            ? http.MultipartFile.fromBytes(
                'image',
                imageBytes,
                filename: imageName,
                contentType: MediaType.parse(imageMime),
              )
            : await http.MultipartFile.fromPath(
                'image',
                imagePath!,
                contentType: MediaType.parse(imageMime),
              ),
      );

    final response = await uploadRequest.send();
    final uploadResult = await http.Response.fromStream(response);

    Log.green(
      '이미지 업로드 결과: ${uploadResult.statusCode}, ${uploadResult.body}',
    );

    if (uploadResult.statusCode != 200) return;

    _fetchUserData();
  }

  Future<void> _changePasswordDialog() async {
    showDialog(
      context: context,
      builder: (context) => const ChangePasswordDialog(),
    );
    return;
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appScren: AppScreen.setting,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 14,
        ),
        child: Column(
          children: [
            ListTile(
              leading: InkWell(
                onTap: _uploadProfileImage,
                child: CircleAvatar(
                  backgroundColor: Colors.blue,
                  backgroundImage: _profileImg != null //
                      ? _profileImg!.isNotEmpty
                          ? NetworkImage(_profileImg!)
                          : null
                      : null,
                  child: _profileImg != null //
                      ? _profileImg!.isEmpty
                          ? const Icon(Icons.cancel)
                          : null
                      : const CircularProgressIndicator(),
                ),
              ),
              title: Text(_name ?? "데이터 로딩중..."),
              subtitle: _studentNumber != null
                  ? Text(
                      _studentNumber ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  : null,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("비밀번호 변경하기"),
                ElevatedButton(
                    onPressed: _changePasswordDialog,
                    child: const Text("Text")),
              ],
            )
          ],
        ),
      ),
    );
  }
}
