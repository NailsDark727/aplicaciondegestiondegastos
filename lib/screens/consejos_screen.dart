import 'package:flutter/material.dart';
import 'package:aplicaciondegestiondegastos/utils/colors_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ConsejoScreen extends StatefulWidget {
  @override
  _ConsejoScreenState createState() => _ConsejoScreenState();
}

class _ConsejoScreenState extends State<ConsejoScreen> {
  List<String> categorias = [
    "Alimentación",
    "Cuentas y pagos",
    "Casa",
    "Transporte",
    "Ropa",
    "Salud e higiene",
    "Ocio",
    "Videojuegos",
    "Gasolina",
    "Comida rapida",
    "Compra supermercado",
    "Otros gastos"
  ];

  Map<String, int> gastosPorCategoria = {};

  Map<String, Color> coloresPorCategoria = {
    "Alimentación": Colors.red,
    "Cuentas y pagos": Colors.amber,
    "Casa": Colors.orange,
    "Transporte": Colors.lightGreen,
    "Ropa": Colors.limeAccent,
    "Salud e higiene": Colors.purple,
    "Ocio": Colors.blueGrey,
    "Videojuegos": Colors.blue,
    "Gasolina": Colors.cyan,
    "Comida rapida": Colors.lime,
    "Compra supermercado": Colors.teal,
    "Otros gastos": Colors.yellow,
  };

  /*Map<String, String> consejosPorCategoria = {
    "Alimentación": "Consejo para Alimentación",
    "Cuentas y pagos": "Consejo para Cuentas y Pagos",
    "Casa": "Consejo para Casa",
    "Transporte": "Consejo para Transporte",
    "Ropa": "Consejo para Ropa",
    "Salud e higiene": "Consejo para Salud e higiene",
    "Ocio": "Consejo para Ocio",
    "Videojuegos": "Consejo para Videojuegos",
    "Gasolina": "Consejo para Gasolina",
    "Comida rapida": "Consejo para Comida rapida",
    "Compra supermercado": "Consejo para Compra supermercado",
    "Otros gastos": "Consejo para Otros gastos",
  };*/

  Map<String, String> consejosPorCategoria1 = {
    "Alimentación":
        "Considera preparar comidas en casa en lugar de comer fuera. Esto te ayudará a ahorrar dinero y a controlar mejor tus gastos en alimentos.",
    "Cuentas y pagos":
        "Revisa tus facturas y encuentra maneras de reducir tus gastos mensuales. Puedes negociar tarifas con proveedores o buscar planes más económicos.",
    "Casa":
        "Evalúa tus gastos en artículos para el hogar. Asegúrate de comprar solo lo esencial y busca ofertas en lugar de optar por productos de lujo.",
    "Transporte":
        "Explora opciones de transporte más económicas, como el uso de transporte público o compartir viajes. También considera caminar o andar en bicicleta cuando sea posible.",
    "Ropa":
        "Evita las compras impulsivas y busca ropa en tiendas de descuento o de segunda mano. También puedes intercambiar ropa con amigos o familiares.",
    "Salud e higiene":
        "Revisa tus gastos en productos de salud e higiene. Compara precios y busca ofertas para ahorrar en medicamentos y productos esenciales.",
    "Ocio":
        "Busca actividades de ocio gratuitas o de bajo costo. Aprovecha eventos comunitarios, parques y actividades al aire libre para divertirte sin gastar mucho.",
    "Videojuegos":
        "Considera esperar a que los nuevos lanzamientos de videojuegos estén en oferta antes de comprarlos. También puedes buscar opciones de juegos gratuitos o de bajo costo.",
    "Gasolina":
        "Opta por formas más eficientes de transporte y planifica tus viajes para ahorrar en gasolina. Puedes considerar compartir viajes o usar vehículos más económicos.",
    "Comida rapida":
        "Limita la frecuencia de comer comida rápida, ya que puede ser costosa a largo plazo. Prefiere cocinar en casa y planificar tus comidas con antelación.",
    "Compra supermercado":
        "Siempre recuerda pensar que vas a comprar para no terminar comprando algo que no necesites.",
    "Otros gastos":
        "Estos son gastos no especificados, no hay algun consejos especifico de momento para esta categoria, solo asegurate de controlar lo que pongas en esta categoria.",
  };

