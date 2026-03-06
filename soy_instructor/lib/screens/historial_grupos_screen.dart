import 'package:flutter/material.dart';
import '../services/database_service.dart';

class HistorialGruposScreen extends StatefulWidget {
  const HistorialGruposScreen({super.key});

  @override
  State<HistorialGruposScreen> createState() => _HistorialGruposScreenState();
}

class _HistorialGruposScreenState extends State<HistorialGruposScreen> {

  final DatabaseService dbService = DatabaseService();
  List<Map<String, dynamic>> grupos = [];

  @override
  void initState() {
    super.initState();
    cargarGrupos();
  }

  Future<void> cargarGrupos() async {
    final data = await dbService.obtenerGrupos();
    setState(() {
      grupos = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Historial de Grupos"),
      ),
      body: grupos.isEmpty
          ? const Center(child: Text("No hay grupos registrados"))
          : ListView.builder(
              itemCount: grupos.length,
              itemBuilder: (context, index) {

                final grupo = grupos[index];

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text("Instructor: ${grupo['instructor']}"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Jugadores: ${grupo['jugadores']}"),
                        Text("Recargas: ${grupo['recargas']}"),
                        Text("Bebidas: ${grupo['bebidas']}"),
                        Text("Fecha: ${grupo['fecha']}"),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}