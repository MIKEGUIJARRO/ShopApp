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
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(productId);

    return Scaffold(
      /* appBar: AppBar(
        title: Text(loadedProduct.title),
      ), */
      body: CustomScrollView(
        slivers: <Widget>[
          //Scrollable areas on the screens
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedProduct.title),
              background: Hero(
                tag: loadedProduct.id,
                child: Image.network(
                  loadedProduct.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            SizedBox(
              height: 10,
            ),
            Text(
              "\$${loadedProduct.price}",
              style: TextStyle(color: Colors.grey, fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                child: Text(
                  "${loadedProduct.description}",
                  textAlign: TextAlign.center,
                  softWrap: true,
                )),
            SizedBox(
              height: 500,
            )
          ]))
        ],
      ),
    );
  }
}
