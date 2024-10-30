import 'package:easy_extension/easy_extension.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:uniuni/common/scaffold/app_scaffold.dart';
import 'package:uniuni/config.dart';
import 'package:uniuni/models/user_data.dart';
import 'package:uniuni/router/app_screen.dart';
import 'package:uniuni/screens/setting/setting_screen.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final List<UserData> _dummyDataList = List.generate(22, (i) {
    final index = i + 1;
    return UserData(
      id: "$index",
      name: "유저 $index",
      email: "$index@daelim.ac.kr",
      studentNumber: "$index",
      profileImageUrl: defulatImg,
    );
  });

  List<UserData> _searchedDataList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchedDataList = List<UserData>.from(_dummyDataList);
  }

  final _defaultInputBorder = const OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(10),
    ),
    borderSide: BorderSide(
      color: Color(0xFFE4E4EF),
    ),
  );

  void _onSearch(String value) {
    setState(() {
      _searchedDataList = _searchedDataList
          .where((e) => e.name.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appScren: AppScreen.users,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "유저 목록",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                10.heightBox,
                TextField(
                  onChanged: _onSearch,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(LucideIcons.search),
                    filled: false,
                    hintText: "유저 검색...",
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black), // 또는 다른 색상
                    ),
                    enabledBorder: _defaultInputBorder,
                  ),
                ),
              ],
            ),
          ),
          if (_searchedDataList.isEmpty)
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(top: 10),
              child: const Text(
                "검색결과가 없습니다.",
                style: TextStyle(fontSize: 20),
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                itemCount: _dummyDataList.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final dummy = _dummyDataList[index];
                  return ListTile(
                    leading: CircleAvatar(
                        backgroundColor: const Color(0xFFEAEAEA),
                        backgroundImage: NetworkImage(dummy.profileImageUrl)),
                    title: Text(
                      dummy.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(dummy.studentNumber),
                  );
                },
              ),
            )
        ],
      ),
    );
  }
}
