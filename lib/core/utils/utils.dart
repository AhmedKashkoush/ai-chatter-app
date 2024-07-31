import 'dart:io';

import 'package:ai_chatter/core/errors/exceptions.dart' as ex;
import 'package:ai_chatter/core/utils/constants.dart';
import 'package:ai_chatter/core/utils/strings.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:feedback/feedback.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'env_keys.dart';

class AppUtils {
  static Future<void> checkConnectivity(Connectivity connectivity) async {
    final ConnectivityResult result =
        (await connectivity.checkConnectivity()).first;
    if (result == ConnectivityResult.none) {
      throw const ex.NetworkException(message: AppStrings.checkConnectivity);
    }
  }

  static Future<GenerateContentResponse> generateResponse(
    GenerativeModel model,
    String prompt,
  ) async {
    try {
      final List<Content> content = [Content.text(prompt)];
      final GenerateContentResponse response =
          await model.generateContent(content);
      return response;
    } catch (e) {
      throw const ex.ServerException(
        message: AppStrings.responseTimeout,
      );
    }
  }

  static Future<GenerateContentResponse> sendMessage(
    ChatSession chat,
    String prompt,
  ) async {
    try {
      final Content content = Content.text(prompt);
      final GenerateContentResponse response = await chat.sendMessage(content);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static void copy(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }

  static void share(String text) {
    Share.share(text);
  }

  static Future<String> _saveUserFeedback(Uint8List screenshot) async {
    final Directory directory = await getTemporaryDirectory();
    final File file = File('${directory.path}/screenshot.png');
    await file.writeAsBytes(screenshot);
    return file.path;
  }

  static Future<void> sendUserFeedback(UserFeedback feedback) async {
    final String screenshotPath = await _saveUserFeedback(feedback.screenshot);
    final Email email = Email(
      subject: '${AppConstants.appName} Feedback',
      recipients: [dotenv.env[EnvKeys.supportEmail]!],
      attachmentPaths: [screenshotPath],
      isHTML: false,
    );

    await FlutterEmailSender.send(email);
  }
}
