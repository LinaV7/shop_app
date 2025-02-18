import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/hive_database/cart_database.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/hive_database/cart_item.dart';

class ProductDetailsPage extends StatefulWidget {
  final Map<String, dynamic> product;
  final int selectedSize;
  const ProductDetailsPage(
      {super.key, required this.product, this.selectedSize = 0});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late int selectedSize;

  @override
  void initState() {
    super.initState();
    selectedSize = widget.selectedSize;
  }

  void onTap() async {
    if (selectedSize != 0) {
      // Создаем объект CartItem
      final newItem = CartItem(
        productId: widget.product['id']!,
        title: widget.product['title']!,
        price: widget.product['price']!,
        imageUrl: widget.product['imageUrl']!,
        company: widget.product['company']!,
        size: selectedSize,
        sizes: widget.product['sizes'] ?? [],
      );

      Provider.of<CartProvider>(context, listen: false).addProduct({
        'id': widget.product['id']!,
        'title': widget.product['title']!,
        'price': widget.product['price']!,
        'imageUrl': widget.product['imageUrl']!,
        'company': widget.product['company']!,
        'size': selectedSize,
        'sizes': widget.product['sizes'] ?? [],
      });

      // Добавляем товар в Hive
      await CartDatabase.instance.addProduct(newItem);

      // Показываем уведомление
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product added successfully!'),
        ),
      );
    } else {
      // Если размер не выбран, показываем ошибку
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a size!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final sizes = (widget.product['sizes'] as List<dynamic>?)
            ?.map<int>((size) => size as int)
            .toList() ??
        [];

    return Scaffold(
        appBar: AppBar(
          title: const Text('Details'),
        ),
        body: Column(
          children: [
            Text(widget.product['title'] as String,
                style: Theme.of(context).textTheme.titleLarge),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                widget.product['imageUrl'] as String,
                height: 250,
              ),
            ),
            const Spacer(flex: 2),
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(245, 247, 249, 1),
                  borderRadius: BorderRadius.circular(40)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '\$${widget.product['price']}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: sizes.length,
                          itemBuilder: (context, index) {
                            final size = sizes[index];
                            return GestureDetector(
                              onTap: () {
                                setState(
                                  () {
                                    selectedSize = size;
                                  },
                                );
                              },
                              child: Chip(
                                label: Text(size.toString()),
                                backgroundColor: selectedSize == size
                                    ? Theme.of(context).colorScheme.primary
                                    : null,
                              ),
                            );
                          }),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ElevatedButton.icon(
                      onPressed: onTap,
                      icon: const Icon(
                        Icons.shopping_cart,
                        color: Colors.black,
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          minimumSize: const Size(double.infinity, 50)),
                      label: const Text('Add to cart',
                          style: TextStyle(color: Colors.black, fontSize: 18)),
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }
}