  Map<String, String> consejosPorCategoria2 = {
    "Alimentación":
        "Parece que puedes controlar bien tus ansias por comer, te aconsejo que sigas asi con una dieta sana",
    "Cuentas y pagos":
        "Las cuentas y deudas son lo mas dificil de controlar y parece que sabes como mantener un estilo de vida sin tener que pagar demasiadas deudas",
    "Casa":
        "Los articulos hogareños son necesarios para tener un buen hambiente en el hogar, solo recuerda las cosas mas importantes y no gastes en tantos lujos",
    "Transporte":
        "A veces lo mejor es caminar, asi aprovechas de ahorrar unas monedas y quemas calorias",
    "Ropa":
        "La ropa cara no es una razon para no ir a la moda, todo depende de donde buscas",
    "Salud e higiene":
        "En estos dias es muy complicado no gastar mucho en medicina, pero no deberias preocuparte si estas con un buen seguro",
    "Ocio":
        "Las coas simples de la vida como ver una pelicula, jugar a los bolos u otras activiades fuera del hogas son divertidas, asegurate que cada uno de esos momentos sean especiales",
    "Videojuegos":
        "Los videojuegos son bastente caros hoy en dia, por lo que recomiendo que termines de jugar tus videojuegos pendientes en vez de comprar uno nuevo",
    "Gasolina":
        "Desde hace unos años controlar el gasto de gasolina es dificil, trata de evitar las autopistas y carreteras si no es un viaje largo",
    "Comida rapida":
        "La comida rapida es una manera simple y deliciosa de comer, solo no dejes que se convierta en constumbre",
    "Compra supermercado":
        "Siempre revisa en tu cocina los articulos que ya tienes para evitar comprar de mas",
    "Otros gastos":
        "Gastos no especificos, quizas un viaje o talvez alguan transferencia bancaria, estos son los mas intimos asi que asegurate de cuidar en que gastas en esta seccion",
  };

  Map<String, String> consejosPorCategoria3 = {
    "Alimentación":
        "Parece que estas gastando bastante en comidas fueras de casa, te recomiendo que intentes revisar en tu casa si hay alimentos como galletas o algun otro",
    "Cuentas y pagos":
        "Parece que tus cuentas estan subiendo, te recomiendo que no tengas muchos electrinicos conectados y no dejar dada la llave del agua",
    "Casa":
        "Los articulos hogareños son utiles para darle mas personalidad a tu hogar, solo recuerda cuales de ellas son totalmente necesarias",
    "Transporte":
        "A veces caminar y tratar de evadir la multidud es lo mejor no solo para ahorrar unas monedas, si no para tambien relajarse y quemas algunas calorias",
    "Ropa":
        "La ropa de marca es muy costosa, si no eres muy quisquilloso con lo que comprar siempre es bueno comprar prendas en outlets o almecenes de ofertas de ropa",
    "Salud e higiene":
        "La salud e higiene siempre son relevantes para una vida sana, pero te aconsejo que si no quieres gastar mucho en salud, trata de mantener un estilo de vida que evita que vayas mucho a hospitales",
    "Ocio":
        "Salir con los amigos es divertido, pero tambien puede ser costoso, a veces las mejores experiencias con amigos es solo caminar y contar chistes",
    "Videojuegos":
        "Siempre trata de terminar tus juegos pendientes en vez de comprar uno nuevo que quizas no vayas a jugar",
    "Gasolina":
        "La gasolina es muy costosa hoy en dia, por eso es mejor usar alternativas como bicicletas o transporte publico",
    "Comida rapida":
        "Los placeres culposos como la comida rapida pueden ser tentadoras, pero tambien costosas y malas para la salud, te aconsejo no ir mucho a esos lugares si quieres ahorrar unas monedad y calorias",
    "Compra supermercado":
        "Siempre fijate cuales supermercados tienen ofertas, aveces ir en la semana en vez de esperar al fin de semana es menos costos",
    "Otros gastos":
        "Wow parece que tienes muchos gastos que no quieres revelar, esta bien, esta bien, solo no abuses mucho de lo que no pueda saber pillin",
  };

