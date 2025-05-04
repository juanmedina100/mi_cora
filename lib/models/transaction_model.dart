

class TransactionModel {
  final int id;
  final double monto;
  final String fecha;
  final String descripcion;
  final String tipo;
  final String categoria;

  TransactionModel({
    required this.id,
    required this.monto,
    required this.fecha,
    required this.descripcion,
    required this.tipo,
    required this.categoria,
  });
}