import 'package:flutter/material.dart';
import 'package:mi_cora/models/transaction_filtered.dart';
import 'package:mi_cora/models/transaction_model.dart';
import 'package:mi_cora/models/transaction_model_insert.dart';
import 'package:mi_cora/services/cora_database.dart';
import 'package:sqflite/sqflite.dart';

Future<List<TransactionModel>> obtenerTransacciones() async {
  final db = await DatabaseHelper().database;
  final List<Map<String, dynamic>> maps = await db.query('transacciones',orderBy: 'fecha DESC');
  return List.generate(maps.length, (i) {
    return TransactionModel(
      id: maps[i]['id'],
      monto: maps[i]['monto'],
      fecha:maps[i]['fecha'] as String,
      descripcion: maps[i]['descripcion'],
      tipo: maps[i]['tipo'],
      categoria: maps[i]['categoria'],
    );
  });
}


Future<List<TransactionFiltered>> obtenerTransaccionesUltimos6Meses() async {
  final db = await DatabaseHelper().database;
  final List<Map<String, dynamic>> maps = await db.rawQuery(
    '''
    SELECT strftime('%m/%Y', date(fecha)) AS periodo, SUM(monto) AS total_monto
    FROM transacciones
    WHERE fecha >= date('now', '-6 months')
    GROUP BY periodo
    ORDER BY fecha DESC
    limit 6
    '''
  );
  debugPrint("Transacciones filtradas_______service________: $maps");
  return List.generate(maps.length, (i) {
    return TransactionFiltered(
      periodo: maps[i]['periodo'],
      totalGastos: maps[i]['total_monto'] as double,
    );
  });
  // return resultado;
}



Future<void> insertartransaccion(TransactionModelInsert transaccion) async {
  final db = await DatabaseHelper().database;
  await db.insert(
    'transacciones',
    {'monto': transaccion.monto, 'fecha': transaccion.fecha,
    "descripcion":transaccion.descripcion,
    'tipo': transaccion.tipo,
    'categoria': transaccion.categoria},
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
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
      'categoria': transaccion.categoria,
    },
    where: 'id = ?',
    whereArgs: [transaccion.id],
  );
}


Future<TransactionModel?> obtenerTransaccionPorId(int id) async {
  final db = await DatabaseHelper().database;
  final List<Map<String, dynamic>> maps = await db.query(
    'transacciones',
    where: 'id = ?',
    whereArgs: [id],
    limit: 1, // Solo queremos un resultado
  );

  if (maps.isNotEmpty) {
    return TransactionModel(
      id: maps[0]['id'],
      monto: maps[0]['monto'],
      fecha: maps[0]['fecha'] as String,
      descripcion: maps[0]['descripcion'],
      tipo: maps[0]['tipo'],
      categoria: maps[0]['categoria'],
    );
  } else {
    return null; // Si no se encuentra el registro
  }
}

