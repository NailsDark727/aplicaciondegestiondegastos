import 'package:flutter/material.dart';
//import 'package:aplicaciondegestiondegastos/utils/colors_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class NuevoGastoScreen extends StatefulWidget {
  final String? descripcion;
  final String? banco;
  final int? gasto;
  final String? docId;
  final DateTime? fecha;

  NuevoGastoScreen({
    this.descripcion,
    this.gasto,
    this.banco,
    this.docId,
    this.fecha,
  });

  @override
  _NuevoGastoScreenState createState() => _NuevoGastoScreenState();
}

//class NuevoGastoScreen extends StatelessWidget {
class _NuevoGastoScreenState extends State<NuevoGastoScreen> {
  String selectedBanco = 'Seleccione banco';
  String selectedCategoria = 'Seleccione categoría';
  String selectedTipoPago = 'seleccione metodo de pago';
  bool showCuotasField = false;
  int cuotas = 0;
  num montoGasto = 0;
  DateTime selectedDate = DateTime.now();
  List<String> tipoPresupuestos = [];
  String selectedTipoPresupuesto = 'Seleccione tipo de presupuesto';
  Map<String, double> montosPresupuesto = {};

  @override
  void initState() {
    super.initState();

    if (widget.docId != null) {
      selectedCategoria = widget.descripcion ?? 'Seleccione categoría';
      selectedBanco = widget.banco ?? 'Seleccione banco';
      //selectedCategoria = widget.gasto.toString() ??
      //'Seleccione categoría'; // Asegúrate de que coincida con un valor existente en la lista
      montoGasto = widget.gasto ?? 0;
      selectedDate = widget.fecha ?? DateTime.now();
    }
    cargarTipoPresupuestos();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Future<void> cargarTipoPresupuestos() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        QuerySnapshot tipoPresupuestosQuery = await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .collection('presupuesto')
            .get();

        if (tipoPresupuestosQuery.docs.isNotEmpty) {
          Map<String, double> montos = {};
          tipoPresupuestosQuery.docs.forEach((doc) {
            montos[doc['TipoPresupuesto'] as String] =
                doc['MontoPresupuesto'] as double;
          });

          setState(() {
            tipoPresupuestos = montos.keys.toList();
            selectedTipoPresupuesto = tipoPresupuestos.first;
            montosPresupuesto = montos;
          });
        }
      }
    } catch (error) {
      print('Error al cargar los TipoPresupuestos: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        //xtendBodyBehindAppBar: true,
        //appBar: AppBar(),
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
          children: [
            AppBar(
              //title: Text('Nuevo Gasto'),
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
            //Column(
            //children: [
            Expanded(
              child: Center(
                //child: Text('Pantalla de Nuevo Gasto'),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 10,
                      //Row(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      //Padding(
                      //padding: const EdgeInsets.all(16.0),
                      //child: Row(
                      children: [
                        Icon(Icons.account_balance, color: Colors.black),
                        SizedBox(width: 10),
                        DropdownButton<String>(
                          value: selectedBanco,
                          onChanged: (newValue) {
                            setState(() {
                              selectedBanco = newValue!;
                            });
                          },
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          items: <String>[
                            'Seleccione banco',
                            'BANCO BICE',
                            'BANCO CONSORCIO',
                            'BANCO CORP BANCA',
                            'BANCO DE CHILE',
                            'BANCO DEL DESARROLLO',
                            'BANCO ESTADO',
                            'BANCO FALABELLA',
                            'BANCO INTERNACIONAL',
                            'BANCO ITAU',
                            'BANCO PARIS',
                            'BANCO RIPLEY',
                            'BANCO SANTANDER',
                            'BANCO SECURITY',
                            'COOPEUGH',
                            'COPEC PAY',
                            'GLOBAL66',
                            'HSBC BANK (CHILE)',
                            'LA POLAR',
                            'MERCADO PAGO',
                            'PREPAGO LOS HEROES',
                            'SCOTIABANK',
                            'SCOTIABANK AZUL (ex BBVA)',
                            'TAPP CAJA LOS ANDES',
                            'TENPO PREPAGO',
                            'BCI',
                          ].map<DropdownMenuItem<String>>(
                            (String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            },
                          ).toList(),
                        ),
                        SizedBox(width: 30),
                      ],
                    ),
                    SizedBox(height: 30),
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 10,
                      //Row(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      //Padding(
                      //padding: const EdgeInsets.all(16.0),
                      //child: Row(
                      children: [
                        Icon(Icons.account_balance_wallet, color: Colors.black),
                        SizedBox(height: 30),
                        DropdownButton<String>(
                          value: selectedCategoria,
                          onChanged: (newValue) {
                            setState(() {
                              selectedCategoria = newValue!;
                            });
                          },
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          items: <String>[
                            'Seleccione categoría',
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
                          ].map<DropdownMenuItem<String>>(
                            (String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            },
                          ).toList(),
                        ),
                        SizedBox(height: 30),
                      ],
                    ),
                    SizedBox(height: 30),
                    //SizedBox(height: 30),
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 10,
                      children: [
                        Icon(Icons.credit_card, color: Colors.black),
                        SizedBox(height: 30),
                        DropdownButton<String>(
                          value: selectedTipoPago,
                          onChanged: (newValue) {
                            setState(() {
                              selectedTipoPago = newValue!;
                              showCuotasField = selectedTipoPago == 'CREDITO';
                            });
                          },
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          items: <String>[
                            'seleccione metodo de pago',
                            'DEBITO',
                            'CREDITO',
                            'EFECTIVO',
                          ].map<DropdownMenuItem<String>>(
                            (String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            },
                          ).toList(),
                        ),
                        SizedBox(height: 30),
                      ],
                    ),
                    SizedBox(height: 10),
                    Visibility(
                      visible: showCuotasField,
                      //child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          onChanged: (value) {
                            setState(() {
                              cuotas = int.tryParse(value) ?? 0;
                            });
                          },
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Ingrese la cantidad de cuotas del pago',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: Icon(Icons.payment),
                          ),
                          initialValue: cuotas.toString(),
                        ),
                      ),
                      //),
                    ),
                    SizedBox(height: 30),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Ingrese el presupuesto que se usara',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                          //style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 10,
                      children: [
                        Icon(Icons.currency_exchange, color: Colors.black),
                        SizedBox(height: 30),
                        DropdownButton<String>(
                          value: selectedTipoPresupuesto,
                          onChanged: (newValue) async {
                            setState(() {
                              selectedTipoPresupuesto = newValue!;
                            });
                          },
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          items: tipoPresupuestos.map<DropdownMenuItem<String>>(
                            (String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            },
                          ).toList(),
                        ),
                        SizedBox(height: 30),
                      ],
                    ),
                    SizedBox(height: 30),
                    //SizedBox(height: 30),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Ingrese el gasto',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                          //style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            montoGasto = num.tryParse(value) ?? 0;
                          });
                        },
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Ingrese el monto del gasto',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: Icon(Icons.attach_money),
                        ),
                        initialValue: montoGasto.toString(),
                      ),
                    ),
                    SizedBox(height: 30),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Ingrese la fecha',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                          //style: TextStyle(color: Colors.black),
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
                            //labelText: 'Fecha',
                            filled: true,
                            fillColor: Colors.amber,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: Icon(Icons.calendar_today),
                          ),
                          child: Text(
                            //"${selectedDate.toLocal()}",
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
                      onPressed: () async {
                        User? user = FirebaseAuth.instance.currentUser;

                        if (selectedBanco == 'Seleccione banco' ||
                            selectedCategoria == 'Seleccione categoría' ||
                            (selectedTipoPago == 'CREDITO' && cuotas == 0) ||
                            //cuotas == 0 ||
                            montoGasto == 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Algunos datos no son válidos para guardar, por favor corrígalos.'),
                            ),
                          );
                          return;
                        }

                        double presupuestoSeleccionado =
                            montosPresupuesto[selectedTipoPresupuesto] ?? 0;

                        if (presupuestoSeleccionado > 0 &&
                            montoGasto > presupuestoSeleccionado) {
                          bool confirmacion = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Advertencia'),
                                content: Text(
                                  'Lo que quieres comprar parece que excede el límite del presupuesto. ¿Estás seguro de esto?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                    child: Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(true);
                                    },
                                    child: Text('Continuar'),
                                  ),
                                ],
                              );
                            },
                          );

                          if (!confirmacion) {
                            return;
                          }
                        }

                        if (user != null) {
                          CollectionReference gastosCollection =
                              FirebaseFirestore.instance
                                  .collection('Users')
                                  .doc(user.uid)
                                  .collection('gastos');

                          if (widget.docId != null) {
                            if (selectedTipoPago == 'CREDITO' && cuotas > 0) {
                              final deuda = montoGasto / cuotas;
                              await gastosCollection.doc(widget.docId).update({
                                'banco': selectedBanco,
                                'descripcion': selectedCategoria,
                                'gasto': montoGasto,
                                'fecha': selectedDate,
                                'tipoPago': selectedTipoPago,
                                'cuotas': cuotas,
                                'deuda': deuda,
                              });
                            } else {
                              await gastosCollection.doc(widget.docId).update({
                                'banco': selectedBanco,
                                'descripcion': selectedCategoria,
                                'gasto': montoGasto,
                                'fecha': selectedDate,
                                'tipoPago': selectedTipoPago,
                                'cuotas': cuotas,
                                'deuda': 0,
                              });
                            }
                          } else {
                            if (selectedTipoPago == 'CREDITO' && cuotas > 0) {
                              final deuda = montoGasto / cuotas;
                              await gastosCollection.add({
                                'banco': selectedBanco,
                                'descripcion': selectedCategoria,
                                'gasto': montoGasto,
                                'fecha': selectedDate,
                                'tipoPago': selectedTipoPago,
                                'cuotas': cuotas,
                                'deuda': deuda,
                              });
                            } else {
                              await gastosCollection.add({
                                'banco': selectedBanco,
                                'descripcion': selectedCategoria,
                                'gasto': montoGasto,
                                'fecha': selectedDate,
                                'tipoPago': selectedTipoPago,
                                'cuotas': cuotas,
                                'deuda': 0,
                              });
                            }
                          }

                          setState(() {
                            selectedBanco = 'Seleccione banco';
                            selectedCategoria = 'Seleccione categoría';
                            montoGasto = 0;
                            selectedDate = DateTime.now();
                            selectedTipoPago = 'seleccione metodo de pago';
                            showCuotasField = false;
                            cuotas = 0;
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Gasto guardado exitosamente.'),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 150, 240, 48),
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 15),
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
                  ],
                ),
              ),
            ),
            //],
            //),
          ],
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
