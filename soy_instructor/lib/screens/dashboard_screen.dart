import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../services/reporte_service.dart';
import 'package:share_plus/share_plus.dart';

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
  String topInstructorGrupos = "N/A";
  int totalGruposInstructor = 0;
  String topInstructorVentas = "N/A";
  int totalVentasInstructor = 0;

  @override
  void initState() {
    super.initState();
    cargarEstadisticas();
  }

  Future<void> cargarEstadisticas() async {

    final stats = await dbService.obtenerEstadisticasHoy();
    final topGrupos = await dbService.obtenerTopInstructorGrupos();
    final topVentas = await dbService.obtenerTopInstructorVentas();

    setState(() {
      gruposHoy = stats["grupos"] ?? 0;
      jugadoresHoy = stats["jugadores"] ?? 0;
      ventasHoy = stats["ventas"] ?? 0;

       if (topGrupos != null) {
    topInstructorGrupos = topGrupos["instructor"];
    totalGruposInstructor = topGrupos["total"];
  }

  if (topVentas != null) {
    topInstructorVentas = topVentas["instructor"];
    totalVentasInstructor = topVentas["total"];
  }
    });
  }
  // cerrar día y generar reporte
  Future<void> cerrarDia() async {

  final db = DatabaseService();
  final reporte = ReporteService();

  final gruposHoy = await db.obtenerGruposHoy();

  if (gruposHoy.isEmpty) {

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("No hay datos para hoy"))
    );

    return;
  }

  final path = await reporte.generarExcel(gruposHoy);

  await Share.shareXFiles(
    [XFile(path)],
    text: "Reporte del día Paintball"
  );
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
            tarjeta("Instructor con más grupos","$topInstructorGrupos ($totalGruposInstructor)",
              Icons.emoji_events
            ),
            tarjeta(
              "Instructor que más vendió",
              "$topInstructorVentas (\$ $totalVentasInstructor)",
              Icons.monetization_on
            ),
            ElevatedButton.icon(
              icon: Icon(Icons.file_download),
              label: Text("Cerrar día y generar reporte"),
              onPressed: cerrarDia,
            ),
          ],
          
        ),
      ),
    );
  }
  
}