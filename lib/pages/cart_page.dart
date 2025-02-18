import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shop_app/pages/product_details_page.dart';
import 'package:shop_app/hive_database/cart_item.dart';
import 'package:shop_app/hive_database/cart_database.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartDatabase _cartDatabase = CartDatabase.instance;

  @override
  void initState() {
    super.initState();
    _cartDatabase.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<CartItem>('cart').listenable(),
        builder: (context, Box<CartItem> box, _) {
          final cartItems = box.values.toList();
          return ListView.builder(
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final cartItem = cartItems[index];
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return ProductDetailsPage(
                          product: {
                            'id': cartItem.productId,
                            'title': cartItem.title,
                            'price': cartItem.price,
                            'size': cartItem.size,
                            'imageUrl': cartItem.imageUrl,
                            'company': cartItem.company,
                            'sizes': cartItem.sizes,
                          },
                          selectedSize: cartItem.size,
                        );
                      },
                    ),
                  );
                },
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(cartItem.imageUrl),
                    radius: 30,
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              'Delete product?',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            content: const Text(
                                'Are you sure you want to remove the product from your cart?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  'No',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  _cartDatabase.removeProduct(index);
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  'Yes',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                  title: Text(
                    cartItem.title,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  subtitle: Text('Size: ${cartItem.size}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
