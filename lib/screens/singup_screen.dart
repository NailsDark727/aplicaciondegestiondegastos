import 'package:aplicaciondegestiondegastos/reusable_widgets/reusable_widgets.dart';
//import 'package:aplicaciondegestiondegastos/screens/home_screen.dart';
import 'package:aplicaciondegestiondegastos/utils/colors_utils.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aplicaciondegestiondegastos/screens/tokenverificacion_screan.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
//import 'package:mailer/mailer.dart';
//import 'package:mailer/smtp_server.dart';

String _generarTokenAleatorio() {
  final random = Random();
  const chars =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  const length = 10;
  return String.fromCharCodes(Iterable.generate(
      length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
}

class SingUpScreen extends StatefulWidget {
  const SingUpScreen({Key? key}) : super(key: key);

  @override
  State<SingUpScreen> createState() => _SingUpScreenState();
}

class _SingUpScreenState extends State<SingUpScreen> {
  TextEditingController _claveTextController = TextEditingController();
  TextEditingController _correoTextController = TextEditingController();
  TextEditingController _nombreDeUsuarioTextController =
      TextEditingController();

  bool _isNombreRegistroEmpty = false;
  bool _isCorreoRegistroEmpty = false;
  bool _isClaveRegistroEmpty = false;
  bool _isCorreoYaExiste = false;

  /*Future<void> enviarCorreoDeVerificacion(String verificacionEmail,
      String verificacionToken, String usuarioEmail) async {
    final smtpServer = gmail('GestiondeGastos@gmai.com', '');

    final message = Message()
      ..from = Address('GestiondeGastos@gmai.com', 'Administrador')
      ..recipients.add(usuarioEmail)
      ..subject = 'Bienvenido a nuestra aplicación - Verificación de correo'
      ..html = '<p>Gracias por registrarte en nuestra aplicación.</p>'
          '<p>Para verificar su cuenta, por favor ingrese este código en la aplicación:</p>'
          '<p>$verificacionToken</p>';

    try {
      final sendReport = await send(message, smtpServer);
      print('Mensaje enviado: ${sendReport.toString()}');
    } catch (e) {
      print('Error al enviar el mensaje: $e');
    }
  }*/

  Future<void> enviarCorreoDeVerificacion(
      String verificacionEmail,
      String verificacionToken,
      String usuarioEmail,
      String nombreUsuario) async {
    final emailJSTemplateID = 'template_b5st3to';
    final userID = 'vL_STudn1FqPcTRIq';

    final endpoint = 'https://api.emailjs.com/api/v1.0/email/send';

    final data = {
      'service_id': 'service_3oxfre9',
      'template_id': emailJSTemplateID,
      'user_id': userID,
      'template_params': {
        'to_email': usuarioEmail,
        'verification_code': verificacionToken,
        'name': nombreUsuario,
      },
    };

    final response = await http.post(
      Uri.parse(endpoint),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      print('Correo electrónico enviado correctamente');
    } else {
      print('Error al enviar el correo electrónico: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "REGISTRATE",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              hexStringToColor("4286f4"),
              hexStringToColor("60a6f6"),
              hexStringToColor("86cdfa"),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 20),
                  reusableTextFieldWidget(
                    labelText: "Ingrese el nombre de usuario",
                    icon: Icons.person_outline,
                    isPassword: false,
                    controller: _nombreDeUsuarioTextController,
                    onChanged: (value) {
                      setState(() {
                        _isNombreRegistroEmpty = value.isEmpty;
                      });
                    },
                  ),
                  _isNombreRegistroEmpty
                      ? Text("USUARIO NO INGRESADO",
                          style: TextStyle(color: Colors.red))
                      : SizedBox.shrink(),
                  const SizedBox(height: 20),
                  reusableTextFieldWidget(
                    labelText: "Ingresa un correo",
                    icon: Icons.email_outlined,
                    isPassword: false,
                    controller: _correoTextController,
                    onChanged: (value) {
                      setState(() {
                        _isCorreoRegistroEmpty = value.isEmpty;
                      });
                    },
                  ),
                  _isCorreoRegistroEmpty
                      ? Text("CORREO NO INGRESADO",
                          style: TextStyle(color: Colors.red))
                      : SizedBox.shrink(),
                  _isCorreoYaExiste
                      ? Text("EL CORREO YA ESTÁ ASOCIADO A UNA CUENTA",
                          style: TextStyle(color: Colors.red))
                      : SizedBox.shrink(),
                  const SizedBox(height: 20),
                  reusableTextFieldWidget(
                    labelText: "Ingrese la contraseña",
                    icon: Icons.lock_outlined,
                    isPassword: true,
                    controller: _claveTextController,
                    onChanged: (value) {
                      setState(() {
                        _isClaveRegistroEmpty = value.isEmpty;
                      });
                    },
                  ),
                  _isClaveRegistroEmpty
                      ? Text("CONTRASEÑA NO INGRESADA",
                          style: TextStyle(color: Colors.red))
                      : SizedBox.shrink(),
                  const SizedBox(height: 20),
                  botonDeLogin(context, false, () async {
                    try {
                      final existingUser = await FirebaseAuth.instance
                          .fetchSignInMethodsForEmail(
                              _correoTextController.text);
                      if (existingUser.isNotEmpty) {
                        setState(() {
                          _isCorreoYaExiste = true;
                        });
                        return;
                      } else {
                        setState(() {
                          _isCorreoYaExiste = false;
                        });
                      }

                      UserCredential userCredential = await FirebaseAuth
                          .instance
                          .createUserWithEmailAndPassword(
                        email: _correoTextController.text,
                        password: _claveTextController.text,
                      );

                      final user = userCredential.user;
                      final usersCollection =
                          FirebaseFirestore.instance.collection('Users');

                      final token = _generarTokenAleatorio();
                      //await user!.sendEmailVerification();
                      await enviarCorreoDeVerificacion(
                          _correoTextController.text,
                          token,
                          _correoTextController.text,
                          _nombreDeUsuarioTextController.text);

                      //Timestamp fechaActual = Timestamp.now();

                      await usersCollection.doc(user!.uid).set({
                        'Email': _correoTextController.text,
                        'Name': _nombreDeUsuarioTextController.text,
                        'Password': _claveTextController.text,
                        'verificacionToken': token,
                      });

                      /*await usersCollection
                          .doc(user.uid)
                          .collection('gastos')
                          .add({
                        'banco': '',
                        'descripcion': '',
                        'fecha': fechaActual,
                        'gasto': 0,
                      });*/

                      /*await usersCollection
                          .doc(user.uid)
                          .collection('gastos')
                          .doc('initialDocument')
                          .set({});*/

                      print("Se creó la cuenta");

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyApp()),
                      );
                    } catch (error) {
                      print("Error: ${error.toString()}");
                    }
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
