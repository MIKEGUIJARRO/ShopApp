import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_detail_screen.dart';
import '../providers/product.dart';

import '../providers/cart.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  /* final String id;
  final String title;
  final String imageUrl;

  ProductItem({this.id, this.title, this.imageUrl}); */

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    //El widget Consumer sustituye la variable final product.
    //ESte aproach nos da ventajas:
    //Con Provider.of<Product> el metodo build se manda llamar cuando esta data cambie
    //Con Consumer<Product> solo se reconstruye una parte del widget tree

    /* Nota final: se decidio poner tener dos formas de escuchar los cambios de producto
    1. Con Provider.of escuchamos al momento de inicializar el producto y cerramos canal
    2. Con el widget Consumer wrapeamos el boton para escuchar cambios de manera permanente*/

    final authData = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                  arguments: product.id);
              //Con arguments enviamos informacion al momento del push screen
              /* Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => ProductDetailScreen(
                        title: title,
                        price: 0,
                      ))); */
            },
            child: FadeInImage(
              placeholder: AssetImage('assets/images/product-placeholder.png'),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            )),
        footer: GridTileBar(
          leading: Consumer<Product>(
            builder: (ctx, product, _) => IconButton(
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border),
              onPressed: () {
                try {
                  product.toggleFavoriteStatus(authData.token, authData.userId);
                } catch (error) {
                  print(error);
                }
              },
              color: Theme.of(context).accentColor,
            ),
          ),
          backgroundColor: Colors.black87,
          title: Text(product.title, textAlign: TextAlign.center),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(product.id, product.price, product.title);
              Scaffold.of(context).removeCurrentSnackBar();
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("Added item to cart!"),
                duration: Duration(seconds: 2),
                action: SnackBarAction(
                  label: "UNDO",
                  onPressed: () {
                    cart.removeSingleItem(product.id);
                  },
                ),
              ));
            },
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
