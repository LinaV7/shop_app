import 'package:hive/hive.dart';

part 'cart_item.g.dart';
//flutter pub run build_runner build

@HiveType(typeId: 1)
class CartItem {
  @HiveField(0)
  final int productId;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final double price;

  @HiveField(3)
  final String imageUrl;

  @HiveField(4)
  final String company;

  @HiveField(5)
  final int size;

  @HiveField(6)
  final List<dynamic> sizes;

  CartItem({
    required this.productId,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.company,
    required this.size,
    required this.sizes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': productId,
      'title': title,
      'price': price,
      'imageUrl': imageUrl,
      'company': company,
      'size': size,
      'sizes': sizes,
    };
  }
}
