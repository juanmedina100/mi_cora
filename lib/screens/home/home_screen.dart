import 'package:flutter/material.dart';
import 'package:mi_cora/providers/transactions_provider.dart';
import 'package:mi_cora/screens/add/add_screen.dart';
import 'package:provider/provider.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  void initState() {
    super.initState();
    final myProvider = Provider.of<TransactionProvider>(context, listen: false);
    myProvider.loadTransactions();
    // Aquí puedes inicializar cualquier cosa que necesites al cargar la pantalla
  }


  @override
  Widget build(BuildContext context) {
  
    TransactionProvider myProvider = context.watch<TransactionProvider>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: myProvider.transactions.length
        ,itemBuilder: (context,Index,){
          return Card(
            child: ListTile(
              title: Text(myProvider.transactions[Index].monto.toString(),
              textAlign: TextAlign.center,style: TextStyle(fontSize: 22),),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(myProvider.transactions[Index].descripcion.toString(),
              textAlign: TextAlign.center,style: TextStyle(fontSize: 18),),
                  Text(myProvider.transactions[Index].fecha.toString(),
              textAlign: TextAlign.center,style: TextStyle(fontSize: 16),),
                  Text(myProvider.transactions[Index].categoria.toString()),
                ],
              ),
              
              trailing: Icon(Icons.delete),
            ),
          );
        }),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: Colors.blue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              iconSize: 40,
              icon: Icon(Icons.home, color: Colors.white),
              onPressed: () {
                // Acción para el botón de inicio
              },
            ),
            IconButton(
              iconSize: 40,
              icon: Icon(Icons.settings, color: Colors.white),
              onPressed: () {
                // Acción para el botón de configuración
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        width: 70,
        height: 70,
        
        child: FloatingActionButton(
          isExtended: true,
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(70),
          ),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => AddSpent()));
          },
          child: Icon(Icons.add, size: 30, color: Colors.white),
        ),
      ),
    );
  }
}