  Map<String, String> consejosPorCategoria4 = {
    "Alimentación":
        "Planifica tus comidas con antelación y haz una lista de compras. Comprar solo lo necesario te ayudará a evitar gastos innecesarios en alimentos.",
    "Cuentas y pagos":
        "Revisa tus suscripciones mensuales y elimina aquellas que no utilices con frecuencia. Esto reducirá tus gastos mensuales de manera significativa.",
    "Casa":
        "Considera la posibilidad de realizar pequeñas reparaciones en lugar de comprar nuevos artículos para el hogar. También puedes explorar opciones de segunda mano.",
    "Transporte":
        "Investiga programas de carpooling o comparte viajes con amigos y colegas. Esto no solo reduce los costos, sino que también es más ecológico.",
    "Ropa":
        "Explora tiendas de segunda mano o de intercambio de ropa. Puedes encontrar prendas de calidad a precios mucho más bajos que en las tiendas convencionales.",
    "Salud e higiene":
        "Compra medicamentos genéricos en lugar de marcas reconocidas. Además, mantén hábitos saludables para reducir la necesidad de gastos médicos.",
    "Ocio":
        "Busca eventos culturales gratuitos en tu comunidad. Muchas ciudades ofrecen actividades gratuitas que son entretenidas y educativas.",
    "Videojuegos":
        "Espera a que haya ofertas o descuentos en plataformas de juegos en línea antes de comprar nuevos títulos, ademas, con todos los juegos que duran mas de 100 horas es raro que sigas y sigas comprando juegos. También puedes considerar intercambiar juegos con amigos.",
    "Gasolina":
        "Opta por un estilo de conducción más eficiente para ahorrar combustible, en especial hoy en dia que la gasolina solo sigue subiendo de precio (Los Indios si saben negociar ¿No crees?). Mantén tu vehículo en buen estado para mejorar la eficiencia del combustible.",
    "Comida rapida":
        "No voy a juzgar tus habitos alimenticios porque no es mi trabajo, pero mi trabajo si es juzgar tus gastos en esta categoria, se que cocinar puede ser estresante, pero es mejor estresarte antes de tener problemas de colesterol.",
    "Compra supermercado":
        "También puedes comprar cosas más baratas que están cerca de su fecha de expiración en los supermercados. Cosas como leche y queso, incluso frutas y verduras, se pueden congelar y guardar para cuando las necesites.",
    "Otros gastos":
        "Crea un fondo de emergencia para cubrir gastos imprevistos. Establece límites claros para gastos discrecionales y evalúa regularmente tus hábitos de gasto.",
  };

  Map<String, String> consejosPorCategoria5 = {
    "Alimentación":
        "Considera preparar comidas en casa en lugar de comer fuera. Esto te ayudará a ahorrar dinero y a controlar mejor tus gastos en alimentos.",
    "Cuentas y pagos":
        "Revisa tus facturas y encuentra maneras de reducir tus gastos mensuales. Puedes negociar tarifas con proveedores o buscar planes más económicos.",
    "Casa":
        "Evalúa tus gastos en artículos para el hogar. Asegúrate de comprar solo lo esencial y busca ofertas en lugar de optar por productos de lujo.",
    "Transporte":
        "Explora opciones de transporte más económicas, como el uso de transporte público o compartir viajes. También considera caminar o andar en bicicleta cuando sea posible.",
    "Ropa":
        "Evita las compras impulsivas y busca ropa en tiendas de descuento o de segunda mano. También puedes intercambiar ropa con amigos o familiares.",
    "Salud e higiene":
        "Revisa tus gastos en productos de salud e higiene. Compara precios y busca ofertas para ahorrar en medicamentos y productos esenciales.",
    "Ocio":
        "Busca actividades de ocio gratuitas o de bajo costo. Aprovecha eventos comunitarios, parques y actividades al aire libre para divertirte sin gastar mucho.",
    "Videojuegos":
        "WOW AMIGO PARECE QUE SI TE GUSTA ESTE HOOBY. Considera esperar a que los nuevos lanzamientos de videojuegos estén en oferta antes de comprarlos. También puedes buscar opciones de juegos gratuitos o de bajo costo.",
    "Gasolina":
        "Opta por formas más eficientes de transporte y planifica tus viajes para ahorrar en gasolina. Puedes considerar compartir viajes o usar vehículos más económicos.",
    "Comida rapida":
        "Limita la frecuencia de comer comida rápida, ya que puede ser costosa a largo plazo. Prefiere cocinar en casa y planificar tus comidas con antelación.",
    "Compra supermercado":
        "Haz una lista de compras antes de ir al supermercado y apegate a ella. Busca ofertas y descuentos, y considera comprar productos a granel para ahorrar.",
    "Otros gastos":
        "Revisa tus gastos misceláneos y identifica áreas donde puedas recortar gastos. Establece un presupuesto claro para gastos no específicos y sé consciente de tus hábitos de gasto.",
  };

