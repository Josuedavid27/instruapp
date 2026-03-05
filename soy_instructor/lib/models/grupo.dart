class Grupo {
  int? id;
  String instructor;
  int jugadores;
  DateTime fecha;
  int recargas;
  int bebidas;

  Grupo({
    this.id,
    required this.instructor,
    required this.jugadores,
    required this.fecha,
    required this.recargas,
    required this.bebidas,
  });

  // Convertir a Map para guardar en base de datos
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'instructor': instructor,
      'jugadores': jugadores,
      'fecha': fecha.toIso8601String(),
      'recargas': recargas,
      'bebidas': bebidas,
    };
  }

  // Convertir desde Map (leer base de datos)
  factory Grupo.fromMap(Map<String, dynamic> map) {
    return Grupo(
      id: map['id'],
      instructor: map['instructor'],
      jugadores: map['jugadores'],
      fecha: DateTime.parse(map['fecha']),
      recargas: map['recargas'],
      bebidas: map['bebidas'],
    );
  }
}