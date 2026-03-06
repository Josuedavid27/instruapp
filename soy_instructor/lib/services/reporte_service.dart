import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';

class ReporteService {

  Future<String> generarExcel(List<Map<String, dynamic>> grupos) async {

    var excel = Excel.createExcel();
    Sheet sheet = excel['Reporte'];

    sheet.appendRow([
      "Instructor",
      "Jugadores",
      "Recargas",
      "Bebidas",
      "Total",
      "Fecha"
    ]);

    for (var grupo in grupos) {
      sheet.appendRow([
        grupo["instructor"],
        grupo["jugadores"],
        grupo["recargas"],
        grupo["bebidas"],
        grupo["total"],
        grupo["fecha"]
      ]);
    }

    final directory = await getApplicationDocumentsDirectory();
    final path = "${directory.path}/reporte_paintball.xlsx";

    File(path)
      ..createSync(recursive: true)
      ..writeAsBytesSync(excel.encode()!);

    return path;
  }
}