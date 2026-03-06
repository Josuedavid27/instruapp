import 'package:flutter/material.dart';
import 'registro_grupo_screen.dart';
import 'historial_grupos_screen.dart';
import 'dashboard_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _paginaActual = 0;

  final List<Widget> _pantallas = [
    const DashboardScreen(),
    const RegistroGrupoScreen(),
    const HistorialGruposScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pantallas[_paginaActual],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _paginaActual,
        onTap: (index){
          setState(() {
            _paginaActual = index;
          });
        },

        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: "Registrar",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: "Historial",
          ),

        ],
      ),
    );
  }
}