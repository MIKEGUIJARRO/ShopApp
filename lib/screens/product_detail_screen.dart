import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {

  /* final String title;
  final double price;

  ProductDetailScreen({@required this.title, @required this.price});
 */

  static const routeName= "/product-detail";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("title"),
      ),
    );
  }
}