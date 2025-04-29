import 'package:flutter/material.dart';
import 'package:mi_cora/screens/add/add_screen.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Cora'),
        centerTitle: true,
      ),
      body: Center(
        child: Text('Hello, \nAca resumen de los gastos totales y una lista de transacciones.',textAlign: TextAlign.center,style: TextStyle(fontSize: 18),),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddSpent()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}