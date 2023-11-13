import 'package:flutter/material.dart';
import 'package:aplicaciondegestiondegastos/utils/colors_utils.dart';
import 'package:aplicaciondegestiondegastos/reusable_widgets/reusable_widgets.dart';
import 'package:aplicaciondegestiondegastos/screens/home_screen.dart';
//import 'package:aplicaciondegestiondegastos/screens/singup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:aplicaciondegestiondegastos/screens/singup_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _miController = TextEditingController();
    TextEditingController _nuevoEmailController = TextEditingController();
    //SingUpScreen signUpScreen = SingUpScreen();

    return MaterialApp(
      title: 'Token de verificación',
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Token de verificación',
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          backgroundColor: Color.fromARGB(255, 66, 134, 244),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
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
                    reusableTextFieldWidget(
                      labelText: "Ingrese el código de verificación",
                      icon: Icons.verified_outlined,
                      isPassword: false,
                      controller: _miController,
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          final token = _miController.text;
                          final user = FirebaseAuth.instance.currentUser;

                          if (user != null) {
                            final userData = await FirebaseFirestore.instance
                                .collection('Users')
                                .doc(user.uid)
                                .get();

                            final verificacionToken =
                                userData['verificacionToken'] as String;

                            if (token == verificacionToken) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomeScreen(),
                                ),
                              );
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Error'),
                                    content: Text('El token no es válido.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Aceptar'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith((states) {
                            if (states.contains(MaterialState.pressed)) {
                              return Colors.black;
                            }
                            return Colors.blueAccent;
                          }),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        child: Text("VERIFICAR"),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Editar Correo'),
                              content: Container(
                                width: 100,
                                height: 100,
                                child: Column(
                                  children: [
                                    Text('Ingrese el nuevo correo:'),
                                    TextField(
                                      controller: _nuevoEmailController,
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () async {
                                    final nuevoEmail =
                                        _nuevoEmailController.text;
                                    final user =
                                        FirebaseAuth.instance.currentUser;

                                    final existingUserQuery =
                                        await FirebaseFirestore.instance
                                            .collection('Users')
                                            .where('Email',
                                                isEqualTo: nuevoEmail)
                                            .get();

                                    if (existingUserQuery.docs.isNotEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'El correo ya existe. Ingrese uno diferente.'),
                                        ),
                                      );
                                    } else {
                                      if (user != null) {
                                        await user.updateEmail(nuevoEmail);
                                        await user.sendEmailVerification();
                                        FirebaseFirestore.instance
                                            .collection('Users')
                                            .doc(user.uid)
                                            .update({'Email': nuevoEmail}).then(
                                                (_) {
                                          //SingUpScreen signUpScreen = SingUpScreen();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'Correo actualizado con éxito. Se ha enviado un nuevo token de verificación.'),
                                            ),
                                          );
                                        }).catchError((error) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'Error al actualizar el correo.'),
                                            ),
                                          );
                                        });
                                      }
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: Text('Guardar'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Cancelar'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text(
                        "¿Correo incorrecto? EDITE SU CORREO",
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
