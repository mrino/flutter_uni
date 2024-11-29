import 'dart:async';

import 'package:easy_extension/easy_extension.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uniuni/common/extensions/context_extensions.dart';
import 'package:uniuni/common/helpers/storage_helper.dart';

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
  final _clinet = Supabase.instance.client;

  StreamSubscription<List<Map<String, dynamic>>>? _messageStrem;
  String get _roomId => widget.roomId;

  final _textController = TextEditingController();

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
    //_startMessageStream();
  }

  @override
  void dispose() {
    _stopMessageStream();
    _textController.dispose();
    super.dispose();
  }

  void _startMessageStream() {
    _messageStrem = _clinet
        .from("chat_messages")
        .stream(
          primaryKey: ['id'],
        )
        .eq('room_id', _roomId)
        .listen((data) {
          Log.green('메세지 : $data');
        }, onError: (e) {
          Log.black(e);
        });
  }

  void _stopMessageStream() {
    _messageStrem?.cancel();
    _messageStrem = null;
  }

  // 메세지 전송
  void _onSendMessage() async {
    final message = _textController.text;
    final senderid = StorageHelper.authData!.userId;

    if (message.isEmpty || message.trim().isEmpty) return;

    Log.green("메세지 전송");
    Log.green("room_id :$_roomId");
    Log.green("sender_id: $senderid");
    Log.green("message: $message");

    final (sucess, err) = await _clinet //
        .from("chat_messages")
        .insert({
          "room_id": _roomId,
          "sender_id": senderid,
          "message": message,
        })
        .then((value) => (true, ''))
        .catchError((e, stack) => (false, e.toString()));

    if (!sucess) {
      context.buildSnackBarText(err);
      return;
    }
    _textController.clear();
  }

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
            child: StreamBuilder(
              stream: _clinet
                  .from('chat_messages')
                  .stream(primaryKey: ['id'])
                  .eq('room_id', _roomId)
                  .limit(10),
              builder: (context, snapshot) {
                Log.black(snapshot.data);
                Log.black(context);

                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final data = snapshot.data ?? [];
                Log.black(data);

                if (data.isEmpty) {
                  return const Center(
                    child: Text("메세지를 전송하세요"),
                  );
                }

                return ListView.separated(
                    padding: const EdgeInsets.only(
                      top: 16,
                      left: 16,
                      right: 16,
                    ),
                    itemBuilder: (context, index) {
                      final dummy = data[index];
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
                            decoration: BoxDecoration(
                                color: isMy //
                                    ? _primaryColor
                                    : _secondaryColor,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    offset: Offset(2, 2),
                                    blurRadius: 2,
                                    spreadRadius: 2,
                                  ),
                                ]),
                            child: ListTile(
                              title: Text(
                                message,
                                style: TextStyle(
                                    color: isMy ? Colors.white : Colors.black),
                              ),
                              subtitle: Text(
                                createAt.toFormat('HH:mm'),
                                style: TextStyle(
                                    color: isMy ? Colors.white : Colors.black),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (context, index) {
                      return 15.heightBox;
                    },
                    itemCount: data.length);
              },
            ),
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
                    controller: _textController,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                      hintText: "메세지를 입력해주세요...",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      filled: false,
                    ),
                  ),
                ),
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
