import 'package:edgepos/app_color.dart';
import 'package:edgepos/widget/cart_widget.dart';
import 'package:flutter/material.dart';
import 'package:edgepos/models/product_model.dart';
import 'package:edgepos/services/product_api.dart';
import 'package:edgepos/services/category_api.dart';
import 'package:edgepos/models/category_model.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({Key? key}) : super(key: key);

  @override
  SalesPageState createState() => SalesPageState();
}

class SalesPageState extends State<SalesPage> {
  late Future<List<Product>> _products;
  late Future<List<Category>> _categories;
  List<Product> _filteredProducts = [];
  int _selectedCategoryId = 0;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _products = ProductApi().getProducts();
      _categories = CategoryApi().getCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
      floatingActionButton: MediaQuery.of(context).size.width > 600
          ? null
          : FloatingActionButton(
              onPressed: () {
                _showCartDialog(context);
              },
              child: const Icon(Icons.shopping_cart),
            ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Row(
      children: [
        // Left side (Categories and Products)
        Expanded(
          flex: 2,
          child: Container(
            color: AppColor.grayColor,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                            });
                          },
                          decoration: const InputDecoration(
                            hintText: 'Search',
                            prefixIcon: Icon(Icons.search),
                          ),
                        ),
                      ),
                      PopupMenuButton<int>(
                        onSelected: (int value) {
                          setState(() {
                            _selectedCategoryId = value;
                          });
                          _loadData();
                        },
                        itemBuilder: (BuildContext context) {
                          return [
                            const PopupMenuItem<int>(
                              value: 0,
                              child: Text('All Categories'),
                            ),
                            ..._buildCategoryMenuItems(),
                          ];
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FutureBuilder<List<Category>>(
                    future: _categories,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Text('No categories available.');
                      } else {
                        List<Category> categories = snapshot.data!;
                        return SizedBox(
                          height: 50,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: categories.length + 1,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedCategoryId =
                                        index == 0 ? 0 : categories[index - 1].id;
                                    _loadData();
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                    vertical: 8.0,
                                  ),
                                  margin: const EdgeInsets.only(right: 8.0),
                                  decoration: BoxDecoration(
                                    color: _selectedCategoryId ==
                                            (index == 0
                                                ? 0
                                                : categories[index - 1].id)
                                        ? Colors.blue
                                        : Colors.grey,
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  child: Text(
                                    index == 0
                                        ? 'All Categories'
                                        : categories[index - 1].name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RefreshIndicator(
                      onRefresh: _loadData,
                      child: FutureBuilder<List<Product>>(
                        future: _products,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Center(
                              child: Text('No products available.'),
                            );
                          } else {
                            _filteredProducts = snapshot.data!;
                            return _buildResponsiveGrid(
                                _filteredProducts, context);
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Right side (Floating Action Button)
        MediaQuery.of(context).size.width < 600
            ? Container()
            : const Expanded(
                flex: 1,
                child: CartWidget(),
              ),
      ],
    );
  }

  List<PopupMenuItem<int>> _buildCategoryMenuItems() {
    final List<Category> categories = []; // Replace with your actual category data
    return categories
        .map((category) => PopupMenuItem<int>(
              value: category.id,
              child: Text(category.name),
            ))
        .toList();
  }

  Widget _buildResponsiveGrid(List<Product> products, BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    int crossAxisCount = 2;
    if (screenWidth > 600) {
      crossAxisCount = 3;
    }
    if (screenWidth > 1024) {
      crossAxisCount = 4;
    }

 List<Product> filteredProducts = _selectedCategoryId == 0
    ? _filteredProducts
        .where((product) =>
            product.title.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList()
    : _filteredProducts
        .where((product) =>
            product.categoryId == _selectedCategoryId &&
            product.title.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        // childAspectRatio: 1.5,
      ),
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        return buildProductCard(filteredProducts[index]);
      },
    );
  }

  Widget buildProductCard(Product product) {
    bool isOutOfStock = product.availability.toLowerCase() == 'out of stock';

    return Card(
      elevation: 4.0,
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            child: ClipRRect(
              child: Image.network(
                product.imageURL,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/noimage.png',
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
          ),
          if (isOutOfStock)
            Center(
              child: Container(
                color: Colors.red.withOpacity(0.8),
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  'Out of Stock',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              color: Colors.black.withOpacity(0.5),
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ' BND ${product.variants.first.sellingPrice}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.black.withOpacity(0.5),
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    product.availability,
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    'Available Stock: ${product.availableStock}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const Dialog(
          child: CartWidget(),
        );
      },
    );
  }
}
