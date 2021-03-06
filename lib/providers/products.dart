import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

import './product.dart';

class Products with ChangeNotifier {
  //Usamos un mixin
  //Usamos changeNotifier

  /* var _showFavoritesOnly = false; */

  List<Product> _items = [
    /* Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ), */
  ];

  final String authToken;
  final String userId;


  Products(this.authToken, this._items, this.userId);

  List<Product> get items {
    /* if (_showFavoritesOnly) {
      return _items.where((prodItem) => prodItem.isFavorite).toList();
    } */

    return [..._items];
    /*  Enviamos una copia de _items por que requerimos mantener el apuntador de memoria
    de manera interna, de esta forma podremos llamar notifyListeners(); de manera segura,
    es decir, todos los movimientos se encapsulan en esta clase.

    Solo cambiamos data dentro de la clase por que solo podremos editarla desde adentro
    con notifyListeners() y todas las claimport '../providers/products.dart';
se que estan escuchando a esta clase seran 
    rebuilded.
    */
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : ''; 
    var url = 'https://myshop-academind.firebaseio.com/products.json?auth=$authToken&$filterString';

    try {
      final response = await http.get(url);

      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      url =
          "https://myshop-academind.firebaseio.com/userFavorites/$userId.json?auth=$authToken";
      
      final favoriteResponse = await http.get(url); 
      final favoriteData = json.decode(favoriteResponse.body);

      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData["title"],
          description: prodData["description"],
          price: prodData["price"],
          isFavorite: favoriteData == null ? false : favoriteData[prodId] ?? false,
          imageUrl: prodData["imageUrl"],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = "https://myshop-academind.firebaseio.com/products.json?auth=$authToken"; //.json
    try {
      final response = await http.post(url,
          body: json.encode({
            "title": product.title,
            "description": product.description,
            "imageUrl": product.imageUrl,
            "price": product.price,
            "creatorId": userId,
            //"isFavorite": product.isFavorite,
            //Ya no lo requerimos por que obtenemos esta informacion 
            //desde otro entry point
          }));

      final newProduct = Product(
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl,
          id: json.decode(response.body)["name"]);
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  //El objetivo es hacer toda la logica dentro del provider
  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  List<Product> get favoriteItems {
    return _items.where((productItem) => productItem.isFavorite).toList();
  }

  /* void showFavoritesOnly() {
    _showFavoritesOnly = true;
    notifyListeners();
  }

  void showAll() {
    _showFavoritesOnly = false;
    notifyListeners();
  } */

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
/*     print(prodIndex); */
    if (prodIndex >= 0) {
      final url = "https://myshop-academind.firebaseio.com/products/$id.json?auth=$authToken";
      try {
        await http.patch(url,
            body: json.encode({
              "title": newProduct.title,
              "description": newProduct.description,
              "imageUrl": newProduct.imageUrl,
              "price": newProduct.price
            }));
      } catch (error) {
        print(error);
        throw error;
      }

      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print("No se pudo sustituir el producto");
    }
  }

  Future<void> deleteProduct(String id) async {
    //This is called optimistic delete pattern
    final url = "https://myshop-academind.firebaseio.com/products/$id.json?auth=$authToken";
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];

    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException("Could not delete product.");
    }
    existingProduct = null;
  }
}
