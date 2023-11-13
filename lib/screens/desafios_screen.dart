import 'package:flutter/material.dart';
import 'package:aplicaciondegestiondegastos/utils/colors_utils.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';

class DesafioScreen extends StatefulWidget {
  @override
  _DesafioScreenState createState() => _DesafioScreenState();
}

class _DesafioScreenState extends State<DesafioScreen> {
  String? _seleccionarCantidad;
  //int _ultimoDiaMarcado = 0;
  //bool _isChecked = false;
  //bool _isChecked2 = false;
  List<bool> _isCheckedLista = List.generate(31, (i) => false);
  double _totalAhorro = 0;
  int _currentDay = 1;

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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      '!EMPEZEMÓS EL DESAFÍO DE AHORRAR¡',
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                /*Expanded(
              child: Center(
                child: Text('Pantalla de DESAFIOssssS'),*/
                //),
              ),
              SizedBox(width: 20),
              Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 4, 42, 237),
                  border: Border.all(color: Colors.black87, width: 2),
                  borderRadius: BorderRadius.circular(30),
                  /*boxShadow: [
                  BoxShadow(
                    color:
                        Color.fromRGBO(0, 0, 0, 0.57),
                    blurRadius: 5,
                  ),
                ],*/
                ),
                child: DropdownButton<String>(
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  hint: Text(
                    "¿Cuánto quieres ahorrar este mes?",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  value: _seleccionarCantidad,
                  items: <DropdownMenuItem<String>>[
                    DropdownMenuItem<String>(
                      value: '\$5000 pesos Chilenos',
                      child: Text('\$5000 pesos Chilenos'),
                    ),
                    DropdownMenuItem<String>(
                      value: '\$10000 pesos Chilenos',
                      child: Text('\$10000 pesos Chilenos'),
                    ),
                    DropdownMenuItem<String>(
                      value: '\$15000 pesos Chilenos',
                      child: Text('\$15000 pesos Chilenos'),
                    ),
                    DropdownMenuItem<String>(
                      value: '\$20000 pesos Chilenos',
                      child: Text('\$20000 pesos Chilenos'),
                    ),
                    DropdownMenuItem<String>(
                      value: '\$25000 pesos Chilenos',
                      child: Text('\$25000 pesos Chilenos'),
                    ),
                    DropdownMenuItem<String>(
                      value: '\$30000 pesos Chilenos',
                      child: Text('\$30000 pesos Chilenos'),
                    ),
                  ],
                  onChanged: (String? newValue) {
                    setState(() {
                      _seleccionarCantidad = newValue;
                      _updateTotal();
                    });
                  },
                ),
              ),
              SizedBox(width: 20),
              for (int i = 1; i < 31; i++)
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.blue,
                    ),
                    child: CheckboxListTile(
                      title: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Día $i',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              '\$${_calculateDailyAmount(i).toStringAsFixed(0)}',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      value: _isCheckedLista[i],
                      onChanged: (bool? newValue) {
                        if (i == _currentDay) {
                          setState(() {
                            _isCheckedLista[i] = newValue!;
                            _updateTotal();
                            _currentDay++;
                          });
                        }
                      },
                      contentPadding: EdgeInsets.all(16.0),
                      activeColor: Colors.orangeAccent,
                      checkColor: Colors.black,
                      tileColor: Colors.transparent,
                    ),
                  ),
                ),
              ElevatedButton(
                onPressed: () {
                  _reiniciarDesafio();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 4, 42, 237),
                ),
                child: Text(
                  'Reiniciar Desafío',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Color.fromARGB(255, 134, 205, 250),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            _totalAhorro >= _calculateTotalObjective()
                ? 'FELICIDADES, CUMPLISTE TU META Y LLEVAS AHORRADO \$${_totalAhorro.toStringAsFixed(0)} PERO ESTO AÚN NO TERMINA, PUEDES AHORRAR MÁS'
                : 'TOTAL AHORRADO \$${_totalAhorro.toStringAsFixed(0)} LLEVAS UN ${(100 * _totalAhorro / _calculateTotalObjective()).toStringAsFixed(0)}% DE TU META',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
  /*CheckboxListTile(
              title: const Text('Checkbox list tile'),
              value: _isChecked2,
              onChanged: (bool? newValue) {
                setState(() {
                  _isChecked2 = newValue!;
                });
              },
              contentPadding: EdgeInsets.all(16.0),
              activeColor: Colors.orangeAccent,
              checkColor: Colors.black,
              tileColor: Colors.black12,
            ),*/
  //],
  //),

  /*child: Column(
        child: Padding(
          children: [
          padding: const EdgeInsets.all(16.0),
            /*AppBar(
              //title: Text('Nuevo Gasto'),
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),*/
            Expanded(
              child: Center(
          child: Text(
            'TOTAL AHORRADO \$${_totalAhorro.toStringAsFixed(0)} LLEVAS UN ${(100 * _totalAhorro / _calculateTotalObjective()).toStringAsFixed(0)}% DE TU META',
                child: Text('Pantalla de DESAFIOssssS'),
            style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          ],
        ),*/

  double _calculateDailyAmount(int day) {
    if (_seleccionarCantidad != null) {
      double totalAmount =
          double.parse(_seleccionarCantidad!.replaceAll(RegExp(r'[^\d.]'), ''));
      double dailyAmount = totalAmount / 30;
      return dailyAmount + (day - 1) * 10;
    }
    return 0;
  }

  double _calculateTotalObjective() {
    if (_seleccionarCantidad != null) {
      double totalAmount =
          double.parse(_seleccionarCantidad!.replaceAll(RegExp(r'[^\d.]'), ''));
      return totalAmount;
    }
    return 0;
  }

  void _updateTotal() {
    double total = 0;
    for (int i = 1; i < 31; i++) {
      if (_isCheckedLista[i]) {
        total += _calculateDailyAmount(i);
      }
    }
    setState(() {
      _totalAhorro = total;
    });
  }

  void _reiniciarDesafio() {
    setState(() {
      _isCheckedLista = List.generate(31, (i) => false);
      _totalAhorro = 0;
      _currentDay = 1;
    });
  }
}
