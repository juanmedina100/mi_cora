import 'package:intl/intl.dart';

// formatos de moneda
String formatoMoneda(double amount) {
  final formatter = NumberFormat.currency(locale: 'es_ES', symbol: '\$', customPattern: '\$ #,##0.00');
  return formatter.format(amount);
}


String extraerMesYAnio(String fecha) {
  List<String> partes = fecha.split('/');

  DateTime fechaConvertida = DateTime(
    int.parse(partes[2]), // Año
    int.parse(partes[1]), // Mes
    int.parse(partes[0]), // Día
  );
  int mes = fechaConvertida.month;
  int anio = fechaConvertida.year;

  return '$mes/$anio';
}