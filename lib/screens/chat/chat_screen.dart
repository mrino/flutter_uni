import 'package:easy_extension/easy_extension.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String roomId;

  const ChatScreen({
    super.key,
    required this.roomId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _primaryColor = const Color(0xFF4E80EE);
  final _secondaryColor = Colors.white;
  final _backgroundColor = const Color(0xFFF3F4F6);

  var _dumyList = List<Map<String, dynamic>>.generate(6, (index) {
    return {
      'sender_id': index % 2 == 0 ? "b" : "a",
      'message': "테스트중이빈다",
      'create_at': DateTime.now().add(-index.toMinute)
    };
  });

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dumyList = _dumyList.sortedBy((e) => e["create_at"]);
  }

  void _onSendMessage() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: const Text("챗봇"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
                itemBuilder: (context, index) {
                  final dummy = _dumyList[index];
                  final String senderId = dummy['sender_id'];
                  final String message = dummy["message"];
                  final DateTime createAt = dummy['create_at'];

                  final isMy = senderId == "a";

                  return Row(
                    mainAxisAlignment: isMy //
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      Container(
                        constraints: const BoxConstraints(
                          maxWidth: 200,
                          minWidth: 60,
                        ),
                        color: isMy //
                            ? _primaryColor
                            : _secondaryColor,
                        child: ListTile(
                          title: Text(message),
                          subtitle: Text(createAt.toFormat('HH:mm')),
                        ),
                      ),
                    ],
                  );
                },
                separatorBuilder: (context, index) {
                  return 10.heightBox;
                },
                itemCount: _dumyList.length),
          ),
          //메세지 전송영역
          Container(
            decoration: BoxDecoration(
              color: _secondaryColor,
              border: Border(
                top: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    hintText: "메세지를 입력해주세요...",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    filled: false,
                  ),
                )),
                10.widthBox,
                ElevatedButton(
                  onPressed: _onSendMessage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 0,
                    ),
                  ),
                  child: const Text(
                    "전송",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
