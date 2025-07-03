// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore: library_prefixes
import 'dart:math' as Math;

class Transporte {
  final List<List<double>> costos;
  final List<int> oferta;
  final List<int> demanda;
  final List<List<int>> plan;

  Transporte(this.costos, List<int> oferta, List<int> demanda)
    : oferta = List<int>.from(oferta),
      demanda = List<int>.from(demanda),
      plan = List.generate(
        oferta.length,
        (_) => List.filled(demanda.length, 0),
      );

  void resolverCostoMinimo() {
    List<int> ofertaActual = List<int>.from(oferta);
    List<int> demandaActual = List<int>.from(demanda);

    while (true) {
      int minI = -1, minJ = -1;
      double minCosto = double.infinity;
      //Busca celda de menor costo posible
      for (int i = 0; i < ofertaActual.length; i++) {
        if (ofertaActual[i] == 0) continue;
        for (int j = 0; j < demandaActual.length; j++) {
          if (demandaActual[j] == 0) continue;
          if (costos[i][j] < minCosto) {
            minCosto = costos[i][j];
            minI = i;
            minJ = j;
          }
        }
      }

      //Si ya no hay mas celdas disponibles, termina
      if (minI == -1 || minJ == -1) break;

      int cantidad = Math.min(ofertaActual[minI], demandaActual[minJ]);
      plan[minI][minJ] = cantidad;
      ofertaActual[minI] -= cantidad;
      demandaActual[minI] -= cantidad;
    }
  }

  List<List<int>> getPlan() => plan;

  double getCostoTotal() {
    double total = 0;
    for (var i = 0; i < plan.length; i++) {
      for (var j = 0; j < plan[0].length; j++) {
        total += plan[i][j] * costos[i][j];
      }
    }
    return total;
  }
}
