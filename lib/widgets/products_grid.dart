import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import './product_item.dart';

class ProductGrid extends StatelessWidget {

  final bool showFavs;

  ProductGrid(this.showFavs);

  @override
  Widget build(BuildContext context) {
    //Se almacena la instancia de la clase
    final productsData = Provider.of<Products>(context);
    /* .of(context) es un metodo generico, por lo tanto me permite indicar con 
    un tipo generico el tipo de valor que puedo escuchar.

    Le decimos al provider que queremos establecer una linea de comunicacion
    con la clase <Products> exclusivamente.
    */

    final products = showFavs ? productsData.favoriteItems: productsData.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (ctx, index) {
        return ChangeNotifierProvider.value(
          /* builder: (c) => products[index], */
          value: products[index],
          child: ProductItem(
              //Ya no pasamos info por constructor ya que usamos provider
              /* id: products[index].id,
                  title: products[index].title,
                  imageUrl: products[index].imageUrl, */
              ),
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
