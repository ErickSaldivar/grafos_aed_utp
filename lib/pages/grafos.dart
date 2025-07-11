import 'package:flutter/material.dart';
import 'package:grafos_aed/modelos/algoritmos.dart';
import 'package:grafos_aed/modelos/nodo_arista.dart';
import 'package:grafos_aed/widgets/nodo_box.dart';
import 'package:graphview/GraphView.dart';
import 'dart:math';

class Grafos extends StatefulWidget {
  const Grafos({super.key});

  @override
  State<Grafos> createState() => _GrafosState();
}

class _GrafosState extends State<Grafos> {
  int altoResultado = 30;
  bool keyResultado = false;
  int nodoInicial = 1;
  List<InlineSpan> resultadoRich = [];
  final Graph graph = Graph();

  final Nodo nodo1 = Nodo(
    id: 1,
    salientes: [Arista(2, 2), Arista(3, 3), Arista(4, 1)],
  );
  final Nodo nodo2 = Nodo(id: 2, salientes: [Arista(4, 2)]);
  final Nodo nodo3 = Nodo(id: 3, salientes: [Arista(4, 3), Arista(5, 2)]);
  final Nodo nodo4 = Nodo(id: 4, salientes: [Arista(6, 3), Arista(7, 2)]);
  final Nodo nodo5 = Nodo(id: 5, salientes: [Arista(6, 7), Arista(7, 5)]);
  final Nodo nodo6 = Nodo(id: 6, salientes: [Arista(7, 6)]);
  final Nodo nodo7 = Nodo(id: 7, salientes: []);

  final SugiyamaConfiguration builder = SugiyamaConfiguration()
    ..bendPointShape = CurvedBendPointShape(curveLength: 40)
    ..nodeSeparation = 55
    ..levelSeparation = 55
    ..orientation = SugiyamaConfiguration.ORIENTATION_LEFT_RIGHT;

  final Map<int, Node> nodeMap = {};
  final Map<int, List<Map<String, dynamic>>> pesosYColoresPorNodo = {};
  final Map<String, Color> aristaColorMap = {};
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    final nodos = [nodo1, nodo2, nodo3, nodo4, nodo5, nodo6, nodo7];
    for (var nodo in nodos) {
      final node = Node.Id(nodo.id);
      nodeMap[nodo.id] = node;
      graph.addNode(node);
      pesosYColoresPorNodo[nodo.id] = [];
    }

    for (var nodo in nodos) {
      for (var arista in nodo.salientes) {
        final color = Color.fromARGB(
          255,
          random.nextInt(256),
          random.nextInt(256),
          random.nextInt(256),
        );
        final edgeKey = '${nodo.id}->${arista.destino}';
        aristaColorMap[edgeKey] = color;

        graph.addEdge(
          nodeMap[nodo.id]!,
          nodeMap[arista.destino]!,
          paint: Paint()
            ..color = color
            ..style = PaintingStyle.stroke
            ..strokeWidth = arista.peso.toDouble(),
        );

        pesosYColoresPorNodo[nodo.id]!.add({
          'peso': arista.peso,
          'color': color,
          'destino': arista.destino,
        });
      }
    }
  }

  void mostrarResultado() async {
    altoResultado = 25;
    await Future.delayed(Duration(milliseconds: 300));
    setState(() {
      altoResultado = keyResultado ? 130 : 30;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Camino más corto usando Dijkstra',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text('Problema 2', style: TextStyle(fontSize: 16)),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Ciudad inicial ',
                            style: TextStyle(fontSize: 26),
                          ),
                          Container(
                            height: 38,
                            width: 40,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue, width: 2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListWheelScrollView(
                              itemExtent: 40,
                              diameterRatio: 20,
                              perspective: 0.01,
                              physics: const FixedExtentScrollPhysics(),
                              onSelectedItemChanged: (index) {
                                setState(() {
                                  nodoInicial = index + 1;
                                });
                              },
                              children: List.generate(
                                7,
                                (index) => Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          final algoritmos = Algoritmos(graph, nodeMap.length);
                          setState(() {
                            keyResultado = true;
                            resultadoRich = [];
                            final resultadoDijkstra = algoritmos.dijkstra(
                              nodoInicial,
                            );
                            final rutas = resultadoDijkstra['rutas'];

                            for (var r in rutas) {
                              resultadoRich.add(
                                TextSpan(
                                  text: 'Ruta a ciudad ${r['destino']}: ',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );

                              for (int i = 0; i < r['camino'].length; i++) {
                                final nodoActual = r['camino'][i];
                                resultadoRich.add(
                                  TextSpan(text: '$nodoActual'),
                                );

                                if (i < r['camino'].length - 1) {
                                  final siguiente = r['camino'][i + 1];
                                  final color =
                                      aristaColorMap['$nodoActual->$siguiente'] ??
                                      Colors.black;
                                  resultadoRich.add(
                                    TextSpan(
                                      text: ' → ',
                                      style: TextStyle(
                                        color: color,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                }
                              }
                              resultadoRich.add(
                                TextSpan(
                                  text:
                                      ' (Distancia: ${r['distancia']} millas)\n',
                                ),
                              );
                            }
                          });
                          mostrarResultado();
                        },
                        child: const Text('Calcular rutas con Dijkstra'),
                      ),
                      const SizedBox(height: 10),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: altoResultado.toDouble(),
                        width: 400,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue, width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(8),
                          child: RichText(
                            text: TextSpan(
                              children: keyResultado
                                  ? resultadoRich
                                  : [
                                      const TextSpan(
                                        text:
                                            'Presiona el botón para ejecutar Dijkstra',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Container(
                    width: 700,
                    height: 420,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: InteractiveViewer(
                      constrained: false,
                      boundaryMargin: const EdgeInsets.all(100),
                      child: GraphView(
                        graph: graph,
                        algorithm: SugiyamaAlgorithm(builder),
                        builder: (Node node) {
                          final int id = node.key!.value as int;
                          final datos = pesosYColoresPorNodo[id] ?? [];
                          return graphRect(id, datos);
                        },
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
