import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MaterialApp(home: CandyShop()));
}

class CandyItem {
  final String name;
  final double price;
  final String description;
  final String image;
  final Color cardColor;
  int quantity;
  final String dbKey;

  CandyItem({
    required this.name,
    required this.price,
    required this.description,
    required this.image,
    required this.cardColor,
    required this.dbKey,
    this.quantity = 0,
  });
}

class CandyShop extends StatefulWidget {
  const CandyShop({super.key});

  @override
  State<CandyShop> createState() => _CandyShopState();
}

class _CandyShopState extends State<CandyShop> {
  late DatabaseReference _dbRef;

  final List<CandyItem> candies = [
    CandyItem(
      name: 'Orange Burst',
      price: 10.00,
      description: 'Tangy and refreshing orange flavor with a zesty kick',
      image: 'assets/orange.jpeg',
      cardColor: const Color(0xFFFFF0F5),
      dbKey: 'orange',
    ),
    CandyItem(
      name: 'Strawberry Delight',
      price: 8.00,
      description: 'Sweet and juicy strawberry flavor, perfect for a fruity treat',
      image: 'assets/strawberry.webp',
      cardColor: const Color(0xFFFFF0F5),
      dbKey: 'strawberry',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _dbRef = FirebaseDatabase.instance.ref();
    _initializeQuantities();
  }

  Future<void> _initializeQuantities() async {
    for (var candy in candies) {
      final snapshot = await _dbRef.child(candy.dbKey).get();
      if (snapshot.exists) {
        setState(() {
          candy.quantity = (snapshot.value as int?) ?? 0;
        });
      }
    }
  }

  Future<void> _updateQuantity(CandyItem candy) async {
    await _dbRef.child(candy.dbKey).set(candy.quantity);
  }

  double get totalPrice => candies.fold(0, (sum, item) => sum + (item.price * item.quantity));

  void _decrementQuantity(CandyItem candy) {
    if (candy.quantity > 0) {
      setState(() {
        candy.quantity--;
      });
      _updateQuantity(candy);
    }
  }

  void _incrementQuantity(CandyItem candy) {
    setState(() {
      candy.quantity++;
    });
    _updateQuantity(candy);
  }

  Future<void> _resetQuantities() async {
    for (var candy in candies) {
      candy.quantity = 0;
      await _updateQuantity(candy);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1D5DD),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
          child: AppBar(
            elevation: 0,
            backgroundColor: const Color(0xFFF6A5BC),
            flexibleSpace: const Padding(
              padding: EdgeInsets.only(top: 40.0),
              child: Center(
                child: Text(
                  'Sweet Treats',
                  style: TextStyle(
                    color: Color(0xFF424242),
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            actions: const [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.shopping_cart_outlined,
                  size: 20,
                  color: Color(0xFF424242),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.account_circle_outlined,
                  size: 20,
                  color: Color(0xFF424242),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Featured Candies',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF424242),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Swipe to explore →',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 420,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: candies.length,
              itemBuilder: (context, index) {
                final candy = candies[index];
                return Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  margin: const EdgeInsets.only(right: 20),
                  child: Card(
                    elevation: 4,
                    shadowColor: Colors.black12,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(24),
                          ),
                          child: Image.asset(
                            candy.image,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      candy.name,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF424242),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '\$${candy.price.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.pink,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                candy.description,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFCE4EC),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove),
                                      color: Colors.pink,
                                      onPressed: () => _decrementQuantity(candy),
                                    ),
                                    Text(
                                      '${candy.quantity}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      color: Colors.pink,
                                      onPressed: () => _incrementQuantity(candy),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(child: Container()),
        ],
      ),
      bottomNavigationBar: totalPrice > 0
          ? Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          boxShadow: [
            BoxShadow(
              color: Colors.pink.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 20,
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Total Amount',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    '\$${totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.pink[50],
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                      ),
                      builder: (context) => Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Confirm Order',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Total: \$${totalPrice.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.pink,
                                    ),
                                    child: const Text('Cancel'),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await _resetQuantities();
                                      Navigator.pop(context);

                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Order Successful'),
                                            content: const Text('Your order has been placed successfully!'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.pink,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                    ),
                                    child: const Text(
                                      'Confirm',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Checkout',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      )
          : null,
    );
  }
}
