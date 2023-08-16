import 'package:chat/widgets/btn_azul.dart';
import 'package:flutter/material.dart';

import '../widgets/custom_input.dart';
import '../widgets/labels.dart';
import '../widgets/logo.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffF2F2F2),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Logo(
                      title: 'Registration',
                      img: AssetImage('assets/tag-logo.png')),
                  _Form(),
                  Labels(
                    textOne: '¿Ya estas registrado?',
                    textTwo: 'ingresa ahora!',
                    route: 'login',
                  ),
                  Text(
                    'Terminos y condiciones de uso',
                    style: TextStyle(fontWeight: FontWeight.w200),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class _Form extends StatefulWidget {
  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: <Widget>[
          CustomInput(
            icon: Icons.person,
            placeHolder: 'Name',
            textController: nameCtrl,
          ),
          CustomInput(
            icon: Icons.email,
            placeHolder: 'Email',
            keyboardType: TextInputType.emailAddress,
            textController: emailCtrl,
          ),
          CustomInput(
            icon: (Icons.lock),
            placeHolder: 'Password',
            keyboardType: TextInputType.emailAddress,
            textController: passCtrl,
            isPasword: true,
          ),
          BotonAzul(
              text: 'Sing in!',
              onPressed: () {
                print(nameCtrl.text);
                print(emailCtrl.text);
                print(passCtrl.text);
              })
        ],
      ),
    );
  }
}
