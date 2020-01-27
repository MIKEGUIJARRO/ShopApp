import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus() async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    //Avisamos a nuestros listeners que el valor cambio
    notifyListeners();
    try {
      final url = "https://myshop-academind.firebaseio.com/products/$id.json";
      final response =
          await http.patch(url, body: json.encode({"isFavorite": isFavorite}));
      if (response.statusCode >= 400) {
        print("Response StatusCode: ${response.statusCode}");
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
      throw HttpException("message");
    }
  }
}
