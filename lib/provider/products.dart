import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/provider/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
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
    ),
  ];
  List<Product> get favItems {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  List<Product> get items {
    return [..._items];
  }

  Product findById(productId) {
    return _items.firstWhere((product) => product.id == productId);
  }

  Future<void> addProduct(Product newProduct) {
    const url =
        'https://flutter-shop-app-fa9cc-default-rtdb.firebaseio.com/products.json';
    return http
        .post(
      Uri.parse(url),
      body: json.encode(
        {
          'title': newProduct.title,
          'description': newProduct.description,
          'price': newProduct.price,
          'isFavorite': newProduct.isFavorite,
          'imageUrl': newProduct.imageUrl
        },
      ),
    )
        .then((response) {
      print(json.decode(response.body));
      _items.add(Product(
          title: newProduct.title,
          description: newProduct.description,
          id: jsonDecode(response.body)['name'],
          imageUrl: newProduct.imageUrl,
          price: newProduct.price));
      notifyListeners();
    });
  }

  void updateProduct(String productId, Product updatedProduct) {
    final productIndex = _items.indexWhere((prod) => prod.id == productId);
    if (productIndex >= 0) {
      _items[productIndex] = updatedProduct;
      notifyListeners();
    }
  }

  void deleteProduct(String productId) {
    _items.removeWhere((prod) => prod.id == productId);
    notifyListeners();
  }
}
