class Arista {
  final int destino;
  final int peso;

  Arista(this.destino, this.peso);
}

class Nodo {
  final int id; // Identificador/valor del nodo
  final List<Arista> salientes; // Lista de aristas salientes del nodo

  Nodo({required this.id, required this.salientes});
}
