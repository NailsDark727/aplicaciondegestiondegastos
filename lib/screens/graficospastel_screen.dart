import 'package:flutter/material.dart';
import 'package:aplicaciondegestiondegastos/utils/colors_utils.dart';
//import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pie_chart/pie_chart.dart';
//import 'package:aplicaciondegestiondegastos/screens/graficos_screen.dart';
//import 'package:aplicaciondegestiondegastos/screens/graficoslineas_screen.dart';

class GraficosPastelScreen extends StatefulWidget {
  @override
  _GraficosPastelScreenState createState() => _GraficosPastelScreenState();
}

class _GraficosPastelScreenState extends State<GraficosPastelScreen> {
  Map<String, double> dataMap = {};

  bool dataLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadDataFromFirestore();
  }

  Future<void> _loadDataFromFirestore() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      /*if (user != null) {
        final uid = user.uid;*/
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user!.uid)
          //.doc(uid)
          .collection('gastos')
          .get();

      final gastos = querySnapshot.docs;
      final Map<String, double> sumaGastosPorCategoria = {};
      //final Map<String, double> categorySums = {};

      /*for (var gasto in gastos) {
          final gastoData = gasto.data() as Map<String, dynamic>;
          final categoria = gastoData['descripcion'] as String;
          final gastoValue = gastoData['gasto'] as double;
          categorySums[categoria] = (categorySums[categoria] ?? 0) + gastoValue;
        }

        // Calcula el total de gastos
        final totalGastos = categorySums.values.reduce((a, b) => a + b);

        categorySums.forEach((categoria, suma) {
          final porcentaje = (suma / totalGastos) * 100;
          dataMap[categoria] = porcentaje;
        });

        setState(() {});
      }*/
      for (var doc in gastos) {
        final data = doc.data(); //as Map<String, dynamic>;
        final categoria = data['descripcion'] as String;
        final gasto = data['gasto'];

        if (sumaGastosPorCategoria.containsKey(categoria)) {
          sumaGastosPorCategoria[categoria] =
              (sumaGastosPorCategoria[categoria] ?? 0) + gasto;
        } else {
          sumaGastosPorCategoria[categoria] = gasto.toDouble();
        }
      }

      setState(() {
        dataMap = sumaGastosPorCategoria;
        dataLoaded = true;
      });
    } catch (error) {
      print('Error al cargar datos desde Firestore: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    /*Map<String, double> dataMap = {
      "Flutter": 5,
      "React": 4,
      "Otra cosa": 2,
      "Lo otro xd": 1,
    };*/
    return Scaffold(
      /*appBar: AppBar(
        elevation: 0,
        title: Text('Gráfico de pastel'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        actions: [],
      ),*/
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
        child: Column(
          children: [
            AppBar(
              elevation: 0,
              title: Text('Gráfico de pastel'),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              actions: [],
            ),
            SizedBox(height: 20),
            /*Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    print("Soy un botón que fue presionado");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GraficoScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: Text(
                    'Gráfico de Barras',
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
            ),*/
            Expanded(
              child: Center(
                //child: PieChart(
                child: dataLoaded
                    ? PieChart(
                        dataMap: dataMap,
                        chartRadius: MediaQuery.of(context).size.width / 1.4,
                        legendOptions: LegendOptions(
                          legendPosition: LegendPosition.bottom,
                        ),
                        chartValuesOptions: ChartValuesOptions(
                          showChartValuesInPercentage: true,
                        ),
                        //),
                      )
                    : CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      ),
      /*appBar: AppBar(
        title: Text('Gráfico de pastel'),
      ),*/
      /*appBar: AppBar(
        elevation: 0,
        title: Text('Gráfico de pastel'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        actions: [],
      ),*/
    );
  }
}
