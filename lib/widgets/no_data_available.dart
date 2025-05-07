import 'package:flutter/material.dart';

class NoDataAvailable extends StatelessWidget {
  const NoDataAvailable({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    bool isLandscape = false;
    Orientation orientation = MediaQuery.of(context).orientation;
    if (orientation == Orientation.landscape) {
      isLandscape = true;
    } else {
      isLandscape = false;
    }


    return Center(child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: isLandscape == false ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20,),
                Image.asset('assets/images/logo.png',width: 150,height: 150,),
                Text("No hay registros",style: TextStyle(fontSize: 16,fontWeight: FontWeight.normal),),
              ],
            ) : SizedBox(
              width: 300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20,),
                  Image.asset('assets/images/logo.png',width: 150,height: 150,),
                  SizedBox(width: 20,),
                  Text("No hay registros",style: TextStyle(fontSize: 16,fontWeight: FontWeight.normal),),
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}