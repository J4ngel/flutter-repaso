import 'dart:convert';

import 'package:chat/global/environmet.dart';
import 'package:http/http.dart' as http;

class SendMessage {
  static Future<bool> sendMessage(String msg) async {
    final uri = Uri.parse(Environment.URL_WP);
    final data = {
      "messaging_product": "whatsapp",
      "recipient_type": "individual",
      "to": "573045743534",
      "type": "text",
      "text": {
        // the text object
        "preview_url": false,
        "body": msg
      }
    };

    final resp = await http.post(uri, body: jsonEncode(data), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${Environment.TK}'
    });

    print(resp.body);
    if (resp.statusCode == 200) {
      print("Mensaje enviado con exito!!");
      return true;
    } else {
      print("El mensaje no se pudo enviar :C");
      return false;
    }
  }
}
