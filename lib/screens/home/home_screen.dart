import 'package:flutter/material.dart';
import 'package:mi_cora/models/transaction_filtered.dart';
import 'package:mi_cora/providers/transactions_provider.dart';
import 'package:mi_cora/screens/history/history_ecreen.dart';
import 'package:mi_cora/utils/utils.dart';
import 'package:mi_cora/widgets/no_data_available.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';






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
    myProvider.LoadFilteredTransactionsDay();
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
      appBar: isLandscape==false ? AppBar(title: const Text('Mi cora'),centerTitle: true,automaticallyImplyLeading: false,
      // actions: [IconButton(onPressed: (){},icon: Icon(Icons.info),)],
      ) : null,
      body: myProvider.totalExpenses == 0 ? 
      NoDataAvailable() :  
      SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0,25.0,25.0,8.0),
              child: isLandscape==false ? Card(
                child: ListTile(
                  title: Text('Gastos',style: TextStyle(fontSize: 32,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                  subtitle: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(formatoMoneda(myProvider.totalExpenses),textAlign: TextAlign.center,style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
                  ),
                ),
              ) : null,
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                    child: Column(
                      children: [
                        SizedBox(height: 10,),
                        SfCartesianChart(
                          primaryXAxis: CategoryAxis(),
                          title: ChartTitle(text: 'Grafica de gastos'),
                          legend: Legend(isVisible: true),
                          tooltipBehavior: TooltipBehavior(enable: true),
                          series: <CartesianSeries<TransactionFiltered, String>>[
                            ColumnSeries<TransactionFiltered, String>(
                              dataSource: myProvider.transactionsFilteredDay,
                              xValueMapper: (TransactionFiltered sales, _) => sales.periodo,
                              yValueMapper: (TransactionFiltered sales, _) => sales.totalGastos,
                              name: 'Gastos',
                              dataLabelSettings: DataLabelSettings(isVisible: true),
                            ),
                      ],
                        ),
                      ],)
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: isLandscape==false ? BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: Colors.blue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              isSelected: true,
              iconSize: 40,
              icon: Icon(Icons.home,),
              onPressed: () {
              },
            ),
            IconButton(
              iconSize: 40,
              icon: Icon(Icons.history, color: Colors.white),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryScreen()));
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
            Navigator.pushNamed(context, "/add", arguments: null);
          },
          child: Icon(Icons.add, size: 30, color: Colors.white),
        ),
      ) : null,
    );
  }
}








  