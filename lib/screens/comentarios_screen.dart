import 'package:flutter/material.dart';
import 'package:aplicaciondegestiondegastos/utils/colors_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ComentarioScreen extends StatefulWidget {
  @override
  _ComentarioScreenState createState() => _ComentarioScreenState();
}

class _ComentarioScreenState extends State<ComentarioScreen> {
  bool? _isChecked = false;
  bool? _isChecked2 = false;
  TextEditingController comentarioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            Center(
              child: FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  '¿Tuviste algún problema con la aplicación?',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 130),
              //alignment: Alignment.center,
              child: CheckboxListTile(
                title: const Text('Si'),
                value: _isChecked,
                onChanged: (bool? newValue) {
                  setState(() {
                    _isChecked = newValue;
                    if (_isChecked == true) {
                      _isChecked2 = false;
                    }
                  });
                },
                activeColor: Colors.orangeAccent,
                checkColor: Colors.black,
                tileColor: Colors.black12,
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 130),
              //contentPadding: EdgeInsets.all(10),
              child: CheckboxListTile(
                title: const Text('No'),
                value: _isChecked2,
                onChanged: (bool? newValue) {
                  setState(() {
                    _isChecked2 = newValue;
                    if (_isChecked2 == true) {
                      _isChecked = false;
                    }
                  });
                },
                //contentPadding: EdgeInsets.all(10),
                activeColor: Colors.orangeAccent,
                checkColor: Colors.black,
                tileColor: Colors.black12,
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Center(
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: SizedBox(
                    height: 150,
                    child: Text(
                      'Escribe aqui tu feedback para mejorar nuestro proyecto',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: comentarioController,
                decoration: InputDecoration(
                  hintText: 'Escribe aquí tu comentario',
                  border: InputBorder.none,
                ),
                style: TextStyle(
                  color: Colors.black,
                ),
                maxLines: 5,
              ),
              /*/Expanded(
              child: Center(
                child: Text('Pantalla de COMENTARIOS'),*/
            ),
            Container(
              padding: EdgeInsets.only(top: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 150, 240, 48),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  print('Botón se presionó');
                  guardarComentario();
                },
                child: Text(
                  'GUARDAR',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void guardarComentario() async {
    String huboProblemas = '';
    if (_isChecked == true) {
      huboProblemas = 'Si';
    } else if (_isChecked2 == true) {
      huboProblemas = 'No';
    }

    String comentario = comentarioController.text;

    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }
    final userCollection = firestore.collection('Users').doc(user.uid);

    final comentariosCollection = userCollection.collection('comentarios');
    final comentariosDocs = await comentariosCollection.get();
    if (comentariosDocs.docs.isEmpty) {
      await comentariosCollection.add({
        'huboproblemas': huboProblemas,
        'feedback': comentario,
      });
    } else {
      await comentariosCollection.add({
        'huboproblemas': huboProblemas,
        'feedback': comentario,
      });
    }

    comentarioController.clear();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Comentario guardado"),
          content: Text("Tu comentario ha sido guardado exitosamente."),
          actions: <Widget>[
            TextButton(
              child: Text("Aceptar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
