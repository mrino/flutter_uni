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

  Future<void> _upLoadProfileImage() async {
    if (_profileImg == null || _profileImg?.isEmpty == true) {
      return;
    }

    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result == null) return;

    final imageFile = result.files.single;
    // final imageBytes = imageFile.bytes;
    final imageName = imageFile.name;
    final imagePath = imageFile.path;
    final imageMime = lookupMimeType(imageName) ?? 'image/jpeg'; // image/jpeg

    // mime 타입  자르기
    final mimeSplit = imageMime.split("/");
    final mimeType = mimeSplit.first;
    final mimeSubType = mimeSplit.last;

    Log.black(
      "프로필이미지 업로드: $imageName, $imageMime (${mimeSplit.first}, ${mimeSplit.last})",
    );

    final token = StorageHelper.authData!.accessToken;
    final tokenType = StorageHelper.authData!.tokenType.firstUpperCase;

    if (imagePath == null) return;

    final uploadRequest = http.MultipartRequest(
      "POST",
      Uri.parse(setProfileImageUrl),
    )
      ..headers.addAll({
        HttpHeaders.authorizationHeader: '$tokenType $token',
      })
      ..files.add(await http.MultipartFile.fromPath('image', imagePath,
          // contentType: MediaType(mimeType, mimeSubType),
          contentType: MediaType.parse(imageMime)));
    final response = await uploadRequest.send();
    final uploadResult = await http.Response.fromStream(response);

    Log.green("이미지 업로드 결과 ${uploadResult.statusCode}, ${uploadResult.body}");
    if (uploadResult.statusCode != 200) {
      Log.red("프로필 이미지 업로드 에러");
      return;
    }

    _fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appScren: AppScreen.setting,
      child: Column(
        children: [
          ListTile(
            leading: InkWell(
              onTap: _upLoadProfileImage,
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
        ],
      ),
    );
  }
}
