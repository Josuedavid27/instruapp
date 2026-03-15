import 'package:flutter/material.dart';
import '../services/database_service.dart';

class EditarGrupoScreen extends StatefulWidget {

  final Map<String, dynamic> grupo;

  const EditarGrupoScreen({super.key, required this.grupo});

  @override
  State<EditarGrupoScreen> createState() => _EditarGrupoScreenState();
}

class _EditarGrupoScreenState extends State<EditarGrupoScreen> {

  final DatabaseService dbService = DatabaseService();

  late TextEditingController instructorController;
  late TextEditingController jugadoresController;
  late TextEditingController recargasController;
  late TextEditingController bebidasController;

  @override
  void initState() {
    super.initState();

    instructorController =
        TextEditingController(text: widget.grupo["instructor"]);

    jugadoresController =
        TextEditingController(text: widget.grupo["jugadores"].toString());

    recargasController =
        TextEditingController(text: widget.grupo["recargas"].toString());

    bebidasController =
        TextEditingController(text: widget.grupo["bebidas"].toString());
  }

  Future<void> actualizarGrupo() async {

    int recargas = int.parse(recargasController.text);
    int bebidas = int.parse(bebidasController.text);

    int precioRecarga = 10000;
    int precioBebida = 3000;

    int total = (recargas * precioRecarga) + (bebidas * precioBebida);

    final grupoActualizado = {
      "id": widget.grupo["id"],
      "instructor": instructorController.text,
      "jugadores": int.parse(jugadoresController.text),
      "recargas": recargas,
      "bebidas": bebidas,
      "total": total,
      "fecha": widget.grupo["fecha"]
    };

    await dbService.actualizarGrupo(grupoActualizado);

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text("Editar Grupo"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            TextField(
              controller: instructorController,
              decoration: const InputDecoration(labelText: "Instructor"),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: jugadoresController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Jugadores"),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: recargasController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Recargas"),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: bebidasController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Bebidas"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: actualizarGrupo,
              child: const Text("Actualizar Grupo"),
            )

          ],
        ),
      ),
    );
  }
}