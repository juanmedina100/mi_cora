import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mi_cora/providers/transactions_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TransactionProvider(),
      child: const MaterialApp(home: Test()),
    ),
  );
}

class Test extends StatelessWidget {
  const Test({super.key});

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);
    transactionProvider.addTransaction({'description': 'Prueba 1', 'amount': 10.0, 'date': DateTime.now().toIso8601String()});
    transactionProvider.addTransaction({'description': 'Prueba 2', 'amount': 20.0, 'date': DateTime.now().toIso8601String()});

    Future.delayed(const Duration(seconds: 2), () {
      print("Transacciones: ${transactionProvider.transactions}");
      print("Total: ${transactionProvider.totalExpenses}");
    });

    return const Scaffold(body: Center(child: Text('Verificando la consola...')));
  }
}