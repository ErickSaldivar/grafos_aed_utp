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
      ); // Inicializa el plan con ceros

  void resolverCostoMinimo() {
    List<int> ofertaActual = List<int>.from(oferta);
    List<int> demandaActual = List<int>.from(demanda);

    while (true) {
      int minI = -1, minJ = -1;
      double minCosto = double.infinity;
      // Busca la celda de menor costo disponible
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

      // Si no hay más celdas válidas, salimos
      if (minI == -1 || minJ == -1) break;

      // Cantidad a asignar: el mínimo entre oferta de i y demanda de j
      int cantidad = Math.min(ofertaActual[minI], demandaActual[minJ]);
      plan[minI][minJ] = cantidad;

      // Restamos de la oferta de la fila i y la demanda de la columna j
      ofertaActual[minI] -= cantidad;
      demandaActual[minJ] -= cantidad;
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

  /// Calcula y devuelve un log detallado del método Vogel de aproximación.
  String resolverVogelConDetalle() {
    List<int> ofertaActual = List<int>.from(oferta);
    List<int> demandaActual = List<int>.from(demanda);
    List<bool> filaOcupada = List<bool>.filled(oferta.length, false);
    List<bool> colOcupada = List<bool>.filled(demanda.length, false);
    StringBuffer log = StringBuffer();
    log.writeln('>>> Método de Aproximación de Vogel (VAM):\n');

    int paso = 1;
    while (true) {
      double maxPen = -1;
      double mejorMinAbs = double.infinity;
      bool esFila = true;
      int idx = -1;

      // 1) Penalidad por fila
      for (int i = 0; i < ofertaActual.length; i++) {
        if (filaOcupada[i] || ofertaActual[i] == 0) continue;
        // obtener dos menores costos en la fila i
        List<int> menores = _obtenerDosMenores(costos[i], colOcupada);
        int m0 = menores[0], m1 = menores[1];
        if (m0 == -1 || m1 == -1) continue;
        double pen = costos[i][m1] - costos[i][m0];
        double minAbs = costos[i][m0];
        if (pen > maxPen || (pen == maxPen && minAbs < mejorMinAbs)) {
          maxPen = pen;
          mejorMinAbs = minAbs;
          esFila = true;
          idx = i;
        }
      }

      // 2) Penalidad por columna
      for (int j = 0; j < demandaActual.length; j++) {
        if (colOcupada[j] || demandaActual[j] == 0) continue;
        double min1 = double.infinity, min2 = double.infinity;
        for (int i = 0; i < ofertaActual.length; i++) {
          if (filaOcupada[i] || ofertaActual[i] == 0) continue;
          double v = costos[i][j];
          if (v < min1) {
            min2 = min1;
            min1 = v;
          } else if (v < min2) {
            min2 = v;
          }
        }
        if (min2 == double.infinity)
          continue; // Si min2 es infinito, no hay suficientes valores
        double pen = min2 - min1;
        double minAbs = min1;
        if (pen > maxPen || (pen == maxPen && minAbs < mejorMinAbs)) {
          maxPen = pen;
          mejorMinAbs = minAbs;
          esFila = false;
          idx = j;
        }
      }

      // 3) Si no se encontró penalidad válida, asignación final en la primera celda libre
      if (idx == -1) {
        // Selección de la primera celda libre
        int iSel = filaOcupada.indexWhere(
          (oc) => !oc && ofertaActual[filaOcupada.indexOf(oc)] > 0,
        );
        // Si no hay fila libre, buscar columna libre
        int jSel = colOcupada.indexWhere(
          (oc) => !oc && demandaActual[colOcupada.indexOf(oc)] > 0,
        );
        // Si no hay fila ni columna libre, terminamos
        if (iSel == -1 || jSel == -1) break;
        // Asignación final en la celda libre
        int q = Math.min(ofertaActual[iSel], demandaActual[jSel]);
        plan[iSel][jSel] = q;
        ofertaActual[iSel] -= q;
        demandaActual[jSel] -= q;
        log.writeln('Asignación final (una sola celda): $q en ($iSel,$jSel)');
        if (ofertaActual[iSel] == 0) filaOcupada[iSel] = true;
        if (demandaActual[jSel] == 0) colOcupada[jSel] = true;
        continue;
      }

      // 4) Selección de la celda con costo mínimo según fila o columna
      int iSel, jSel;
      if (esFila) {
        iSel = idx;
        jSel = _buscarMinEnFila(costos[iSel], colOcupada);
      } else {
        jSel = idx;
        iSel = _buscarMinEnColumna(costos, jSel, filaOcupada);
      }
      if (iSel == -1 || jSel == -1) break;

      int q = Math.min(ofertaActual[iSel], demandaActual[jSel]);
      plan[iSel][jSel] = q;
      ofertaActual[iSel] -= q;
      demandaActual[jSel] -= q;
      log.writeln(
        'Paso $paso: Asignar $q unidades en ($iSel,$jSel)  costo ${costos[iSel][jSel].toStringAsFixed(2)}',
      );
      paso++;

      if (ofertaActual[iSel] == 0) filaOcupada[iSel] = true;
      if (demandaActual[jSel] == 0) colOcupada[jSel] = true;
    }

    log.writeln(
      '\nAsignaciones finales y costo total calculado posteriormente.',
    );
    return log.toString();
  }

  /// Encuentra los dos índices de menor costo en un arreglo, omitiendo columnas ocupadas
  List<int> _obtenerDosMenores(List<double> row, List<bool> colOcupada) {
    int m0 = -1, m1 = -1;
    double min0 = double.infinity, min1 = double.infinity;
    for (int j = 0; j < row.length; j++) {
      if (colOcupada[j]) continue;
      double v = row[j];
      if (v < min0) {
        min1 = min0;
        m1 = m0;
        min0 = v;
        m0 = j;
      } else if (v < min1) {
        min1 = v;
        m1 = j;
      }
    }
    return [m0, m1];
  }

  /// Busca índice de menor costo en una fila, omitiendo columnas ocupadas
  int _buscarMinEnFila(List<double> row, List<bool> colOcupada) {
    double min = double.infinity;
    int idx = -1;
    for (int j = 0; j < row.length; j++) {
      if (colOcupada[j]) continue;
      if (row[j] < min) {
        min = row[j];
        idx = j;
      }
    }
    return idx;
  }

  /// Busca índice de menor costo en una columna, omitiendo filas ocupadas
  int _buscarMinEnColumna(
    List<List<double>> costos,
    int col,
    List<bool> filaOcupada,
  ) {
    double min = double.infinity;
    int idx = -1;
    for (int i = 0; i < costos.length; i++) {
      if (filaOcupada[i]) continue;
      if (costos[i][col] < min) {
        min = costos[i][col];
        idx = i;
      }
    }
    return idx;
  }
}
