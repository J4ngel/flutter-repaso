import 'dart:io';

import 'package:chat/services/send_message.dart';
import 'package:chat/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPageWP extends StatefulWidget {
  const ChatPageWP({super.key});

  @override
  State<ChatPageWP> createState() => _ChatPageWPState();
}

class _ChatPageWPState extends State<ChatPageWP> with TickerProviderStateMixin {
  final _textCtrl = TextEditingController();
  final _focusNode = FocusNode();

  bool _isTyping = false;

  List<ChatMessage> _messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: [
            CircleAvatar(
              maxRadius: 15,
              child: Text(
                'Te',
                style: TextStyle(fontSize: 12),
              ),
              backgroundColor: Colors.blue[100],
            ),
            SizedBox(
              height: 3,
            ),
            Text(
              'User name',
              style: TextStyle(color: Colors.black, fontSize: 12),
            )
          ],
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: Container(
        child: Column(children: [
          Flexible(
              child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: _messages.length,
            itemBuilder: (_, i) => _messages[i],
            reverse: true,
          )),
          Divider(
            height: 1,
          ),
          Container(
            color: Colors.white,
            child: _inputChat(),
          )
        ]),
      ),
    );
  }

  Widget _inputChat() {
    return SafeArea(
        child: Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Flexible(
              child: TextField(
            controller: _textCtrl,
            onSubmitted: _handleSubmit,
            onChanged: (String text) {
              //TODO cuando hay un valor, para poder postear
              setState(() {
                text.trim().length > 0 ? _isTyping = true : _isTyping = false;
              });
            },
            decoration: InputDecoration.collapsed(hintText: 'Send changes'),
            focusNode: _focusNode,
          )),

          //boton de enviar
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4),
            child: Platform.isIOS
                ? CupertinoButton(
                    child: Text('Enviar'),
                    onPressed: _isTyping
                        ? () => _handleSubmit(_textCtrl.text.trim())
                        : null)
                : Container(
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    child: IconTheme(
                      data: IconThemeData(color: Colors.blue[400]),
                      child: IconButton(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        icon: Icon(Icons.send),
                        onPressed: _isTyping
                            ? () => _handleSubmit(_textCtrl.text.trim())
                            : null,
                      ),
                    ),
                  ),
          )
        ],
      ),
    ));
  }

  _handleSubmit(String text) async {
    if (text.length == 0) return;

    print(text);
    bool send = await SendMessage.sendMessage(text);

    final newMessage = ChatMessage(
      text: send ? text : 'ERROR',
      uid: '123',
      animationCtrl: AnimationController(
          vsync: this, duration: Duration(milliseconds: 200)),
    );
    _messages.insert(0, newMessage);
    newMessage.animationCtrl.forward();
    _focusNode.requestFocus();
    _textCtrl.clear();

    setState(() {
      _isTyping = false;
    });
  }

  @override
  void dispose() {
    //Off del socket para que no escuche y limpiar cada uno de los controladores
    for (ChatMessage message in _messages) {
      message.animationCtrl.dispose();
    }
    super.dispose();
  }
}
