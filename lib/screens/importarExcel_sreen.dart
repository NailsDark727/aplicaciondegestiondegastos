import 'package:flutter/material.dart';
import 'package:aplicaciondegestiondegastos/utils/colors_utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(const MyImportacionCSV());
}

class MyImportacionCSV extends StatelessWidget {
  const MyImportacionCSV({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 66, 134, 244),
        elevation: 0,
        /*title: Text(
          'Bienvenido a las importaciones',
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['csv'],
                    );

                    if (result != null && result.files.isNotEmpty) {
                      String? filePath = result.files.single.path;
                      if (filePath != null) {
                        File file = File(filePath);
                        if (file.existsSync()) {
                          List<List<dynamic>> csvRows =
                              CsvToListConverter(fieldDelimiter: ';')
                                  .convert(file.readAsStringSync());

                          for (var row in csvRows) {
                            if (row.length >= 4) {
                              // Datos del CSV
                              String? banco = row[0].toString();
                              String? tipoPago = row[1].toString();
                              String? descripcion = row[2].toString();
                              dynamic gasto = row[3];
                              dynamic fecha = row[4];

                              User? user = FirebaseAuth.instance.currentUser;
                              if (user != null) {
                                CollectionReference gastosCollection =
                                    FirebaseFirestore.instance
                                        .collection('Users')
                                        .doc(user.uid)
                                        .collection('gastos');

                                // Conversión de fecha
                                DateTime? fechaFirestore;
                                if (fecha is DateTime) {
                                  fechaFirestore = fecha;
                                } else if (fecha is int) {
                                  fechaFirestore =
                                      DateTime.fromMillisecondsSinceEpoch(
                                          fecha);
                                } else if (fecha is String) {
                                  fechaFirestore = parseCustomDate(fecha);
                                }

                                if (fechaFirestore != null) {
                                } else {
                                  print("Fecha no válida: $fecha");
                                  fechaFirestore = DateTime.now();
                                }

                                int? gastoFirestore;

                                if (gasto is num) {
                                  gastoFirestore = gasto.toInt();
                                } else if (gasto is String) {
                                  double? parsedGasto = double.tryParse(gasto);
                                  if (parsedGasto != null) {
                                    gastoFirestore = parsedGasto.toInt();
                                  } else {
                                    print("Gasto no válido: $gasto");
                                    continue;
                                  }
                                }

                                await gastosCollection.add({
                                  'banco': banco,
                                  'tipoPago': tipoPago,
                                  'descripcion': descripcion,
                                  'fecha': fechaFirestore,
                                  'gasto': gastoFirestore,
                                });
                              }
                            } else {
                              print(
                                  "El archivo CSV no tiene suficientes columnas.");
                            }
                          }
                        } else {
                          print("El archivo no existe.");
                        }
                      }
                    } else {
                      print("El usuario canceló la selección del archivo.");
                    }
                  } catch (e) {
                    print("Error durante la importación: $e");
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 4, 42, 237),
                ),
                child: Text(
                  'Seleccionar archivo CSV',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(width: 20),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    '¿Como importar mi cartola a la aplicación?',
                    style: TextStyle(
                      fontSize: 25,
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
            Expanded(
              child: ListView(
                children: [
                  _buildInstructionStep(
                      "Paso 1: Desde de la pagina de su banco tiene que descargar su cartola (en formato Excel para facilitar el trabajo), todos los bancos tienen la opcion de conseguir la cartola y descargarla"),
                  SizedBox(width: 20),
                  _buildInstructionStep(
                      "Paso 2: Luego de descargar la cartola, tiene que crear un archivo Excel, cuando haga esto tiene que dividir la cartola en 4 categorias: "),
                  _buildInstructionStep("> banco"),
                  _buildInstructionStep("> tipoPago"),
                  _buildInstructionStep(
                      "Nota: tipoPago tiene que ser 'DEBITO', 'EFECTIVO' o 'CREDITO'"),
                  _buildInstructionStep("> descripcion"),
                  _buildInstructionStep("> gasto"),
                  _buildInstructionStep("> fecha"),
                  _buildInstructionStep(
                      "Nota: Recuerde que en el apartado de 'banco' tiene que escribirlo con el siguiente formato 'BANCO X' Cosulte la lista de opciones validas para bancos"),
                  /*_buildInstructionStep(
                      "Cosulte la lista de opciones validas para bancos"),*/
                  SizedBox(width: 20),
                  _buildInstructionStep(
                      "Nota: El formmato de la fecha tiene que ser el siguiente: dd-mmm-yy (ejemplo 14-sept-23)"),
                  SizedBox(width: 20),
                  _buildInstructionStep(
                      "Paso 3: Cuando tenga el EXCEL listo y ordenado tiene que verse como se ve en la imagen"),
                  SizedBox(width: 40),
                  Image.asset(
                    'assets/images/formatoexceldeejemplo.PNG',
                    width: 200,
                    height: 200,
                  ),
                  SizedBox(width: 40),
                  _buildInstructionStep(
                      "Despues de verificar que el EXCEL este correcto tiene que presionar 'guardar como' en el formato .csv"),
                  Image.asset(
                    'assets/images/guardarcsv.PNG',
                    width: 120,
                    height: 120,
                  ),
                  SizedBox(width: 20),
                  _buildInstructionStep(
                      "Paso 4: Cuando este guardado el excel en formato .csv traspeselo a su dispositivo movil, puede ser por correo, WhatsApp o algun otro medio de transferir archivos"),
                  SizedBox(width: 20),
                  _buildInstructionStep(
                      "Paso 5: presione el boton 'Seleccionar archivo CSV' y busque el archivo en su dispositvo movil"),
                  SizedBox(width: 50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionStep(String stepText) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        stepText,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

DateTime? parseCustomDate(String dateStr) {
  final months = {
    'ene': 1,
    'feb': 2,
    'mar': 3,
    'abr': 4,
    'may': 5,
    'jun': 6,
    'jul': 7,
    'ago': 8,
    'sep': 9,
    'oct': 10,
    'nov': 11,
    'dic': 12,
  };

  final parts = dateStr.split('-');
  if (parts.length == 3) {
    final day = int.tryParse(parts[0]);
    final month = months[parts[1]];
    final year = int.tryParse(parts[2]);

    if (day != null && month != null && year != null) {
      return DateTime(year < 2000 ? 2000 + year : year, month, day);
    }
  }

  return null;
}
