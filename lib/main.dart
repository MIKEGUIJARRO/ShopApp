import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import './screens/product_detail_screen.dart';
import './screens/products_overview_screens.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './screens/cart_screen.dart';
import './providers/orders.dart';
import './screens/orders_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          //ChangeNotifierProvider.value se usa cuando no pasamos el contexto y no es necesario
          //Ademas con ChangeNotifierProvider.value es recomendado para listas y grids donde
          //el orden de la info cambia de orden constantemente y no se pierda con el state

          //Ponemos en la raiz de nuestro widget tree ChangeNotifierProvider
          //nos permitira registrar una clase que podra escuchar en widgets hijos
          //de esta forma reconstruira estas clases si la data cambia.

          value: Products(),
          /* builder: (ctx) {
          //Entrega esta clase a los widgets hijos
          return Products();
        }, */
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProvider.value(
          value: Orders(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
            primarySwatch: Colors.amber,
            accentColor: Colors.deepOrange,
            fontFamily: "Lato"),
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        home: ProductOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrdersScreen.routenName: (ctx) => OrdersScreen(),
        },
      ),
    );
  }
}
