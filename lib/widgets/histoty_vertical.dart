import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mi_cora/providers/transactions_provider.dart';
import 'package:mi_cora/screens/add/add_screen.dart';
import 'package:mi_cora/utils/utils.dart';
import 'package:mi_cora/widgets/no_data_available.dart';
import 'package:provider/provider.dart';

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
              eliminarTransaccion(id); // Llama a la función de eliminación
              Navigator.of(context).pop(); // Cierra el diálogo
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



Padding historyVertical(BuildContext context) {
  TransactionProvider myProvider = context.watch<TransactionProvider>();
  return Padding(
        padding: const EdgeInsets.all(8.0),
        child: myProvider.transactions.length > 0 ? ListView.builder(
          itemCount: myProvider.transactions.length
          ,itemBuilder: (context,Index,){
            return Card(
              child: ListTile(
                title: Text(formatoMoneda(myProvider.transactions[Index].monto),
                textAlign: TextAlign.center,style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(myProvider.transactions[Index].descripcion.toString(),
                textAlign: TextAlign.center,style: TextStyle(fontSize: 18),maxLines: 2, overflow: TextOverflow.ellipsis,),
                    Text(myProvider.transactions[Index].fecha.toString(),
                textAlign: TextAlign.center,style: TextStyle(fontSize: 16),),
                    Text(myProvider.transactions[Index].categoria.toString()),
                  ],
                ),
                trailing: Column(
                  children: [
                    
                    IconButton(onPressed: (){
                      mostrarCupertinoAlerta(context, myProvider.transactions[Index].id, (id) {
                        myProvider.deleteTransaction(id);
                      });
                    }, icon: Icon(Icons.delete,color: Colors.red,)),
                  ],
                ),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddSpent(id: myProvider.transactions[Index].id,)));
                },
              ),
            );
          }) : NoDataAvailable()
  );
    }


