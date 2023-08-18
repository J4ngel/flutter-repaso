import 'package:chat/global/environmet.dart';
import 'package:chat/models/messages_response.dart';
import 'package:chat/models/user.dart';
import 'package:chat/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatService with ChangeNotifier {
  User? userTo;

  Future<List<Message>> getChat(String userId) async {
    final Uri uri = Uri.parse('${Environment.apiUrl}/messages/$userId');
    final resp = await http.get(uri, headers: {
      'Content-Type': 'application/json',
      'x-token': await AuthService.getToken()
    });

    if (resp.statusCode == 200) {
      final messagesResponse = messagesResponseFromJson(resp.body);
      return messagesResponse.messages;
    }
    return [];
  }
}
