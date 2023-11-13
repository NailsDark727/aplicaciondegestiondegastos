import 'package:aplicaciondegestiondegastos/reusable_widgets/reusable_widgets.dart';
import 'package:aplicaciondegestiondegastos/screens/home_screen.dart';
import 'package:aplicaciondegestiondegastos/screens/singup_screen.dart';
import 'package:aplicaciondegestiondegastos/utils/colors_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _claveTextController = TextEditingController();
  TextEditingController _correoTextController = TextEditingController();

  bool _isCorreoEmpty = false;
  bool _isClaveEmpty = false;
  bool _showError = false;
  /*String _correoErrorMessage = "";
  String _claveErrorMessage = "";*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              hexStringToColor("4286f4"),
              hexStringToColor("60a6f6"),
              hexStringToColor("86cdfa")
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  logoWidget("assets/images/logochanchito.png"),
                  SizedBox(height: 30),
                  reusableTextFieldWidget(
                    labelText: "Ingresa su usuario",
                    icon: Icons.verified_user,
                    isPassword: false,
                    controller: _correoTextController,
                    onChanged: (value) {
                      setState(() {
                        _isCorreoEmpty = value.isEmpty;
                      });
                    },
                  ),
                  _isCorreoEmpty
                      ? Text("USUARIO NO INGRESADO",
                          style: TextStyle(color: Colors.red))
                      : SizedBox.shrink(),
                  /*reusableTextField(
                    "Ingresa su usuario",
                    Icons.verified_user,
                    false,
                    _correoTextController,
                    /*(value) {
                      setState(() {
                        _isCorreoEmpty = value.isEmpty;
                        _correoErrorMessage = _isCorreoEmpty ? "Usuario no ingresado" : "";
                      });
                    },*/
                  ),*/
                  SizedBox(height: 30),
                  reusableTextFieldWidget(
                    labelText: "Ingresa su contraseña",
                    icon: Icons.lock,
                    isPassword: true,
                    controller: _claveTextController,
                    onChanged: (value) {
                      setState(() {
                        _isClaveEmpty = value.isEmpty;
                      });
                    },
                  ),
                  _isClaveEmpty
                      ? Text("CONTRASEÑA NO INGRESADA",
                          style: TextStyle(color: Colors.red))
                      : SizedBox.shrink(),
                  /*reusableTextField(
                    "Ingresa su contraseña",
                    Icons.lock,
                    false,
                    _claveTextController,
                    /*(value) {
                      setState(() {
                        _isCorreoEmpty = value.isEmpty;
                        _claveErrorMessage = _isClaveEmpty ? "Clave no ingresada" : "";
                      });
                    },*/
                  ),*/
                  SizedBox(height: 30),
                  _showError
                      ? Text(
                          "USUARIO O CONTRASEÑA INCORRECTA",
                          style: TextStyle(color: Colors.red),
                        )
                      : SizedBox.shrink(),
                  botonDeLogin(context, true, () async {
                    try {
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: _correoTextController.text,
                        password: _claveTextController.text,
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(),
                        ),
                      );
                    } catch (error) {
                      setState(() {
                        _showError = true;
                      });
                      print("Error: ${error.toString()}");
                    }
                  }),
                  /*botonDeLogin(context, true, () {
                    FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                      email: _correoTextController.text,
                      password: _claveTextController.text,
                    )
                        .then((value) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(),
                        ),
                      );
                    }).catchError((error) {
                      print("Error: ${error.toString()}");
                    });
                  }),*/
                  SizedBox(height: 20),
                  botonDeRegistro(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row botonDeRegistro() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "¿Aún no posees una cuenta?",
          style: TextStyle(color: Colors.black54),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SingUpScreen()),
            );
          },
          child: const Text(
            " REGISTRATE",
            style: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
