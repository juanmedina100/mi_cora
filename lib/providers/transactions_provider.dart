import 'package:flutter/material.dart';
import 'package:mi_cora/models/transaction_filtered.dart';
import 'package:mi_cora/models/transaction_model.dart';
import 'package:mi_cora/models/transaction_model_insert.dart';
import '../services/service_transaciones.dart';

class TransactionProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  List<TransactionModel> _transactions = [];
  List<TransactionFiltered> _transactionsFiltered = [];
  List<TransactionFiltered> get transactionsFiltered => _transactionsFiltered;
  List<TransactionFiltered> _transactionsFilteredDay = [];
  List<TransactionFiltered> get transactionsFilteredDay => _transactionsFilteredDay;

  TransactionModel? _selectedTransaction;
  TransactionModel? get selectedTransaction => _selectedTransaction;

  double _totalExpenses = 0.0;


  List<TransactionModel> get transactions => _transactions;
  double get totalExpenses => _totalExpenses;

  TransactionProvider() {
    loadTransactions();
  }

  Future<void> LoadFilteredTransactions() async {
    debugPrint("Cargando transacciones filtradas...");
    try {
      _isLoading = true;
      debugPrint("Cargando transacciones filtradas...debugPrint");
      _transactionsFiltered = await obtenerTransaccionesUltimos6Meses();
      _calculateTotalExpenses();
      debugPrint("Transacciones filtradas__provider__: $_transactionsFiltered");
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error al cargar transacciones filtradas: $e');
    }
  }

  Future<void> LoadFilteredTransactionsDay() async {
  debugPrint("Cargando transacciones filtradas...");
  try {
    _isLoading = true;
      // debugPrint("Cargando transacciones filtradas...debugPrint");
      _transactionsFilteredDay = await obtenerTransaccionesPorDia();
      _calculateTotalExpenses();
      // debugPrint("Transacciones filtradas__provider__: $_transactionsFilteredDay");
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error al cargar transacciones filtradas: $e');
    }
  }

  Future<void> loadTransactions() async {
      try {
        _isLoading = true;
        // await Future.delayed(const Duration(seconds: 4));
        _transactions = await obtenerTransacciones();
        _calculateTotalExpenses();
        _isLoading = false;
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
      await _loadTransactions();
      await LoadFilteredTransactions();
      notifyListeners();
    } catch (e) {
      print('Error al añadir transacción: $e');
    }
  }

  Future<void> editTransaction(int index, Map<String, dynamic> updatedTransaction) async {
    debugPrint("Editando transacción con ID___edit: $index");
    try {
      if (index >= 0) { //&& index < _transactions.length
        final transaction = TransactionModel(
          id: index,
          monto: updatedTransaction['monto'] as double,
          fecha: updatedTransaction['fecha'] as String,
          descripcion: updatedTransaction['descripcion'] as String,
          tipo: updatedTransaction['tipo'] as String,
          categoria: updatedTransaction['categoria'] as String,
        );
        debugPrint("Transacción editada___edit: $transaction");
        await actualizarTransaccion(transaction);
        await _loadTransactions();
        await LoadFilteredTransactions();
        notifyListeners();
      }
    } catch (e) {
      print('Error al editar transacción: $e');
    }
  }

  Future<void> deleteTransaction(int id) async {
    try {
      if (id >= 0) { // linea mal evaluada
        await eliminarTransaccion(id);
        await _loadTransactions();
        await LoadFilteredTransactions();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error al eliminar transacción: $e');
    }
  }

  Future<void> getTransactionById(int id) async {
    try {
      if (id >= 0) {
        _selectedTransaction = await obtenerTransaccionPorId(id);
        notifyListeners();
      }
    } catch (e) {
      print('Error al obtener transacción por ID: $e');
    }
  }



}