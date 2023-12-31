import 'package:chat/helpers/mostrar_alerta.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/socket_service.dart';
import 'package:chat/widgets/btn_azul.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/custom_input.dart';
import '../widgets/labels.dart';
import '../widgets/logo.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
                      title: 'Messenger',
                      img: AssetImage('assets/tag-logo.png')),
                  _Form(),
                  Labels(
                    textOne: '¿No tienes cuenta?',
                    textTwo: 'Crea una ahora!',
                    route: 'register',
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
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: <Widget>[
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
              text: 'Login',
              onPressed: authService.creando
                  ? null
                  : () async {
                      // print(emailCtrl.text);
                      // print(passCtrl.text);
                      FocusScope.of(context).unfocus();
                      final loginOk = await authService.login(
                          emailCtrl.text.trim(), passCtrl.text.trim());
                      if (loginOk) {
                        //conectar al socket service:
                        socketService.connect();
                        //Navegar
                        Navigator.restorablePushReplacementNamed(
                            context, 'users');
                      } else {
                        mostraAlerta(context, 'Login incorrecto',
                            'Revise sus credenciales');
                      }
                    })
        ],
      ),
    );
  }
}
