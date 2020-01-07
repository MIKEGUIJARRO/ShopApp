import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/product_detail_screen.dart';
import './screens/products_overview_screens.dart';
import './providers/products.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      //Ponemos en la raiz de nuestro widget tree ChangeNotifierProvider
      //nos permitira registrar una clase que podra escuchar en widgets hijos
      //de esta forma reconstruira estas clases si la data cambia.
      builder: (ctx) {
        //Entrega esta clase a los widgets hijos
        return Products();
      },
      child: MaterialApp(
        theme: ThemeData(
            primarySwatch: Colors.amber,
            accentColor: Colors.deepOrange,
            fontFamily: "Lato"),
        title: 'Flutter Demo',
        home: ProductOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
        },
      ),
    );
  }
}
