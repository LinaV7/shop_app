import 'package:flutter/material.dart';
import 'package:shop_app/hive_database/cart_database.dart';

class CartProvider with ChangeNotifier {
  List<Map<String, dynamic>> _cart = [];

  List<Map<String, dynamic>> get cart => _cart;

  Future<void> loadCartFromHive() async {
    final cartItems = await CartDatabase.instance.getProducts();
    _cart = cartItems.map((item) => item.toMap()).toList();
    notifyListeners();
  }

  void addProduct(Map<String, dynamic> product) {
    _cart.add(product);
    notifyListeners();
  }

  void removeProduct(Map<String, dynamic> product) {
    _cart.remove(product);
    notifyListeners();
  }
}

// import 'package:flutter/material.dart';

// class CartProvider extends ChangeNotifier {
//   final List<Map<String, dynamic>> cart = [];

//   void addProduct(Map<String, dynamic> product) {
//     cart.add(product);
//     notifyListeners();
//   }

//   void removeProduct(Map<String, dynamic> product) {
//     cart.remove(product);
//     notifyListeners();
//   }
// }