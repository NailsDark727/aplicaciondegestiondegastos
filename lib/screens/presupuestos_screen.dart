import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
//import 'package:aplicaciondegestiondegastos/utils/colors_utils.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MyPresupuesto());
}

class MyPresupuesto extends StatefulWidget {
  const MyPresupuesto({Key? key}) : super(key: key);
  //MyPresupuesto({Key? key}) : super(key: key);

  @override
  _MyPresupuestoState createState() => _MyPresupuestoState();
}

class _MyPresupuestoState extends State<MyPresupuesto> {
  final TextEditingController _presupuestoController = TextEditingController();
  String selectedPresupuesto = 'Seleccione tipo de presupuesto';
  String selectedRenovacion = '¿Cada cuanto se renueva el presupuesto?';
  bool? _isChecked = false;
  bool? _isChecked2 = false;
  bool showRenovacionwDropdown = false;
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    ))!;
    //if (picked != null && picked != selectedDate)
    setState(() {
      selectedDate = picked;
    });
  }

  void _guardarPresupuesto() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final firestore = FirebaseFirestore.instance;
        final presupuestoData = {
          'MontoPresupuesto': double.parse(_presupuestoController.text),
          'TipoPresupuesto': selectedPresupuesto,
          'Renovable': _isChecked == true ? 'Si' : 'No',
          'FechaPresupuesto': selectedDate,
          if (_isChecked == true) 'TiempoEnRenovar': selectedRenovacion,
        };
        final userRef = firestore.collection('Users').doc(user.uid);
        await userRef.collection('presupuesto').add(presupuestoData);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Alerta"),
              content: Text(
                  "El presupuesto fue guardado en la aplicacion, recuerda ser responsable con tus gastos"),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cerrar"),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print("Error al guardar el presupuesto: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 66, 134, 244),
        elevation: 0,
        /*title: Text(
          'Bienvenido a los presupuestos',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),*/
        actions: [],
      ),
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
        /*child: const Center(
          child: Text('Hola presupuesto'),
        ),*/
        //SizedBox(height: 20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: 1),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Ingrese el presupuesto',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  child: TextFormField(
                    controller: _presupuestoController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Ingrese el presupuesto',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(Icons.attach_money),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.wallet, color: Colors.black),
                    SizedBox(width: 10),
                    Container(
                      constraints: BoxConstraints(maxWidth: 250),
                      child: DropdownButton<String>(
                        value: selectedPresupuesto,
                        onChanged: (newValue) {
                          setState(() {
                            selectedPresupuesto = newValue!;
                          });
                        },
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        items: <String>[
                          'Seleccione tipo de presupuesto',
                          'Presupuesto Sueldo',
                          'Presupuesto Mesada',
                          'Presupuesto Emergencia',
                          'Presupuesto Vacaciones',
                          'Presupuesto Compras Grandes',
                          'Presupuesto Educación',
                          'Presupuesto Jubilación',
                          'Presupuesto Inversiones',
                          'Presupuesto Viajes',
                          'Presupuesto Regalos',
                          'Presupuesto Deudas',
                          'Presupuesto de Entretenimiento',
                        ].map<DropdownMenuItem<String>>(
                          (String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              //child: Text(value),
                              child: Text(value.length > 20
                                  ? value.substring(0, 20) + "..."
                                  : value),
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Center(
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      '¿Este presupuesto es renovable?',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.only(left: 130),
                  child: CheckboxListTile(
                    title: const Text('Si'),
                    value: _isChecked,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _isChecked = newValue;
                        if (_isChecked == true) {
                          _isChecked2 = false;
                          showRenovacionwDropdown = true;
                        } else {
                          showRenovacionwDropdown = false;
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
                  child: CheckboxListTile(
                    title: const Text('No'),
                    value: _isChecked2,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _isChecked2 = newValue;
                        if (_isChecked2 == true) {
                          _isChecked = false;
                          showRenovacionwDropdown = false;
                        }
                      });
                    },
                    activeColor: Colors.orangeAccent,
                    checkColor: Colors.black,
                    tileColor: Colors.black12,
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ),
                SizedBox(height: 20),
                Visibility(
                  visible: showRenovacionwDropdown,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      constraints: BoxConstraints(maxWidth: 250),
                      child: DropdownButton<String>(
                        value: selectedRenovacion,
                        onChanged: (newValue) {
                          setState(() {
                            selectedRenovacion = newValue!;
                          });
                        },
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        items: <String>[
                          '¿Cada cuanto se renueva el presupuesto?',
                          'Cada semana',
                          'Cada 2 semanas',
                          'Cada 3 semanas',
                          'Cada mes',
                          'Cada 2 meses',
                          'Cada 4 meses',
                          'Cada 5 meses',
                          'Cada 6 meses',
                          'Cada 7 meses',
                          'Cada 8 meses',
                          'Cada 9 meses',
                          'Cada 10 meses',
                          'Cada 11 meses',
                          'Cada año',
                        ].map<DropdownMenuItem<String>>(
                          (String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              //child: Text(value),
                              child: Text(value.length > 25
                                  ? value.substring(0, 25) + "..."
                                  : value),
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: InkWell(
                    onTap: () => _selectDate(context),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.amber,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      child: Text(
                        DateFormat('dd/MM/yyyy').format(selectedDate),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    _guardarPresupuesto();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 150, 240, 48),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'GUARDAR',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Color hexStringToColor(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF" + hexColor;
  }
  return Color(int.parse(hexColor, radix: 16));
}
