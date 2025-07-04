import 'package:flutter/material.dart';
import 'package:grafos_aed/modelos/transporte.dart';
import 'package:grafos_aed/widgets/textfield_costes.dart';

class Costes extends StatefulWidget {
  const Costes({super.key});

  @override
  State<Costes> createState() => _CostesState();
}

class _CostesState extends State<Costes> {
  List<List<TextEditingController>> costosText = List.generate(
    2,
    (_) => List.generate(3, (_) => TextEditingController()),
  );
  List<TextEditingController> ofertaText = List.generate(
    2,
    (_) => TextEditingController(),
  );
  List<TextEditingController> demandaText = List.generate(
    3,
    (_) => TextEditingController(),
  );
  //String buffer que imprimira todo el resultado
  StringBuffer sb = StringBuffer('');

  int option = 0;

  void predefinirValores() {
    costosText[0][0].text = '0.07';
    costosText[0][1].text = '0.05';
    costosText[0][2].text = '0.1';
    costosText[1][0].text = '0.03';
    costosText[1][1].text = '0.11';
    costosText[1][2].text = '0.04';
    ofertaText[0].text = '5000';
    ofertaText[1].text = '5000';
    demandaText[0].text = '4000';
    demandaText[1].text = '2000';
    demandaText[2].text = '2500';
  }

  void resolverCostoMinimo() {
    List<List<double>> costos = List.generate(2, (_) => List.filled(3, 0.0));
    List<int> oferta = List.filled(2, 0);
    List<int> demanda = List.filled(3, 0);

    //Leer Costos
    for (var i = 0; i < 2; i++) {
      for (var j = 0; j < 3; j++) {
        costos[i][j] = double.parse(costosText[i][j].text);
      }
    }

    //Leer Ofertas
    for (var i = 0; i < 2; i++) {
      oferta[i] = int.parse(ofertaText[i].text);
    }

    //Leer Demandas
    for (var i = 0; i < 3; i++) {
      demanda[i] = int.parse(demandaText[i].text);
    }

    Transporte transporte = Transporte(costos, oferta, demanda);
    transporte.resolverCostoMinimo();

    List<List<int>> plan = transporte.getPlan();

    List<String> imprentas = ['Los Ángeles', 'Nueva York'];
    List<String> distribuidores = ['Chicago', 'Seattle', 'Washington D.C.'];
    sb.writeln('Plan de envío (Método de costo mínimo):\n');
    for (int i = 0; i < plan.length; i++) {
      for (int j = 0; j < plan[0].length; j++) {
        if (plan[i][j] > 0) {
          sb.writeln(
            '- ${imprentas[i]} → ${distribuidores[j]}: ${plan[i][j]} revistas',
          );
        }
      }
    }

    sb.writeln(
      '\nCosto total: \$${transporte.getCostoTotal().toStringAsFixed(2)}',
    );
  }

  void resolverVoguel() {
    List<List<double>> costos = List.generate(2, (_) => List.filled(3, 0.0));
    List<int> oferta = List.filled(2, 0);
    List<int> demanda = List.filled(3, 0);

    //Leer Costos
    for (var i = 0; i < 2; i++) {
      for (var j = 0; j < 3; j++) {
        costos[i][j] = double.parse(costosText[i][j].text);
      }
    }

    //Leer Ofertas
    for (var i = 0; i < 2; i++) {
      oferta[i] = int.parse(ofertaText[i].text);
    }

    //Leer Demandas
    for (var i = 0; i < 3; i++) {
      demanda[i] = int.parse(demandaText[i].text);
    }

    Transporte transporte = Transporte(costos, oferta, demanda);
    sb.writeln(transporte.resolverVogelConDetalle());

    List<List<int>> plan = transporte.getPlan();

    List<String> imprentas = ['Los Ángeles', 'Nueva York'];
    List<String> distribuidores = ['Chicago', 'Seattle', 'Washington D.C.'];

    for (int i = 0; i < plan.length; i++) {
      for (int j = 0; j < plan[0].length; j++) {
        if (plan[i][j] > 0) {
          sb.writeln(
            '- ${imprentas[i]} → ${distribuidores[j]}: ${plan[i][j]} revistas',
          );
        }
      }
    }

    sb.writeln(
      '\nCosto total: \$${transporte.getCostoTotal().toStringAsFixed(2)}',
    );
  }

