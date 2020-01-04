import 'package:flutter/material.dart';

import './screens/product_detail_screen.dart';
import './screens/products_overview_screens.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.amber,
        accentColor: Colors.deepOrange,
        fontFamily: "Lato"

      ),
      title: 'Flutter Demo',
      home: ProductOverviewScreen(),
      routes: {
        ProductDetailScreen.routeName: (ctx)=> ProductDetailScreen(),

      },
    );
  }
}
