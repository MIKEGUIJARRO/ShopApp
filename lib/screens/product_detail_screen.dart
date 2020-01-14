import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  /* final String title;
  final double price;

  ProductDetailScreen({@required this.title, @required this.price});
 */

  static const routeName = "/product-detail";

  @override
  Widget build(BuildContext context) {
    //Recibimos el Id al momento de crear la pagina
    final productId = ModalRoute.of(context).settings.arguments as String;
    //listen: false nos permite cerrar la via de comunicacion con el provider 
    // con el fin de que no se reconstruya este view. No estamos interesados en updates
    final loadedProduct = Provider.of<Products>(context, listen: false).findById(productId);
        

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
    );
  }
}
