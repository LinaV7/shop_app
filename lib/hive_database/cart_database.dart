import 'package:hive/hive.dart';
import 'package:shop_app/hive_database/cart_item.dart';

class CartDatabase {
  static final CartDatabase instance = CartDatabase._init();
  static Box<CartItem>? _box;

  CartDatabase._init();

  Future<void> init() async {
    _box = await Hive.openBox<CartItem>('cart');
  }

  Future<void> addProduct(CartItem product) async {
    await _box?.add(product);
  }

  Future<void> removeProduct(int index) async {
    await _box?.deleteAt(index);
  }

  List<CartItem> getProducts() {
    return _box?.values.toList() ?? [];
  }

  Future<void> clearCart() async {
    await _box?.clear();
  }
}
