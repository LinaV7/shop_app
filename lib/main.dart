import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/global_veriables.dart';
import 'package:shop_app/pages/home_page.dart';
import 'package:shop_app/pages/product_details_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shop_app/hive_database/cart_item.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(CartItemAdapter());
  await Hive.openBox<CartItem>('cart');

  final cartProvider = CartProvider();
  await cartProvider.loadCartFromHive(); // Загружаем данные из Hive

  runApp(
    ChangeNotifierProvider(
      create: (context) => cartProvider,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => CartProvider())],
      child: MaterialApp(
          title: 'Shopping App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              fontFamily: 'Lato',
              colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color.fromRGBO(254, 206, 1, 1),
                  primary: const Color.fromRGBO(254, 206, 1, 1)),
              inputDecorationTheme: const InputDecorationTheme(
                  hintStyle:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  prefixIconColor: Color.fromRGBO(199, 199, 199, 1)),
              textTheme: const TextTheme(
                  titleLarge:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
                  titleMedium: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  bodySmall:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              useMaterial3: true,
              appBarTheme: const AppBarTheme(
                  titleTextStyle: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ))),
          home: const HomePage()),
    );
  }
}
