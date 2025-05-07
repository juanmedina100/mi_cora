import 'package:flutter/material.dart';
import 'package:mi_cora/providers/transactions_provider.dart';
import 'package:mi_cora/screens/add/add_screen.dart';
import 'package:mi_cora/screens/history/history_ecreen.dart';
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
          routes: {
            '/home': (context) => HomeScreen(),
            '/add': (context) => const AddSpent(id: null),
            '/history': (context) => const HistoryScreen(),
          },
          initialRoute: '/home',
          // title: 'Mi Cora',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              primary: const Color.fromRGBO(23, 107, 135, 100),
              secondary: Colors.blueAccent,
              background: Colors.white,
              surface: Colors.white,

            ),
            bottomAppBarTheme: const BottomAppBarTheme(
              color: Colors.blue,
              elevation: 3,
              shape: CircularNotchedRectangle(),
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              centerTitle: true,
              elevation: 0,
            ),
            cardTheme: const CardTheme(
              color: Colors.white,
              margin: EdgeInsets.all(5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
          ),
          // home: Scaffold(
          //   body: HomeScreen(),
          // ),
        );
      }
    );
  }
}