import 'package:flutter/material.dart';
import '../services/database_service.dart';
import 'historial_grupos_screen.dart';

class RegistroGrupoScreen extends StatefulWidget {
  const RegistroGrupoScreen({super.key});

  @override
  State<RegistroGrupoScreen> createState() => _RegistroGrupoScreenState();
}

class _RegistroGrupoScreenState extends State<RegistroGrupoScreen> {

  final TextEditingController instructorController = TextEditingController();
  final TextEditingController jugadoresController = TextEditingController();
  final TextEditingController recargasController = TextEditingController();
  final TextEditingController bebidasController = TextEditingController();

  final DatabaseService dbService = DatabaseService();

 Future<void> guardarGrupo() async {

  int recargas = int.parse(recargasController.text);
  int bebidas = int.parse(bebidasController.text);

  int precioRecarga = 10000;
  int precioBebida = 3000;

  int total = (recargas * precioRecarga) + (bebidas * precioBebida);

  final grupo = {
    'instructor': instructorController.text,
    'jugadores': int.parse(jugadoresController.text),
    'fecha': DateTime.now().toIso8601String(),
    'recargas': recargas,
    'bebidas': bebidas,
    'total': total
  };

  await dbService.insertarGrupo(grupo);

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("Grupo guardado - Total: \$ $total"))
  );

  instructorController.clear();
  jugadoresController.clear();
  recargasController.clear();
  bebidasController.clear();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registrar Grupo"),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HistorialGruposScreen(),
                ),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller: instructorController,
              decoration: const InputDecoration(
                labelText: "Instructor",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: jugadoresController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Cantidad de jugadores",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: recargasController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Recargas",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: bebidasController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Bebidas",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: guardarGrupo,
                child: const Text("Guardar Grupo"),
              ),
            )
            
            
          ],
        ),
      ),
    );
  }
}