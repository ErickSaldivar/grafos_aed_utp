import 'package:graphview/GraphView.dart';
import 'package:flutter/material.dart';

class Algoritmos {
  final Graph _graph;
  final int numNodos;
  late List<bool> visitado;
  static const int inf = 1 << 30; // Valor grande como infinito simbólico

  Algoritmos(this._graph, this.numNodos);

  Map<String, dynamic> disjkstra(int origen) {
    final dist = List<int>.filled(numNodos + 1, inf);
    final pred = List<int>.filled(numNodos + 1, -1);
    visitado = List<bool>.filled(numNodos + 1, false);
    dist[origen] = 0;

    for (int i = 1; i <= numNodos; i++) {
      int u = _obtenerMinimo(dist);
      if (u == -1) break;
      visitado[u] = true;

      for (var edge in _graph.edges) {
        int from = edge.source.key!.value as int;
        int to = edge.destination.key!.value as int;

        if (from == u && !visitado[to]) {
          int peso = edge.paint?.strokeWidth.round() ?? 1;
          if (dist[from] + peso < dist[to]) {
            dist[to] = dist[from] + peso;
            pred[to] = from;
          }
        }
      }
    }

    // Generar rutas con colores
    List<Map<String, dynamic>> rutas = [];
    for (int i = 1; i <= numNodos; i++) {
      if (i == origen || dist[i] == inf) continue;
      List<int> path = [];
      int current = i;
      while (current != -1) {
        path.insert(0, current);
        current = pred[current];
      }

      // Obtener colores
      List<Color> colores = [];
      for (int j = 0; j < path.length - 1; j++) {
        final edge = _graph.edges.firstWhere(
          (e) =>
              (e.source.key!.value == path[j] &&
              e.destination.key!.value == path[j + 1]),
        );
        colores.add(edge.paint?.color ?? Colors.black);
      }

      rutas.add({
        'destino': i,
        'distancia': dist[i],
        'camino': path,
        'colores': colores,
      });
    }

    return {'distancias': dist.sublist(1), 'rutas': rutas};
  }

  int _obtenerMinimo(List<int> dist) {
    int min = inf;
    int minIndex = -1;

    for (int i = 1; i <= numNodos; i++) {
      if (!visitado[i] && dist[i] < min) {
        min = dist[i];
        minIndex = i;
      }
    }
    return minIndex;
  }
}
