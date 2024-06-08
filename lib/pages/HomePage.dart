import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:aral_shop/models/Product.dart';
import 'package:aral_shop/products.dart';

class HomePage extends StatefulWidget {
  final Product product;

  HomePage({super.key, required this.product});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> _foundProducts = [];
  String _dropdownValue = "All";

  var categories = ["All", "Laptop", "Mouse", "Keyboard", "Monitor", "Headset", "Graphics Card"];
  bool isSort = true;

  @override
  void initState() {
    _foundProducts = products;
    super.initState();
  }

  void _filterProducts(String enteredText) {
    List<Product> results = [];
    if (enteredText.isEmpty) {
      results = products;
    } else {
      results = products.where((product) {
        return product.name.toLowerCase().contains(enteredText.toLowerCase());
      }).toList();
    }
    setState(() {
      _foundProducts = results;
    });
  }

  void _filterByCategory(String category) {
    List<Product> results = [];
    if (category == "All") {
      results = products;
    } else {
      results = products.where((product) {
        return product.description
            .toLowerCase()
            .contains(category.toLowerCase());
      }).toList();
    }
    setState(() {
      _foundProducts = results;
      _dropdownValue = category;
    });
  }

  void _sortByPrice(bool ascending) {
    setState(() {
      isSort = ascending;
      _foundProducts.sort((a, b) => isSort ? a.price.compareTo(b.price) : b.price.compareTo(a.price));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        title: Text('AralShop Products'),
        actions: [
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              icon: Icon(
                Icons.filter_alt,
                color: Colors.white,
              ),
              items: categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? value) {
                if (value != null) {
                  _filterByCategory(value);
                }
              },
              value: _dropdownValue,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) => _filterProducts(value),
                    decoration: InputDecoration(
                      hintText: 'Search for products...',
                      suffixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Row(
                  children: [
                    Text(
                      'Sort by',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: () {
                        _sortByPrice(!isSort);
                      },
                      icon: isSort ? Icon(Icons.arrow_downward) : Icon(Icons.arrow_upward),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20), // Add some space between the search row and the grid
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(10.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 0.8,
                ),
                itemCount: _foundProducts.length,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: NetworkImage(_foundProducts[index].imageUrl),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            colors: [Colors.black54, Colors.transparent],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            stops: [0.2, 0.8],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 10,
                        right: 10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _foundProducts[index].name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              _foundProducts[index].description,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              '\$${_foundProducts[index].price}',
                              style: TextStyle(
                                color: Colors.greenAccent,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/login');
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }
}
