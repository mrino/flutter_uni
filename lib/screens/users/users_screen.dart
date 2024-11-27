import 'package:go_router/go_router.dart';
import 'package:uniuni/api_err.dart';
import 'package:uniuni/common/extensions/context_extensions.dart';
import 'package:uniuni/common/helpers/api_helper.dart';
import 'package:uniuni/common/scaffold/app_scaffold.dart';
import 'package:uniuni/models/user_data.dart';
import 'package:uniuni/router/app_screen.dart';
import 'package:easy_extension/easy_extension.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:uniuni/screens/chat/chat_screen.dart';
import 'package:uniuni/screens/users/widgets/user_item.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  // final List<UserData> _dummyDataList = List.generate(20, (i) {
  //   final index = i + 1;
  //   return UserData(
  //     id: '$index',
  //     name: '유저 $index',
  //     email: '$index@daelim.ac.kr',
  //     studentNumber: '$index',
  //     profileImageUrl: Config.image.defulatImg,
  //   );
  // });
  List<UserData> _users = [];
  List<UserData> _searcheduserList = [];

  final _defaultInputBorder = const OutlineInputBorder(
    borderSide: BorderSide(
      color: Color(0xFFE4E4E7),
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(10),
    ),
  );

  @override
  void initState() {
    super.initState();
    // _searchedDataList = _dummyDataList;
    // _searchedDataList = _fetchUserData;
    _fetchUserData();
  }

  // 유저 목록 가져오기
  Future<void> _fetchUserData() async {
    _users = await ApiHelper.fetchUserList();
    Log.black(_users.length);
    setState(() {
      _searcheduserList = _users;
    });
  }

  // NOTE: 유저 검색
  void _onSearch(String value) {
    setState(() {
      _searcheduserList = _users
          .where(
            (e) => e.name.toLowerCase().contains(value.toLowerCase()),
          )
          .toList();
    });
  }

  // NOTE: 채팅 생성
  Future _onCreateRoom(UserData user) async {
    // Log.cyan(user.name);
    final (code, roomId) = await ApiHelper.createRoom(user.id);
    switch (code) {
      case 200:
        // 채팅방 개설 성공
        Log.green("채팅방 개설 완료 $roomId");

        break;
      case 1001:
        return context.buildSnackBarText('상대방 id 필수');
      case 1002:
        return context.buildSnackBarText('자신과 대화 불가');
      case 1003:
        return context.buildSnackBarText('상대방이 없음');
      case 1004:
        return context.buildSnackBarText('챗봇계정만 대화 가능');
      case 1005:
        //이미 생성된 채팅방이 있습니다
        Log.green("채팅방이 이미 개설되어 있음 $roomId");
        context.pushNamed(AppScreen.chat.name, pathParameters: {
          "roomId": roomId,
        });
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    var userCount = _searcheduserList.length;
    return AppScaffold(
      appScren: AppScreen.users,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // NOTE: 유저 목록 타이틀
                Text(
                  '유저 목록 ($userCount)',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),

                15.heightBox,

                // NOTE: 검색바
                TextField(
                  onChanged: _onSearch,
                  decoration: InputDecoration(
                    filled: false,
                    enabledBorder: _defaultInputBorder,
                    focusedBorder: _defaultInputBorder.copyWith(
                      borderSide: const BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    hintText: '유저 검색...',
                    prefixIcon: const Icon(LucideIcons.search),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          if (_searcheduserList.isEmpty)
            // NOTE: 검색 결과 없음
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(top: 10),
              child: const Text(
                '검색결과가 없습니다.',
                style: TextStyle(fontSize: 20),
              ),
            )
          else
            // NOTE: 유저 리스트뷰
            Expanded(
              child: ListView.separated(
                itemCount: _searcheduserList.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final user = _searcheduserList[index];

                  return UserItem(user: user, onTap: () => _onCreateRoom(user));
                },
              ),
            ),
        ],
      ),
    );
  }
}
