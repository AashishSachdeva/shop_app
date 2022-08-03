import 'package:flutter/cupertino.dart';

class Product with ChangeNotifier {
  final String id;
  final String description;
  final double price;
  bool isFavorite;
  final String imageUrl;
  final String title;
  Product({
    required this.title,
    required this.description,
    required this.id,
    required this.imageUrl,
    this.isFavorite = false,
    required this.price,
  });

  void toogleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
