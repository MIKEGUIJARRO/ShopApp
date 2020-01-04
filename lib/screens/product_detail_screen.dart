import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {

  /* final String title;
  final double price;

  ProductDetailScreen({@required this.title, @required this.price});
 */

  static const routeName= "/product-detail";

  @override
  Widget build(BuildContext context) {

    //Recibimos el Id al momento de crear la pagina
    final productId = ModalRoute.of(context).settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text("title"),
      ),
    );
  }
}