import 'package:flutter/material.dart';
import 'package:aplicaciondegestiondegastos/utils/colors_utils.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:aplicaciondegestiondegastos/screens/graficospastel_screen.dart';
//import 'package:aplicaciondegestiondegastos/screens/graficoslineas_screen.dart';
import 'package:intl/intl.dart';

class GraficoScreen extends StatelessWidget {
  const GraficoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /*Padding(
                padding: EdgeInsets.only(top: 30),
                child: Text(
                  "Gráficos Analíticos",
                  style: TextStyle(fontSize: 30),
                ),
              ),*/
              /*AppBar(
                elevation: 0,
                title: Text('Gráfico de barras'),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                actions: [],
              ),*/
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      print("Soy un botón que fue presionado");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GraficosPastelScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: Text(
                      'Gráfico de Pastel',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 20),
                  /*ElevatedButton(
                    onPressed: () {
                      print("Soy un botón que fue presionado");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GraficosLineasScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: Text(
                      'Gráfico de Líneas',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),*/
                ],
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Change the color as needed
                  borderRadius:
                      BorderRadius.circular(10), // Adjust the border radius
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 6.0,
                      spreadRadius: 1.0,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.all(20),
                child: StreamBuilder<QuerySnapshot>(
                  /*Container(
                //height: MediaQuery.of(context).size.height * 0.7,
                height: 450,
                padding: EdgeInsets.all(16),
                child: StreamBuilder<QuerySnapshot>(*/
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

                    final gastos = snapshot.data!.docs;
                    final montosAcumulados = Map<String, int>();

                    final todasLasCategorias = [
                      'Alimentación',
                      'Cuentas y pagos',
                      'Casa',
                      'Transporte',
                      'Ropa',
                      'Salud e higiene',
                      'Ocio',
                      'Videojuegos',
                      'Gasolina',
                      'Comida rapida',
                      'Compra supermercado',
                      'Otros gastos',
                    ];

                    for (var categoria in todasLasCategorias) {
                      montosAcumulados[categoria] = 0;
                    }
                    for (var doc in gastos) {
                      final gastoData = doc.data() as Map<String, dynamic>;
                      final descripcion = gastoData['descripcion'];
                      final gastoValue = gastoData['gasto'];
                      final gastoInt = gastoValue is int ? gastoValue : 0;
                      montosAcumulados[descripcion] =
                          (montosAcumulados[descripcion] ?? 0) + gastoInt;
                    }
                    final data = montosAcumulados.entries
                        .map((entry) => Gasto(entry.key, entry.value))
                        .toList();
                    /*final data = gastos.map((doc) {  
                    final gastoData = doc.data() as Map<String, dynamic>  
                    final gastoValue = gastoData['gasto'];  
                    final gastoInt = gastoValue is int ? gastoValue : 0;  
                    //final gastoInt = int.tryParse(gastoValue) ?? 0;  
                    return Gasto(  
                      gastoData['descripcion'],  
                      gastoInt,  
                    );  
                  }).toList();*/
                    return Container(
                      height: 300,
                      child: charts.BarChart(
                        _createSampleData(data),
                        vertical: false,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              StreamBuilder<QuerySnapshot>(
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
                  final gastos = snapshot.data!.docs;
                  final Map<String, int> sumaGastosPorCategoria = {};
                  for (var doc in gastos) {
                    final data = doc.data() as Map<String, dynamic>;
                    final categoria = data['descripcion'] as String;
                    final gasto = data['gasto'] as int;
                    if (sumaGastosPorCategoria.containsKey(categoria)) {
                      sumaGastosPorCategoria[categoria] =
                          (sumaGastosPorCategoria[categoria] ?? 0) + gasto;
                    } else {
                      sumaGastosPorCategoria[categoria] = gasto;
                    }
                  }
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 6,
                          spreadRadius: 1,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    margin: EdgeInsets.all(20),
                    child: DataTable(
                      columns: const <DataColumn>[
                        DataColumn(label: Text('Descripción')),
                        DataColumn(label: Text('Gasto')),
                      ],
                      rows: sumaGastosPorCategoria.entries.map((entry) {
                        final categoria = entry.key;
                        final sumaGastos = entry.value;

                        return DataRow(cells: [
                          DataCell(Text(categoria)),
                          DataCell(Text(NumberFormat.currency(
                            locale: 'es',
                            symbol: '\$',
                            decimalDigits: 0,
                          ).format(sumaGastos))),
                        ]);
                      }).toList(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<charts.Series<Gasto, String>> _createSampleData(List<Gasto> data) {
    return [
      charts.Series<Gasto, String>(
        id: 'Gastos',
        domainFn: (Gasto gasto, _) => gasto.descripcion,
        measureFn: (Gasto gasto, _) => gasto.monto,
        data: data,
        labelAccessorFn: (Gasto gasto, _) => '\$${gasto.monto}',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      ),
    ];
  }
}

class Gasto {
  final String descripcion;
  final int monto;
  Gasto(this.descripcion, this.monto);
}
