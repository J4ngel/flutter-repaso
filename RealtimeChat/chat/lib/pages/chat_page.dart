import 'dart:io';

import 'package:chat/models/messages_response.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/chat_service.dart';
//import 'package:chat/services/send_message.dart'; //para whatsaap
import 'package:chat/services/socket_service.dart';
import 'package:chat/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textCtrl = TextEditingController();
  final _focusNode = FocusNode();

  ChatService? chatService;
  SocketService? socketService;
  AuthService? authService;

  bool _isTyping = false;

  List<ChatMessage> _messages = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.chatService = Provider.of<ChatService>(context, listen: false);
    this.socketService = Provider.of<SocketService>(context, listen: false);
    this.authService = Provider.of<AuthService>(context, listen: false);

    this.socketService!.socket.on('mensaje-personal', _listenMessage);

    _loadhistory(this.chatService!.userTo!.uid);
  }

  void _loadhistory(String userID) async {
    List<Message> chat = await this.chatService!.getChat(userID);
    //print(chat);
    final history = chat.map((m) => ChatMessage(
        text: m.message,
        uid: m.from,
        animationCtrl: AnimationController(
            vsync: this, duration: Duration(milliseconds: 0))
          ..forward()));

    setState(() {
      _messages.insertAll(0, history);
    });
  }

  void _listenMessage(dynamic payload) {
    print('tengo mensaje $payload');
    ChatMessage message = ChatMessage(
        text: payload['message'],
        uid: payload['from'],
        animationCtrl: AnimationController(
            vsync: this, duration: Duration(microseconds: 300)));
    setState(() {
      _messages.insert(0, message);
    });

    message.animationCtrl.forward();
  }

  @override
  Widget build(BuildContext context) {
    final userTo = this.chatService!.userTo;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: [
            CircleAvatar(
              maxRadius: 15,
              child: Text(
                userTo!.name.substring(0, 2),
                style: TextStyle(fontSize: 12),
              ),
              backgroundColor: Colors.blue[100],
            ),
            SizedBox(
              height: 3,
            ),
            Text(
              userTo.name,
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
    // bool send = await SendMessage.sendMessage(text); //Para whatsaap
    bool send = true;
    final newMessage = ChatMessage(
      text: send ? text : 'ERROR',
      uid: authService!.user!.uid,
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

    this.socketService!.emit('mensaje-personal', {
      'from': this.authService!.user!.uid,
      'to': this.chatService!.userTo!.uid,
      'message': text
    });
  }

  @override
  void dispose() {
    //Off del socket para que no escuche y limpiar cada uno de los controladores
    for (ChatMessage message in _messages) {
      message.animationCtrl.dispose();
    }
    this.socketService!.socket.off('mensaje-personal');
    super.dispose();
  }
}
