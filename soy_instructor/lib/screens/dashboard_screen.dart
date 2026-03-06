import 'package:flutter/material.dart';
import '../services/database_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  final DatabaseService dbService = DatabaseService();

  int gruposHoy = 0;
  int jugadoresHoy = 0;
  int ventasHoy = 0;

  @override
  void initState() {
    super.initState();
    cargarEstadisticas();
  }

  Future<void> cargarEstadisticas() async {

    final stats = await dbService.obtenerEstadisticasHoy();

    setState(() {
      gruposHoy = stats["grupos"] ?? 0;
      jugadoresHoy = stats["jugadores"] ?? 0;
      ventasHoy = stats["ventas"] ?? 0;
    });
  }

  Widget tarjeta(String titulo, String valor, IconData icono) {
    return Card(
      elevation: 4,
      child: ListTile(
        leading: Icon(icono, size: 35),
        title: Text(titulo),
        subtitle: Text(
          valor,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text("Dashboard Paintball"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            tarjeta("Grupos hoy", gruposHoy.toString(), Icons.groups),

            const SizedBox(height: 15),

            tarjeta("Jugadores hoy", jugadoresHoy.toString(), Icons.person),

            const SizedBox(height: 15),

            tarjeta("Ventas hoy", "\$ $ventasHoy", Icons.attach_money),

          ],
        ),
      ),
    );
  }
}