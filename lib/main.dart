import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import './screens/product_detail_screen.dart';
import './screens/products_overview_screens.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './screens/cart_screen.dart';
import './providers/orders.dart';
import './providers/auth.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth-screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //ChangeNotifierProvider.value se usa cuando no pasamos el contexto y no es necesario
        //Ademas con ChangeNotifierProvider.value es recomendado para listas y grids donde
        //el orden de la info cambia de orden constantemente y no se pierda con el state

        //Ponemos en la raiz de nuestro widget tree ChangeNotifierProvider
        //nos permitira registrar una clase que podra escuchar en widgets hijos
        //de esta forma reconstruira estas clases si la data cambia.
        ChangeNotifierProvider.value(
          value: Auth(),
          /* builder: (ctx) {
          //Entrega esta clase a los widgets hijos
          return Products();
        }, */
        ),

        ChangeNotifierProxyProvider<Auth, Products>(
          /* Usamos ChangeNotifierProxyProvide<Dependency, newValueToProvide> 
          cuando un provider depende de 
          otro provider definido anteriormente, cuando el provider dependiente 
          llame changeNotifier() se llamara a ChangeNotifierProxy consecuentemente*/
          create: (_) => Products(null, [], ""),
          update: (_, auth, previousProducts) => Products(auth.token,
              previousProducts == null ? [] : previousProducts.items, auth.userId),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => Orders(null, "", []),
          update: (_, auth, previusOrders) => Orders(
              auth.token, auth.userId ,previusOrders == null ? [] : previusOrders.orders),
          //value: Orders(),
        ),
      ],
      child: Consumer<Auth>(
        //MaterialApp rebuilds whenever Auth changes (Calling notifyListeners())
        builder: (ctx, auth, _) => MaterialApp(
          theme: ThemeData(
              primarySwatch: Colors.amber,
              accentColor: Colors.deepOrange,
              fontFamily: "Lato"),
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          home: auth.isAuth ? ProductOverviewScreen() : AuthScreen(),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routenName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
