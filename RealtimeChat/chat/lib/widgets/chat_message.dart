import 'package:chat/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatMessage extends StatelessWidget {
  final String text;
  final String uid;
  final AnimationController animationCtrl;

  const ChatMessage(
      {super.key,
      required this.text,
      required this.uid,
      required this.animationCtrl});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return FadeTransition(
      opacity: animationCtrl,
      child: SizeTransition(
        sizeFactor:
            CurvedAnimation(parent: animationCtrl, curve: Curves.easeOut),
        child: Container(
          child: this.uid == authService.user!.uid
              ? _myMessage()
              : _notMyMessage(),
        ),
      ),
    );
  }

  Widget _myMessage() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.only(bottom: 5, left: 25, right: 5),
        child: Text(
          this.text,
          style: TextStyle(color: Colors.white),
        ),
        decoration: BoxDecoration(
            color: Color(0xff4D9EF6), borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  Widget _notMyMessage() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.only(bottom: 5, left: 5, right: 25),
        child: Text(
          this.text,
          style: TextStyle(color: Colors.black),
        ),
        decoration: BoxDecoration(
            color: Color(0xffE4E5E8), borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
