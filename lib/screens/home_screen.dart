import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:aplicaciondegestiondegastos/screens/importarExcel_sreen.dart';
import 'package:aplicaciondegestiondegastos/screens/singin_screen.dart';
import 'package:aplicaciondegestiondegastos/screens/graficos_screen.dart';
import 'package:aplicaciondegestiondegastos/screens/consejos_screen.dart';
import 'package:aplicaciondegestiondegastos/screens/desafios_screen.dart';
import 'package:aplicaciondegestiondegastos/screens/comentarios_screen.dart';
import 'package:aplicaciondegestiondegastos/screens/presupuestos_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aplicaciondegestiondegastos/screens/nuevogasto_screen.dart';
import 'package:aplicaciondegestiondegastos/screens/editargastos_screen.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  List<Widget> _paginas = [
    HomeContent(),
    GraficoScreen(),
    ConsejoScreen(),
    DesafioScreen(),
    ComentarioScreen(),
  ];
  void _signOutAndNavigateToSignInScreen(BuildContext context) {
    FirebaseAuth.instance.signOut().then((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignInScreen()),
      );
    });
  }

  Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmación'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('¿Seguro/a que quiere salir de la sesión?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Salir'),
              onPressed: () {
                _signOutAndNavigateToSignInScreen(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 66, 134, 244),
        leading: IconButton(
          icon: Icon(Icons.exit_to_app),
          onPressed: () {
            _showLogoutConfirmationDialog(context);
          },
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _paginas,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Color.fromARGB(255, 134, 205, 250),
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            backgroundColor: Color.fromARGB(255, 134, 205, 250),
            icon: Icon(Icons.bar_chart),
            label: 'Gráficos',
          ),
          BottomNavigationBarItem(
            backgroundColor: Color.fromARGB(255, 134, 205, 250),
            icon: Icon(Icons.lightbulb),
            label: 'Consejo',
          ),
          BottomNavigationBarItem(
            backgroundColor: Color.fromARGB(255, 134, 205, 250),
            icon: Icon(Icons.games),
            label: 'Desafío',
          ),
          BottomNavigationBarItem(
            backgroundColor: Color.fromARGB(255, 134, 205, 250),
            icon: Icon(Icons.comment),
            label: 'Comentarios',
          ),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  double calcularTotalPresupuesto(List<DocumentSnapshot> presupuestos) {
    double total = 0;
    for (var doc in presupuestos) {
      final data = doc.data() as Map<String, dynamic>;
      final montoPresupuesto = data['MontoPresupuesto'];

      if (montoPresupuesto != null) {
        total += montoPresupuesto;
      }
    }
    return total;
  }

  double calcularTotalGastos(List<DocumentSnapshot> gastos) {
    double total = 0;
    for (var doc in gastos) {
      final data = doc.data() as Map<String, dynamic>;
      final montoGastos = data['gasto'];
      final tipoPago = data['tipoPago'];

      if (montoGastos != null && tipoPago != "CREDITO") {
        total += montoGastos;
      }
    }
    return total;
  }

  double calcularTotalDeuda(List<QueryDocumentSnapshot> gastos) {
    double totalDeuda = 0;
    for (var doc in gastos) {
      final data = doc.data() as Map<String, dynamic>;
      final deuda = data['deuda'];
      if (deuda != null) {
        totalDeuda += deuda;
      }
    }
    return totalDeuda;
  }

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
      child: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 25),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditarGastosScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightGreen,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Lista Gastos personalizados',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'SplineSans',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 25),
                      ElevatedButton(
                        onPressed: () {
                          print('El botón fue presionado');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyPresupuesto(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Nuevo Presupuestos',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'SplineSans',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('Users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }
                        if (!snapshot.hasData || !snapshot.data!.exists) {
                          return Text('No se encontraron datos');
                        }
                        final userData =
                            snapshot.data!.data() as Map<String, dynamic>;
                        final userName = userData['Name'];
                        return Column(
                          children: [
                            Text(
                              'BIENVENIDO DE VUELTA, $userName',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                fontFamily: 'SplineSans',
                              ),
                            ),
                          ],
                        );
                      }),
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NuevoGastoScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Nuevo gasto',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'SplineSans',
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyImportacionCSV(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Importar Excel',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'SplineSans',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 40),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('Users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection('presupuesto')
                          .snapshots(),
                      builder: (context, presupuestoSnapshot) {
                        if (presupuestoSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        if (presupuestoSnapshot.hasError) {
                          return Text('Error: ${presupuestoSnapshot.error}');
                        }

                        return StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('Users')
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .collection('gastos')
                              .snapshots(),
                          builder: (context, gastoSnapshot) {
                            if (gastoSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }
                            if (gastoSnapshot.hasError) {
                              return Text('Error: ${gastoSnapshot.error}');
                            }

                            final presupuestoTotal = calcularTotalPresupuesto(
                                presupuestoSnapshot.data!.docs);
                            final gastosTotal =
                                calcularTotalGastos(gastoSnapshot.data!.docs);

                            final totalDeuda =
                                calcularTotalDeuda(gastoSnapshot.data!.docs);

                            final presupuestoActual =
                                presupuestoTotal - gastosTotal - totalDeuda;

                            final presupuestoActualFormateado =
                                NumberFormat.currency(
                                        locale: 'es',
                                        symbol: '\$',
                                        decimalDigits: 0)
                                    .format(presupuestoActual);

                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.greenAccent,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 2,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              padding: EdgeInsets.all(8),
                              child: Text(
                                'PRESUPUESTO ACTUAL: \$$presupuestoActualFormateado',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'SplineSans',
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 20),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          'DEUDA DE CREDITO',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SplineSans',
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection('gastos')
                          .where('tipoPago', isEqualTo: 'CREDITO')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }
                        final gastos = snapshot.data!.docs;

                        double totalDeuda = 0;
                        for (var doc in gastos) {
                          final data = doc.data() as Map<String, dynamic>;
                          final deuda = data['deuda'];
                          if (deuda != null) {
                            totalDeuda += deuda;
                          }
                        }
                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                controller: ScrollController(),
                                child: Container(
                                  padding: EdgeInsets.all(1),
                                  margin: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 10,
                                        offset: Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: DataTable(
                                    headingTextStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    columns: <DataColumn>[
                                      DataColumn(label: Text('Tipo de Pago')),
                                      DataColumn(label: Text('Cuotas')),
                                      DataColumn(label: Text('Deuda')),
                                    ],
                                    rows: gastos.map((doc) {
                                      final data =
                                          doc.data() as Map<String, dynamic>;
                                      return DataRow(cells: [
                                        DataCell(
                                          Text(
                                            data['descripcion'] ?? '',
                                            style: TextStyle(
                                                fontFamily: 'SplineSans'),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            data['cuotas'].toString(),
                                            style: TextStyle(
                                                fontFamily: 'SplineSans'),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            NumberFormat.currency(
                                                    locale: 'es',
                                                    symbol: '\$',
                                                    decimalDigits: 0)
                                                .format(
                                                    data['deuda']?.toDouble() ??
                                                        0),
                                            style: TextStyle(
                                                fontFamily: 'SplineSans'),
                                          ),
                                        ),
                                      ]);
                                    }).toList(),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'DEUDA POR MES ACTUAL APROXIMADA',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'SplineSans',
                                    ),
                                  ),
                                  Text(
                                    NumberFormat.currency(
                                            locale: 'es',
                                            symbol: '\$',
                                            decimalDigits: 0)
                                        .format(totalDeuda.toInt()),
                                    //'\$${totalDeuda.toInt()}',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 20),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          'PRESUPUESTO DEL USUARIO',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection('presupuesto')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }
                        final presupuestos = snapshot.data!.docs;
                        final totalPresupuesto =
                            calcularTotalPresupuesto(presupuestos).toInt();

                        return Column(
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              controller: ScrollController(),
                              child: Container(
                                padding: EdgeInsets.all(1),
                                margin: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 10,
                                      offset: Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: DataTable(
                                  columnSpacing: 5,
                                  headingTextStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  columns: const <DataColumn>[
                                    DataColumn(
                                      label: Text(
                                        'Tipo de presupuesto',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Renovable',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Monto Presupuesto',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Eliminar',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ],
                                  rows: presupuestos.map((doc) {
                                    final data =
                                        doc.data() as Map<String, dynamic>;
                                    return DataRow(cells: [
                                      DataCell(
                                        Text(
                                          data['TipoPresupuesto'] ?? '',
                                          style: TextStyle(fontSize: 12),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          data['Renovable'].toString(),
                                          style: TextStyle(fontSize: 12),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          NumberFormat.currency(
                                            locale: 'es',
                                            symbol: '\$',
                                            decimalDigits: 0,
                                          ).format(data['MontoPresupuesto']
                                                  ?.toInt() ??
                                              0),
                                          style: TextStyle(fontSize: 12),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      DataCell(
                                        IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text(
                                                      '¿Seguro/a que quiere borrar el presupuesto?'),
                                                  actions: [
                                                    TextButton(
                                                      child: Text('Cancelar'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: Text('Eliminar'),
                                                      onPressed: () {
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection('Users')
                                                            .doc(FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid)
                                                            .collection(
                                                                'presupuesto')
                                                            .doc(doc.id)
                                                            .delete();
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ]);
                                  }).toList(),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'PRESUPUESTO TOTAL ESTIMADO: ${NumberFormat.currency(
                                locale: 'es',
                                symbol: '\$',
                                decimalDigits: 0,
                              ).format(totalPresupuesto)}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          'LISTA DE GASTOS PERSONALES',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection('gastos')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }
                        final gastos = snapshot.data!.docs;
                        final totalGastos = calcularTotalGastos(gastos).toInt();

                        return Column(
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              controller: ScrollController(),
                              child: Container(
                                padding: EdgeInsets.all(1),
                                //margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 10,
                                      offset: Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: DataTable(
                                  columnSpacing: 5,
                                  headingTextStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  columns: const <DataColumn>[
                                    DataColumn(label: Text('Descripción')),
                                    DataColumn(label: Text('Tipo pago')),
                                    DataColumn(label: Text('Banco')),
                                    DataColumn(label: Text('Gasto')),
                                  ],
                                  rows: gastos
                                      .where((doc) =>
                                          (doc.data() as Map<String, dynamic>)[
                                              'tipoPago'] !=
                                          'CREDITO')
                                      .map((doc) {
                                    final data =
                                        doc.data() as Map<String, dynamic>;
                                    return DataRow(cells: [
                                      DataCell(Text(data['descripcion'] ?? '')),
                                      DataCell(Text(data['tipoPago'] ?? '')),
                                      DataCell(Text(data['banco'] ?? '')),
                                      /*DataCell(
                                          Text('\$${data['gasto'] ?? ''}')),*/
                                      DataCell(
                                        Text(
                                          NumberFormat.currency(
                                                  locale: 'es',
                                                  symbol: '\$',
                                                  decimalDigits: 0)
                                              .format(
                                                  data['gasto']?.toDouble() ??
                                                      0),
                                        ),
                                      ),
                                    ]);
                                  }).toList(),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'GASTO TOTAL',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                /*Text(
                                  '\$$totalGastos',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),*/
                                Text(
                                  NumberFormat.currency(
                                          locale: 'es',
                                          symbol: '\$',
                                          decimalDigits: 0)
                                      .format(totalGastos.toInt()),
                                  //'\$${totalDeuda.toInt()}',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color hexStringToColor(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return Color(int.parse(hexColor, radix: 16));
  }
}
