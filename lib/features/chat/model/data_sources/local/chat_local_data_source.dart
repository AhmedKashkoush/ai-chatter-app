import 'dart:convert';

import 'package:ai_chatter/core/errors/exceptions.dart';
import 'package:ai_chatter/core/utils/keys.dart';
import 'package:ai_chatter/features/chat/model/models/message_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class BaseChatLocalDataSource {
  Future<void> cacheChat(List<MessageModel> messages);
  List<MessageModel> getCachedChat();
}

class ChatLocalDataSource implements BaseChatLocalDataSource {
  final SharedPreferences prefs;
  const ChatLocalDataSource(this.prefs);
  @override
  Future<void> cacheChat(List<MessageModel> messages) async {
    List<Map<String, dynamic>> list = messages
        .map(
          (message) => message.toJson(),
        )
        .toList();
    String encodedList = jsonEncode(list);
    await prefs.setString(AppKeys.chat, encodedList);
  }

  @override
  List<MessageModel> getCachedChat() {
    final String data = prefs.getString(AppKeys.chat) ?? '';
    if (data.isEmpty) throw const CacheException(message: 'Empty cache');
    List decodedList = jsonDecode(data) as List;
    List<MessageModel> messages = decodedList
        .map(
          (message) => MessageModel.fromJson(message),
        )
        .toList();
    return messages;
  }
}
