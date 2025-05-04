import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mi_cora/models/transaction_model_insert.dart';
import 'package:mi_cora/providers/transactions_provider.dart';
import 'package:provider/provider.dart';



class AddSpent extends StatefulWidget {
  const AddSpent({super.key});

  @override
  State<AddSpent> createState() => _AddSpentState();
}

class _AddSpentState extends State<AddSpent> {

  TextEditingController _montoController = TextEditingController();
  TextEditingController _fechaController = TextEditingController();
  TextEditingController _descripcionController = TextEditingController();
  TextEditingController _categoriaController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add Spent'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Monto'),
                  keyboardType: TextInputType.number,
                  controller: _montoController,
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa un monto';
                    }
                    final deoubleValue = double.tryParse(value);
                    if (deoubleValue == null || deoubleValue <= 0) {
                      return 'Por favor ingresa un monto válido';
                    }
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Fecha'),
                  keyboardType: TextInputType.datetime,
                  controller: _fechaController,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Descripción'),
                  keyboardType: TextInputType.text,
                  controller: _descripcionController,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Categoria'),
                  keyboardType: TextInputType.text,
                  controller: _categoriaController,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Aquí puedes agregar la lógica para guardar el gasto
                      final gasto = {
                        'monto': double.parse(_montoController.text),
                        'fecha': _fechaController.text,
                        'descripcion': _descripcionController.text,
                        'tipo': 'Gasto', // o 'Ingreso' según corresponda
                        'categoria': _categoriaController.text, // Cambia esto según tu lógica
                      };

                      await context.read<TransactionProvider>().addTransaction(gasto);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Gasto guardado'),backgroundColor: Colors.green[300],),
                      );
                      debugPrint('Gasto guardado: $gasto');
                      Navigator.pop(context);
                    }else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Por favor completa todos los campos'),backgroundColor: Colors.red[300],),
                      );
                    }
                    // Aquí puedes agregar la lógica para guardar el gasto
                    
                  },
                  child: Text('Guardar Gasto'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}