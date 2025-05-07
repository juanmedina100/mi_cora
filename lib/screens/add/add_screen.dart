import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mi_cora/models/categorie_model.dart';
import 'package:mi_cora/models/transaction_model_insert.dart';
import 'package:mi_cora/providers/transactions_provider.dart';
import 'package:mi_cora/screens/history/history_ecreen.dart';
import 'package:mi_cora/screens/home/home_screen.dart';
import 'package:provider/provider.dart';



class AddSpent extends StatefulWidget {
  final int? id;
  const AddSpent({super.key, required this.id});

  @override
  State<AddSpent> createState() => _AddSpentState();
}

class _AddSpentState extends State<AddSpent> {

  String? _selectedItem;

  Future<void> _showModal(BuildContext context) async {
    final myprovider = Provider.of<TransactionProvider>(context, listen: false);
    List<CategorieModel> miLista = [
    CategorieModel(id: 1, nombre: 'Alimentos',icono: 'assets/images/alimentos.png'),
    CategorieModel(id: 2, nombre: 'Transporte',icono: 'assets/images/transporte.png'),
    CategorieModel(id: 3, nombre: 'Entretenimiento',icono: 'assets/images/entretenimiento.png'),
    CategorieModel(id: 4, nombre: 'Salud',icono: 'assets/images/salud.png'),
    CategorieModel(id: 5, nombre: 'Educación',icono: 'assets/images/educacion.png'),
    CategorieModel(id: 6, nombre: 'Hogar',icono: 'assets/images/hogar.png'),
    CategorieModel(id: 7, nombre: 'Otros',icono: 'assets/images/otros.png'),
  ];

    final resultado = await showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                'Categorias',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: miLista.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Card(child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Image.asset(miLista[index].icono, width: 40, height: 40),
                            const SizedBox(width: 10),
                            Text(miLista[index].nombre),
                          ],
                        ),
                      )),
                      onTap: () {
                        Navigator.pop(context, miLista[index].nombre);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );

    if (resultado != null) {
      setState(() {
        _selectedItem = resultado;
      });
    }
  }

  TextEditingController _montoController = TextEditingController();
  TextEditingController _fechaController = TextEditingController();
  TextEditingController _descripcionController = TextEditingController();
  TextEditingController _categoriaController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  void initState() {
    super.initState();
    if(widget.id != null) {
     final myProvider = Provider.of<TransactionProvider>(context, listen: false);
    myProvider.getTransactionById(widget.id!).then((transaction) {
      setState(() {
        _montoController.text = myProvider.selectedTransaction!.monto.toString();
        _fechaController.text = myProvider.selectedTransaction!.fecha;
        _descripcionController.text = myProvider.selectedTransaction!.descripcion.toString();
        _categoriaController.text = myProvider.selectedTransaction!.categoria.toString();
      });
    });
     }
  }

  @override
  Widget build(BuildContext context) {

    bool isLandscape = false;
    Orientation orientation = MediaQuery.of(context).orientation;
    if (orientation == Orientation.landscape) {
      isLandscape = true;
    } else {
      isLandscape = false;
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: widget.id != null ? const Text('Editar Gasto') : const Text('Agregar Gasto'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Card(
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Monto',border: OutlineInputBorder(),focusedBorder: OutlineInputBorder()),
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
                      SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Fecha',border: OutlineInputBorder(),focusedBorder: OutlineInputBorder()),
                        keyboardType: TextInputType.datetime,
                        controller: _fechaController,
                        readOnly: true,
                        onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        // Formatear la fecha seleccionada
                        String formattedDate = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                        // _fechaController = formattedDate
                        debugPrint(formattedDate);
                        _fechaController.text = formattedDate; // Actualiza el controlador de texto
                        // Aquí puedes guardar la fecha formateada en una variable o usarla como desees
                      });
                    }
                        },
                        validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa una fecha';
                            }
                            return null;
                          },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(labelText: 'Descripción',border: OutlineInputBorder(),focusedBorder: OutlineInputBorder()),
                        keyboardType: TextInputType.text,
                        controller: _descripcionController,
                        validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa una descripción';
                            }
                            return null;
                          },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Categoria',border: OutlineInputBorder(),focusedBorder: OutlineInputBorder()),
                        keyboardType: TextInputType.text,
                        controller: _categoriaController,
                        readOnly: true,
                        onTap: () async {
                            await _showModal(context);
                            setState(() {
                              // _showModal(context);
                              _categoriaController.text = _selectedItem!;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa una categoria';
                            }
                            return null;
                          },
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CupertinoButton.filled(child: Text("Cancelar"), onPressed: (){
                            Navigator.pop(context);
                          }),
                          CupertinoButton.filled(
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
                            if(widget.id != null) {
                              gasto['id'] = widget.id!; // Agrega el ID si es necesario   
                              await context.read<TransactionProvider>().editTransaction(widget.id!, gasto);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Gasto actualizado',textAlign: TextAlign.center,),
                                backgroundColor: Colors.green[300],
                                behavior: SnackBarBehavior.floating,),
                              );                           
                            }else{
                            await context.read<TransactionProvider>().addTransaction(gasto);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Gasto guardado')
                              ,backgroundColor: Colors.green[300],
                              behavior: SnackBarBehavior.floating),
                            );
                          }
                            debugPrint('Gasto guardado: $gasto');
                            Navigator.pop(context);
                          }else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Por favor completa todos los campos'),backgroundColor: Colors.red[300],),
                            );
                          }
                          // Aquí puedes agregar la lógica para guardar el gasto
                          
                        },
                        child: Text('Guardar'),
                      ),
                        ],
                      ),
                      
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: isLandscape==false ? BottomAppBar(
        shape: CircularNotchedRectangle(),
        // color: Colors.blue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              iconSize: 40,
              icon: Icon(Icons.home, color: Colors.white),
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()));
              },
            ),
            IconButton(
              iconSize: 40,
              icon: Icon(Icons.history, color: Colors.white),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoryScreen()));
                // Acción para el botón de configuración
              },
            ),
          ],
        ),
      ) : null,
    );
  }
}