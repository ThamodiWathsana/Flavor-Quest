import 'package:flutter/material.dart';

class CandyAdmin extends StatefulWidget {
  const CandyAdmin({super.key, required String title});

  @override
  State<CandyAdmin> createState() => _CandyAdminState();
}

class _CandyAdminState extends State<CandyAdmin> {
  int _selectedIndex = 0;
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

  // List to store candy items
  List<Map<String, dynamic>> candies = [
    {
      'name': 'Orange Burst',
      'price': 10.00,
      'description': 'Tangy and refreshing orange flavor with a zesty kick',
      'image': 'assets/orange.jpeg',
    },
    {
      'name': 'Strawberry Delight',
      'price': 8.00,
      'description': 'Sweet and juicy strawberry flavor, perfect for a fruity treat',
      'image': 'assets/strawberry.webp',
    },
  ];

  // Add new product
  void _addProduct() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        candies.add({
          'name': _nameController.text,
          'price': double.parse(_priceController.text),
          'description': _descriptionController.text,
          'image': 'assets/placeholder.jpg',
        });
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${_nameController.text} added successfully'),
          backgroundColor: Colors.green,
        ),
      );

      // Clear form
      _nameController.clear();
      _priceController.clear();
      _descriptionController.clear();
    }
  }

  // Delete product
  void _deleteProduct(int index) {
    final deletedName = candies[index]['name'];
    setState(() {
      candies.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$deletedName deleted successfully'),
        backgroundColor: Colors.red,
      ),
    );
  }

  // Edit product
  void _showEditDialog(int index) {
    _nameController.text = candies[index]['name'];
    _priceController.text = candies[index]['price'].toString();
    _descriptionController.text = candies[index]['description'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Product'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                candies[index] = {
                  'name': _nameController.text,
                  'price': double.parse(_priceController.text),
                  'description': _descriptionController.text,
                  'image': candies[index]['image'],
                };
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${candies[index]['name']} updated successfully'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1D5DD),
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: const Color(0xFFF6A5BC),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildProductManagement(),
          _buildOrderHistory(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Orders',
          ),
        ],
      ),
    );
  }

  Widget _buildProductManagement() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Product Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                      value!.isEmpty ? 'Please enter a name' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(
                        labelText: 'Price',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                      value!.isEmpty ? 'Please enter a price' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      validator: (value) =>
                      value!.isEmpty ? 'Please enter a description' : null,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _addProduct,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Add Product'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Card(
              child: ListView.builder(
                itemCount: candies.length,
                itemBuilder: (context, index) {
                  final candy = candies[index];
                  return ListTile(
                    leading: Image.asset(
                      candy['image'],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(candy['name']),
                    subtitle: Text('\$${candy['price'].toStringAsFixed(2)}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showEditDialog(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteProduct(index),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderHistory() {
    return const Center(
      child: Text('Order History Coming Soon'),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}