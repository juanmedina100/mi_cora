import 'package:flutter/material.dart';
import 'package:mi_cora/providers/transactions_provider.dart';
import 'package:mi_cora/screens/home/home_screen.dart';
import 'package:provider/provider.dart';





class MyAppMain extends StatefulWidget {
  const MyAppMain({super.key});

  @override
  State<MyAppMain> createState() => _MyAppMainState();
}

class _MyAppMainState extends State<MyAppMain> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
      ],
      builder: (context,_) {
        return MaterialApp(
          title: 'Mi Cora',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
          ),
          home: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blue,
              title: const Text('Mi Cora'),
              centerTitle: true,
            ),
            body: HomeScreen(),
          ),
        );
      }
    );
  }
}