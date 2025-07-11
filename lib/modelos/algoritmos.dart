import 'package:graphview/GraphView.dart';
import 'package:flutter/material.dart';

class Algoritmos {
  final Graph _graph; // Grafo que contiene los nodos y aristas
  final int numNodos;
  late List<bool> visitado;
  static const int inf = 1 << 30; // Valor grande como infinito simbólico

  Algoritmos(this._graph, this.numNodos);

  Map<String, dynamic> dijkstra(int origen) {
    final dist = List<int>.filled(
      numNodos + 1,
      inf,
    ); // Distancias inicializadas a infinito
    final pred = List<int>.filled(
      numNodos + 1,
      -1,
    ); // Predecesores inicializados a -1
    visitado = List<bool>.filled(numNodos + 1, false); // Nodos visitados
    dist[origen] = 0; // Distancia al nodo origen es 0

    for (int i = 1; i <= numNodos; i++) {
      // Obtener el nodo con la distancia mínima no visitado
      int u = _obtenerMinimo(dist);
      if (u == -1) break;
      visitado[u] = true;

      // Recorrer las aristas del nodo u
      for (var edge in _graph.edges) {
        int from =
            edge.source.key!.value
                as int; // Nodo Origen (.key.value es casteado a int)
        int to =
            edge.destination.key!.value
                as int; // Nodo Destino (.key.value es casteado a int)

        // Si la arista es del nodo u y el destino no ha sido visitado
        if (from == u && !visitado[to]) {
          // Peso de la arista (usando el ancho del trazo como peso) con el fin de pintar en el resultado
          int peso = edge.paint?.strokeWidth.round() ?? 1;
          // Actualizar la distancia si es menor
          if (dist[from] + peso < dist[to]) {
            dist[to] = dist[from] + peso;
            pred[to] = from;
          }
        }
      }
    }

    // Generar rutas con colores
    List<Map<String, dynamic>> rutas =
        []; // Lista de rutas en mapas -> más abajo se explica porque
    // Recorrer los nodos para construir las rutas
    for (int i = 1; i <= numNodos; i++) {
      if (i == origen || dist[i] == inf) {
        continue;
      } // Ignorar el origen y nodos inalcanzables
      List<int> path = []; // Lista del camino usado
      int current = i; // Nodo actual
      // Reconstruir el camino desde el nodo actual hasta el origen
      while (current != -1) {
        path.insert(0, current); // inserta el nodo al inicio del camino
        current = pred[current]; // Actualizar el nodo actual al predecesor
      }

      // Obtener colores
      List<Color> colores = [];
      // Recorrer el camino para obtener los colores de las aristas
      for (int j = 0; j < path.length - 1; j++) {
        // Buscar la arista correspondiente al camino
        // Osea el camino del inicio pero al revez -> fin - inicio
        final edge = _graph.edges.firstWhere(
          (e) =>
              (e.source.key!.value == path[j] &&
              e.destination.key!.value == path[j + 1]),
        );
        colores.add(
          edge.paint?.color ?? Colors.black,
        ); // Agregar el color de la arista a la lista colores
      }

      // Agrega la ruta(mapa) a la lista de rutas
      rutas.add({
        'destino': i,
        'distancia': dist[i],
        'camino': path,
        'colores': colores,
      }); //recordar que mapa es un objeto clave-valor
      // la clave es el nombre del atributo y el valor es el valor del atributo
    }

    // Retorna un mapa con las distancias y las rutas
    return {'distancias': dist.sublist(1), 'rutas': rutas};
    // Se usa sublist(1) para omitir el índice 0, ya que las distancias en la
    // lista comienzan desde el indice 1, el primero haria que se contara a sí Mismo(origen),
    // lo cual es irrelevante en este caso.
  }

  /// Método privado para obtener el índice del nodo con la distancia mínima no visitado
  int _obtenerMinimo(List<int> dist) {
    int min = inf;
    int minIndex = -1;

    for (int i = 1; i <= numNodos; i++) {
      if (!visitado[i] && dist[i] < min) {
        min = dist[i];
        minIndex = i;
      }
    }
    // Si no se encontró un nodo no visitado con distancia finita, retorna -1
    return minIndex;
  }
}
