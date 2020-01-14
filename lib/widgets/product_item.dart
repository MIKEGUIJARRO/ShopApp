import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../screens/product_detail_screen.dart';
import '../providers/product.dart';

class ProductItem extends StatelessWidget {
  /* final String id;
  final String title;
  final String imageUrl;

  ProductItem({this.id, this.title, this.imageUrl}); */

  @override
  Widget build(BuildContext context) {

    final product = Provider.of<Product>(context);

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
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          leading: IconButton(
            icon: Icon(product.isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              product.toggleFavoriteStatus();
            },
            color: Theme.of(context).accentColor,
          ),
          backgroundColor: Colors.black87,
          title: Text(product.title, textAlign: TextAlign.center),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              //...
            },
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
