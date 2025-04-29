

import 'package:mi_cora/models/transaction_model.dart';
import 'package:mi_cora/models/transaction_model_insert.dart';
import 'package:mi_cora/services/cora_database.dart';
import 'package:sqflite/sqflite.dart';

Future<List<TransactionModel>> obtenerTransacciones() async {
  final db = await DatabaseHelper().database;
  final List<Map<String, dynamic>> maps = await db.query('transacciones');
  return List.generate(maps.length, (i) {
    return TransactionModel(
      id: maps[i]['id'],
      monto: maps[i]['monto'],
      fecha: maps[i]['fecha'],
      descripcion: maps[i]['descripcion'],
      tipo: maps[i]['tipo'],
      categoriaId: maps[i]['categoriaId'],
    );
  });
}

Future<void> insertartransaccion(TransactionModelInsert transaccion) async {
  try {
    final db = await DatabaseHelper().database;
    await db.insert(
      'transacciones',
      {'monto': transaccion.monto, 'fecha': transaccion.fecha,
      "descripcion":transaccion.descripcion, 
      'tipo': transaccion.tipo, 
      'categoriaId': transaccion.categoriaId},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  } catch (e) {
    print('Error al insertar usuario: $e');
  }
}

Future<void> eliminarTransaccion(int id) async {
  final db = await DatabaseHelper().database;
  await db.delete(
    'transacciones',
    where: 'id = ?',
    whereArgs: [id],
  );
}
Future<void> actualizarTransaccion(TransactionModel transaccion) async {
  final db = await DatabaseHelper().database;
  await db.update(
    'transacciones',
    {
      'monto': transaccion.monto,
      'fecha': transaccion.fecha,
      'descripcion': transaccion.descripcion,
      'tipo': transaccion.tipo,
      'categoriaId': transaccion.categoriaId,
    },
    where: 'id = ?',
    whereArgs: [transaccion.id],
  );
}




