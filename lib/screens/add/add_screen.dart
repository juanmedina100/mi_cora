import 'package:flutter/material.dart';



class AddSpent extends StatefulWidget {
  const AddSpent({super.key});

  @override
  State<AddSpent> createState() => _AddSpentState();
}

class _AddSpentState extends State<AddSpent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add Spent'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text('Add Spent Screen, \nAqui el formulario para agregar un gasto.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}