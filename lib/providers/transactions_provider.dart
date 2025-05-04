import 'package:flutter/material.dart';
import 'package:mi_cora/models/transaction_model.dart';
import 'package:mi_cora/models/transaction_model_insert.dart';
import '../services/service_transaciones.dart';

class TransactionProvider with ChangeNotifier {
  List<TransactionModel> _transactions = [];
  double _totalExpenses = 0.0;


  List<TransactionModel> get transactions => _transactions;
  double get totalExpenses => _totalExpenses;

  TransactionProvider() {
    loadTransactions();
  }

  Future<void> loadTransactions() async {
      try {
        _transactions = await obtenerTransacciones();
        _calculateTotalExpenses();
        notifyListeners();
      } catch (e) {
        print('Error al cargar transacciones: $e');
      }
    }


  Future<void> _loadTransactions() async {
    try {
      _transactions = await obtenerTransacciones();
      _calculateTotalExpenses();
      notifyListeners();
    } catch (e) {
      print('Error al cargar transacciones: $e');
    }
  }

  void _calculateTotalExpenses() {
    _totalExpenses = _transactions.fold(0.0, (sum, transaction) => sum + transaction.monto);
  }

  Future<void> addTransaction(Map<String, dynamic> newTransaction) async {
    try {
      final transaction = TransactionModelInsert(
        monto: newTransaction['monto'] as double,
        fecha: newTransaction['fecha'] as String,
        descripcion: newTransaction['descripcion'] as String,
        tipo: newTransaction['tipo'] as String,
        categoria: newTransaction['categoria'] as String,
      );
      await insertartransaccion(transaction);
      debugPrint('Transacción añadida: $transaction');
      await _loadTransactions();
    } catch (e) {
      print('Error al añadir transacción: $e');
    }
  }

  Future<void> editTransaction(int index, Map<String, dynamic> updatedTransaction) async {
    try {
      if (index >= 0 && index < _transactions.length) {
        final transaction = TransactionModel(
          id: _transactions[index].id,
          monto: updatedTransaction['monto'] as double,
          fecha: updatedTransaction['fecha'] as String,
          descripcion: updatedTransaction['descripcion'] as String,
          tipo: updatedTransaction['tipo'] as String,
          categoria: updatedTransaction['categoria'] as String,
        );
        await actualizarTransaccion(transaction);
        await _loadTransactions();
      }
    } catch (e) {
      print('Error al editar transacción: $e');
    }
  }

  Future<void> deleteTransaction(int index) async {
    try {
      if (index >= 0 && index < _transactions.length) {
        await eliminarTransaccion(_transactions[index].id);
        await _loadTransactions();
      }
    } catch (e) {
      print('Error al eliminar transacción: $e');
    }
  }
}