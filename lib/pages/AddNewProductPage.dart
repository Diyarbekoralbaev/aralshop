import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:aral_shop/models/Product.dart';
import 'package:aral_shop/products.dart';

class AddNewProductPage extends StatefulWidget {
  AddNewProductPage({Key? key}) : super(key: key);

  @override
  State<AddNewProductPage> createState() => _AddNewProductPageState();
}

class _AddNewProductPageState extends State<AddNewProductPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();

  bool isFilled = false;

  String _dropdownValue = "Laptop";

  var categories = ["Laptop", "Mouse", "Keyboard", "Monitor", "Headset", "Graphics Card", "Processor", "RAM"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            context.go("/");
          },
        ),
        title: Text('Add New Product'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Enter Product Details',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              _buildTextField(nameController, 'Enter product name'),
              SizedBox(height: 20),
              _buildTextField(priceController, 'Enter product price', keyboardType: TextInputType.number),
              SizedBox(height: 20),
              _buildTextField(imageUrlController, 'Enter product image URL'),
              SizedBox(height: 20),
              DropdownButtonFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                value: _dropdownValue,
                items: categories.map((String category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _dropdownValue = value!;
                  });
                },
              ),
              SizedBox(height: 20),
              Visibility(
                child: Text(
                  "Please fill all fields",
                  style: TextStyle(color: Colors.red),
                ),
                visible: isFilled,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  if (nameController.text.isNotEmpty &&
                      priceController.text.isNotEmpty &&
                      imageUrlController.text.isNotEmpty &&
                      _dropdownValue.isNotEmpty) {
                    Product product = Product(
                      name: nameController.text,
                      price: double.parse(priceController.text),
                      imageUrl: imageUrlController.text,
                      description: _dropdownValue,
                    );
                    products.insert(0, product);
                    context.go('/');
                  } else {
                    setState(() {
                      isFilled = true;
                    });
                  }
                },
                child: Text(
                  'Add product to sale',
                  style: TextStyle(color: Colors.deepPurple),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText, {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
