import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mi_cora/providers/transactions_provider.dart';
import 'package:mi_cora/screens/add/add_screen.dart';
import 'package:mi_cora/widgets/history_horizontal.dart';
import 'package:mi_cora/widgets/histoty_vertical.dart';
import 'package:provider/provider.dart';



class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {

  void initState() {
    super.initState();
    final myProvider = Provider.of<TransactionProvider>(context, listen: false);
    myProvider.loadTransactions();
    myProvider.LoadFilteredTransactions();
  }


  void mostrarCupertinoAlerta(BuildContext context, int id, Function eliminarTransaccion) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text('Eliminar gasto'),
        content: Text('Esta seguro de eliminar el registro'),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CupertinoDialogAction(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancelar'),
          ),
          CupertinoDialogAction(
            onPressed: () {
              eliminarTransaccion(id); 
              Navigator.of(context).pop(); 
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Gasto eliminado'),
                  backgroundColor: Colors.red[300],
                ),
              );
            },
            child: Text('Eliminar'),
          ),
            ],
          )
        ],
      );
    },
  );
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
    TransactionProvider myProvider = context.watch<TransactionProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Historial de gastos'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: isLandscape==false ? historyVertical(context) : historyHorizontal(context),
      bottomNavigationBar: isLandscape==false ? BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: Colors.blue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              isSelected: false,
              iconSize: 40,
              icon: Icon(Icons.home,color: Colors.white ),
              onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
              },
            ),
            IconButton(
              isSelected: true,
              iconSize: 40,
              icon: Icon(Icons.history, ),
              onPressed: () {
              },
            ),
          ],
        ),
      ) : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: isLandscape==false ? SizedBox(
        width: 70,
        height: 70,
        
        child: FloatingActionButton(
          isExtended: true,
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(70),
          ),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => AddSpent(id: null,)));
          },
          child: Icon(Icons.add, size: 30, color: Colors.white),
        ),
      ) : null,
    );
  }
}


