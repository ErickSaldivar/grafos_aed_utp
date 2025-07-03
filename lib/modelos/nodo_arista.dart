class Arista {
  final int destino;
  final int peso;

  Arista(this.destino, this.peso);
}

class Nodo {
  final int id;
  final List<Arista> salientes;

  Nodo({required this.id, required this.salientes});
}