  Map<String, String> consejosPorCategoria6 = {
    "Alimentación":
        "Considera preparar comidas en casa en lugar de comer fuera. Esto te ayudará a ahorrar dinero y a controlar mejor tus gastos en alimentos.",
    "Cuentas y pagos":
        "Revisa tus facturas y encuentra maneras de reducir tus gastos mensuales. Puedes negociar tarifas con proveedores o buscar planes más económicos.",
    "Casa":
        "Evalúa tus gastos en artículos para el hogar. Asegúrate de comprar solo lo esencial y busca ofertas en lugar de optar por productos de lujo.",
    "Transporte":
        "Explora opciones de transporte más económicas, como el uso de transporte público o compartir viajes. También considera caminar o andar en bicicleta cuando sea posible.",
    "Ropa":
        "Evita las compras impulsivas y busca ropa en tiendas de descuento o de segunda mano. También puedes intercambiar ropa con amigos o familiares.",
    "Salud e higiene":
        "Revisa tus gastos en productos de salud e higiene. Compara precios y busca ofertas para ahorrar en medicamentos y productos esenciales.",
    "Ocio":
        "Busca actividades de ocio gratuitas o de bajo costo. Aprovecha eventos comunitarios, parques y actividades al aire libre para divertirte sin gastar mucho.",
    "Videojuegos":
        "WOW AMIGO PARECE QUE SI TE GUSTA ESTE HOOBY. Considera esperar a que los nuevos lanzamientos de videojuegos estén en oferta antes de comprarlos. También puedes buscar opciones de juegos gratuitos o de bajo costo.",
    "Gasolina":
        "Opta por formas más eficientes de transporte y planifica tus viajes para ahorrar en gasolina. Puedes considerar compartir viajes o usar vehículos más económicos.",
    "Comida rapida":
        "Limita la frecuencia de comer comida rápida, ya que puede ser costosa a largo plazo. Prefiere cocinar en casa y planificar tus comidas con antelación.",
    "Compra supermercado":
        "Haz una lista de compras antes de ir al supermercado y apegate a ella. Busca ofertas y descuentos, y considera comprar productos a granel para ahorrar.",
    "Otros gastos":
        "Revisa tus gastos misceláneos y identifica áreas donde puedas recortar gastos. Establece un presupuesto claro para gastos no específicos y sé consciente de tus hábitos de gasto.",
  };

  Map<String, num> umbralesGastoPrecuela = {
    "Alimentación": 30000,
    "Cuentas y pagos": 30000,
    "Casa": 30000,
    "Transporte": 30000,
    "Ropa": 30000,
    "Salud e higiene": 30000,
    "Ocio": 30000,
    "Videojuegos": 30000,
    "Gasolina": 30000,
    "Comida rapida": 30000,
    "Compra supermercado": 30000,
    "Otros gastos": 30000,
  };

  Map<String, num> umbralesGasto = {
    "Alimentación": 50000,
    "Cuentas y pagos": 50000,
    "Casa": 50000,
    "Transporte": 50000,
    "Ropa": 50000,
    "Salud e higiene": 50000,
    "Ocio": 50000,
    "Videojuegos": 50000,
    "Gasolina": 50000,
    "Comida rapida": 50000,
    "Compra supermercado": 50000,
    "Otros gastos": 50000,
  };

  Map<String, num> umbralesGasto2 = {
    "Alimentación": 100000,
    "Cuentas y pagos": 1000000,
    "Casa": 1000000,
    "Transporte": 100000,
    "Ropa": 100000,
    "Salud e higiene": 100000,
    "Ocio": 100000,
    "Videojuegos": 100000,
    "Gasolina": 100000,
    "Comida rapida": 100000,
    "Compra supermercado": 100000,
    "Otros gastos": 100000,
  };