  void limpiarValores() {
    for (var i = 0; i < 2; i++) {
      for (var j = 0; j < 3; j++) {
        costosText[i][j].clear();
        demandaText[j].clear();
      }
      ofertaText[i].clear();
    }
    sb.clear();
    setState(() {});
  }

  void resolverBtn() {
    sb.clear();
    Future.delayed(Duration.zero, () {
      if (option == 0) {
        resolverCostoMinimo();
      } else {
        resolverVoguel();
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Text(
              'Cálculo de costos de envío Magazine INC.',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Text(
              'Ingrese los costos de envío (\$ por revista)',
              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 850,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 65),
                  Text(
                    'Los Angeles ->',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextFieldCosto(
                    controller: costosText[0][0],
                    ciudad: 'Chicago',
                  ),
                  TextFieldCosto(
                    controller: costosText[0][1],
                    ciudad: 'Seattle',
                  ),
                  TextFieldCosto(
                    controller: costosText[0][2],
                    ciudad: 'Washington D.C.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: 850,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 70),
                  Text(
                    'Nueva York ->',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextFieldCosto(
                    controller: costosText[1][0],
                    ciudad: 'Chicago',
                  ),
                  TextFieldCosto(
                    controller: costosText[1][1],
                    ciudad: 'Seattle',
                  ),
                  TextFieldCosto(
                    controller: costosText[1][2],
                    ciudad: 'Washington D.C.',
                  ),
                ],
              ),
            ),

            SizedBox(
              width: 950,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 280,
                    height: 115,
                    child: Row(
                      children: [
                        const Text(
                          'Ofertas:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 20),
                        Column(
                          children: [
                            TextFieldCosto(
                              controller: ofertaText[0],
                              ciudad: 'Los Angeles',
                            ),
                            const SizedBox(height: 15),
                            TextFieldCosto(
                              controller: ofertaText[1],
                              ciudad: 'Nueva York',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    height: 175,
                    child: Row(
                      children: [
                        const Text(
                          'Demandas:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 20),
                        Column(
                          children: [
                            TextFieldCosto(
                              controller: demandaText[0],
                              ciudad: 'Chicago',
                            ),
                            const SizedBox(height: 15),
                            TextFieldCosto(
                              controller: demandaText[1],
                              ciudad: 'Seattle',
                            ),
                            const SizedBox(height: 15),
                            TextFieldCosto(
                              controller: demandaText[2],
                              ciudad: 'Washington D.C.',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 300,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: predefinirValores,
                                child: Text('Predefinir'),
                              ),
                              ElevatedButton(
                                onPressed: limpiarValores,
                                child: Text('Limpiar Valores'),
                              ),
                            ],
                          ),
                        ),
                        Text('Seleccione el método de solución:'),
                        ToggleButtons(
                          isSelected: [option == 0, option == 1],
                          onPressed: (index) {
                            setState(() {
                              option = index;
                            });
                          },
                          borderColor: Colors.blue,
                          fillColor: Colors.blue[100],
                          selectedColor: Colors.blue,
                          borderRadius: BorderRadius.circular(8),
                          selectedBorderColor: Colors.blue[900],
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Text(
                                'Método de costo mínimo',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Text(
                                'Método Voguel',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            onPressed: resolverBtn,
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                Colors.blue,
                              ),
                              elevation: WidgetStatePropertyAll(15.0),
                            ),
                            child: Text(
                              'RESOLVER',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue, width: 2),
              ),
              height: 226,
              width: 600,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: -12,
                    left: 14,
                    child: Text(
                      '| RESULTADOS: |',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        backgroundColor: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    top: 15,
                    left: 20,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: SingleChildScrollView(
                        child: Text(
                          sb.toString(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
