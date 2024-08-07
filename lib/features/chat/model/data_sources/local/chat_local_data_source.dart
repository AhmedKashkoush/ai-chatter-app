import 'dart:convert';

import 'package:ai_chatter/core/errors/exceptions.dart';
import 'package:ai_chatter/core/utils/keys.dart';
import 'package:ai_chatter/core/utils/strings.dart';
import 'package:ai_chatter/features/chat/model/models/message_model.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class BaseChatLocalDataSource {
  Future<void> cacheChat(List<MessageModel> messages);
  (List<MessageModel>, ChatSession) getCachedChat();
  Future<ChatSession> clearChatHistory();
}

class ChatLocalDataSource implements BaseChatLocalDataSource {
  final SharedPreferences prefs;
  final GenerativeModel model;
  const ChatLocalDataSource(this.prefs, this.model);
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
  (List<MessageModel>, ChatSession) getCachedChat() {
    final String data = prefs.getString(AppKeys.chat) ?? '';
    if (data.isEmpty) {
      final ChatSession session = model.startChat();
      return ([], session);
    }
    List decodedList = jsonDecode(data) as List;
    List<MessageModel> messages = decodedList
        .map(
          (message) => MessageModel.fromJson(message),
        )
        .toList();
    final List<Content> history = messages
        .where((message) => !message.hasError)
        .map((message) => message.isMe
            ? Content.text(message.message)
            : Content.model([TextPart(message.message)]))
        .toList();
    final ChatSession session = model.startChat(history: history);
    return (messages, session);
  }

  @override
  Future<ChatSession> clearChatHistory() async {
    if (!prefs.containsKey(AppKeys.chat)) {
      throw const CacheException(message: AppStrings.emptyCache);
    }
    final bool removed = await prefs.remove(AppKeys.chat);
    if (!removed) throw const CacheException(message: AppStrings.emptyCache);
    final ChatSession session = model.startChat();
    return session;
  }
}