  Map<String, num> umbralesGasto3 = {
    "Alimentación": 150000,
    "Cuentas y pagos": 1500000,
    "Casa": 150000,
    "Transporte": 150000,
    "Ropa": 150000,
    "Salud e higiene": 150000,
    "Ocio": 150000,
    "Videojuegos": 150000,
    "Gasolina": 150000,
    "Comida rapida": 150000,
    "Compra supermercado": 150000,
    "Otros gastos": 150000,
  };

  Map<String, num> umbralesGasto4 = {
    "Alimentación": 200000,
    "Cuentas y pagos": 200000,
    "Casa": 200000,
    "Transporte": 200000,
    "Ropa": 200000,
    "Salud e higiene": 200000,
    "Ocio": 200000,
    "Videojuegos": 200000,
    "Gasolina": 200000,
    "Comida rapida": 200000,
    "Compra supermercado": 200000,
    "Otros gastos": 200000,
  };

  @override
  void initState() {
    super.initState();
    calcularGastosPorCategoria();
  }

  Future<void> calcularGastosPorCategoria() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .collection('gastos')
          .get();
      for (String categoria in categorias) {
        final gastosCategoria = querySnapshot.docs
            .where((doc) => doc['descripcion'] == categoria)
            .map((doc) => doc['gasto'] ?? 0)
            .toList();
        final gastoTotal = gastosCategoria.fold<num>(
            0, (previousValue, element) => previousValue + element);
        setState(() {
          gastosPorCategoria[categoria] = gastoTotal.toInt();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: Text('Consejos'),
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
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .collection('gastos')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final querySnapshot = snapshot.data!;
              for (String categoria in categorias) {
                final gastosCategoria = querySnapshot.docs
                    .where((doc) => doc['descripcion'] == categoria)
                    .map((doc) => doc['gasto'] ?? 0)
                    .toList();
                final gastoTotal = gastosCategoria.fold<num>(
                    0, (previousValue, element) => previousValue + element);
                gastosPorCategoria[categoria] = gastoTotal.toInt();
              }
            }
            return ListView.builder(
              itemCount: categorias.length,
              itemBuilder: (context, index) {
                final categoria = categorias[index];
                final gastoTotal = gastosPorCategoria[categoria] ?? 0;
                final colorCategoria =
                    coloresPorCategoria[categoria] ?? Colors.green;
                //final mensaje = consejosPorCategoria[categoria] ?? "";
                final consejo1 = consejosPorCategoria2[categoria] ?? "";
                final consejo2 = consejosPorCategoria3[categoria] ?? "";
                final consejo3 = consejosPorCategoria4[categoria] ?? "";
                final consejo4 = consejosPorCategoria5[categoria] ?? "";
                final consejo5 = consejosPorCategoria1[categoria] ?? "";

                String consejo = "";

                if (gastoTotal >= (umbralesGasto[categoria] ?? 0)) {
                  consejo = consejo1;
                }

                if (gastoTotal >= (umbralesGasto2[categoria] ?? 0)) {
                  consejo = consejo2;
                }

                if (gastoTotal >= (umbralesGasto3[categoria] ?? 0)) {
                  consejo = consejo3;
                }

                if (gastoTotal >= (umbralesGasto4[categoria] ?? 0)) {
                  consejo = consejo4;
                }

                if (gastoTotal >= (umbralesGastoPrecuela[categoria] ?? 0)) {
                  consejo = consejo5;
                }

                //return Card(
                return Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(
                          vertical: 10.0), // Ajusta el espacio aquí
                      child: Card(
                        color: colorCategoria,
                        child: ListTile(
                          title: Text(categoria),
                          subtitle: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: 8.0),
                                  child: Text(
                                    "Gasto total: \$${gastoTotal.toStringAsFixed(0)}",
                                  ),
                                ),
                                //if (mensaje.isNotEmpty) Text(mensaje),
                                /*if (mensaje.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(mensaje),
                            ),*/
                                if (consejo.isNotEmpty)
                                  Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text(consejo),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
