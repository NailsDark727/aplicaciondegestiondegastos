import 'package:flutter/material.dart';
//import 'package:aplicaciondegestiondegastos/utils/colors_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aplicaciondegestiondegastos/screens/nuevogasto_screen.dart';
import 'package:intl/intl.dart';

class Gasto {
  final String id;
  final String descripcion;
  final double gasto;
  final String tipoPago;

  Gasto({
    required this.id,
    required this.descripcion,
    required this.gasto,
    required this.tipoPago,
  });
}

class EditarGastosScreen extends StatelessWidget {
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
        child: GastosList(),
      ),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 66, 134, 244),
        elevation: 0,
        title: Text(
          'Lista de Gastos personalizados',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [],
      ),
    );
  }
}

class GastosList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('gastos')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text('No hay gastos disponibles.'),
          );
        }

        final gastos = snapshot.data!.docs;

        final gastosListTiles = gastos.map((doc) {
          final data = doc.data() as Map<String, dynamic>;

          final descripcion = (data['descripcion'] ?? 'Sin descripción');
          final tipoPago = data['tipoPago'];
          final gasto = data['gasto'] ?? 0;

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            margin: EdgeInsets.all(8),
            child: ListTile(
              //title: Text(descripcion),
              //subtitle: Text('\$$gasto'),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      descripcion,
                      style: TextStyle(fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    tipoPago,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 20),
                  Text(
                    NumberFormat.currency(
                      locale: 'es',
                      symbol: '\$',
                      decimalDigits: 0,
                    ).format(gasto),
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      final data = doc.data() as Map<String, dynamic>;
                      final descripcion = data['descripcion'] ?? '';
                      final gasto = data['gasto'] ?? 0.0;
                      final banco = data['banco'] ?? 'Seleccione banco';
                      final fecha = data['fecha'] ?? '';
                      //final tipoPago = data['tipoPago'] ?? 'Sin tipo de pago';

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NuevoGastoScreen(
                            descripcion: descripcion,
                            gasto: gasto,
                            docId: doc.id,
                            banco: banco,
                            fecha: fecha.toDate(),
                            //tipoPago: tipoPago,
                          ),
                        ),
                      );
                    },
                    child: Icon(
                      Icons.edit,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(width: 8),
                  InkWell(
                    onTap: () async {
                      await FirebaseFirestore.instance
                          .collection('Users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection('gastos')
                          .doc(doc.id)
                          .delete();
                    },
                    child: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList();

        return ListView(
          children: gastosListTiles,
        );
      },
    );
  }
}
