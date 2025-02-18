import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shop_app/global_veriables.dart';
import 'package:shop_app/widgets/product_card.dart';
import 'package:shop_app/pages/product_details_page.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final List<String> filters = const ['All', 'Addidas', 'Nike', 'Bata'];
  late String SelectedFilter;
  String searchQuery = '';
  final TextEditingController searchController = TextEditingController();

  List<Map<String, Object>> getFilteredProducts() {
    return products.where((product) {
      final title = product['title'] as String;
      final company = product['company'] as String;
      final query = searchQuery.toLowerCase();

      final matchesSearch = title.toLowerCase().contains(query);
      final matchesFilter =
          SelectedFilter == 'All' || company == SelectedFilter;

      return matchesSearch && matchesFilter;

      // return title.toLowerCase().contains(query);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    SelectedFilter = filters[0];
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text;
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final size = MediaQuery.of(context).size;
    const border = OutlineInputBorder(
        borderSide: BorderSide(color: Color.fromRGBO(225, 225, 225, 1)),
        borderRadius: BorderRadius.horizontal(left: Radius.circular(50)));
    return SafeArea(
        child: Column(
      children: [
        Row(children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'Shoes\nCollection',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Expanded(
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                border: border,
                enabledBorder: border,
                focusedBorder: border,
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            searchQuery = '';
                            searchController.clear();
                          });
                        },
                      )
                    : null,
              ),
              // onChanged: (value) {
              //   setState(() {
              //     searchQuery = value;
              //   });
              // },
            ),
          )
        ]),
        SizedBox(
          height: 120,
          child: ListView.builder(
            itemCount: filters.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final filter = filters[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      SelectedFilter = filter;
                    });
                  },
                  child: Chip(
                    backgroundColor: SelectedFilter == filter
                        ? Theme.of(context).colorScheme.primary
                        : const Color.fromRGBO(245, 247, 249, 1),
                    side: const BorderSide(
                        color: Color.fromRGBO(245, 247, 249, 1)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    label: Text(filter),
                    labelStyle: const TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                ),
              );
            },
          ),
        ),
        Expanded(
          child: LayoutBuilder(builder: (context, constraints) {
            final filteredProducts = getFilteredProducts();
            if (constraints.maxWidth > 1080) {
              return GridView.builder(
                  itemCount: filteredProducts.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 2),
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return ProductDetailsPage(product: product);
                        }));
                      },
                      child: ProductCard(
                        title: product['title'] as String,
                        price: product['price'] as double,
                        image: product['imageUrl'] as String,
                        company: product['company'] as String,
                        backgroundColor: index.isEven
                            ? const Color.fromRGBO(216, 240, 253, 1)
                            : const Color.fromRGBO(245, 247, 249, 1),
                      ),
                    );
                  });
            } else {
              return ListView.builder(
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return ProductDetailsPage(
                            product: product,
                          );
                        }));
                      },
                      child: ProductCard(
                        title: product['title'] as String,
                        price: product['price'] as double,
                        image: product['imageUrl'] as String,
                        company: product['company'] as String,
                        backgroundColor: index.isEven
                            ? const Color.fromRGBO(216, 240, 253, 1)
                            : const Color.fromRGBO(245, 247, 249, 1),
                      ),
                    );
                  });
            }
          }),
        ),
        // Expanded(
        //   child: size.width > 650
        //       ? GridView.builder(
        //           itemCount: products.length,
        //           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        //               crossAxisCount: 2, childAspectRatio: 2),
        //           itemBuilder: (context, index) {
        //             final product = products[index];
        //             return GestureDetector(
        //               onTap: () {
        //                 Navigator.of(context)
        //                     .push(MaterialPageRoute(builder: (context) {
        //                   return ProductDetailsPage(product: product);
        //                 }));
        //               },
        //               child: ProductCard(
        //                 title: product['title'] as String,
        //                 price: product['price'] as double,
        //                 image: product['imageUrl'] as String,
        //                 backgroundColor: index.isEven
        //                     ? const Color.fromRGBO(216, 240, 253, 1)
        //                     : const Color.fromRGBO(245, 247, 249, 1),
        //               ),
        //             );
        //           })
        //       : ListView.builder(
        //           itemCount: products.length,
        //           itemBuilder: (context, index) {
        //             final product = products[index];
        //             return GestureDetector(
        //               onTap: () {
        //                 Navigator.of(context)
        //                     .push(MaterialPageRoute(builder: (context) {
        //                   return ProductDetailsPage(product: product);
        //                 }));
        //               },
        //               child: ProductCard(
        //                 title: product['title'] as String,
        //                 price: product['price'] as double,
        //                 image: product['imageUrl'] as String,
        //                 backgroundColor: index.isEven
        //                     ? const Color.fromRGBO(216, 240, 253, 1)
        //                     : const Color.fromRGBO(245, 247, 249, 1),
        //               ),
        //             );
        //           }),
        // ),
      ],
    ));
  }
}
