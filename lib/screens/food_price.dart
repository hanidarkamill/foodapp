import 'package:flutter/material.dart';
import 'dashboard_page.dart';
import 'profile_page.dart';

class FoodPricePage extends StatefulWidget {
  @override
  _FoodPricePageState createState() => _FoodPricePageState();
}

class _FoodPricePageState extends State<FoodPricePage> {
  int _selectedIndex = 1; // Set default to Food Price page
  String _selectedCurrency = 'IDR'; // Currency selected by the user
  final List<Map<String, dynamic>> foodItems = [
    {'name': 'Healthy Food', 'price': 20000.0},
    {'name': 'Fresh Food', 'price': 18000.0},
    {'name': 'Seafood', 'price': 25000.0},
    {'name': 'Vegetables', 'price': 12000.0},
    {'name': 'Foods', 'price': 22000.0},
    {'name': 'Meat and Egg', 'price': 30000.0},
    {'name': 'Cake', 'price': 15000.0},
  ];

  double convertCurrencyFromIDR(double priceInIDR, String currency) {
    switch (currency) {
      case 'USD':
        return priceInIDR / 15000;
      case 'KRW':
        return (priceInIDR / 15000) * 1300;
      case 'JPY':
        return (priceInIDR / 15000) * 110;
      case 'MYR':
        return (priceInIDR / 15000) * 4.2;
      case 'SGD':
        return (priceInIDR / 15000) * 1.35;
      case 'EUR':
        return (priceInIDR / 15000) * 0.9;
      case 'SAR':
        return (priceInIDR / 15000) * 3.75;
      case 'AUD':
        return (priceInIDR / 15000) * 1.5;
      default:
        return priceInIDR;
    }
  }

  void _editPrice(int index) {
    final priceController = TextEditingController(
        text: foodItems[index]['price'].toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Price for ${foodItems[index]['name']}'),
          content: TextField(
            controller: priceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Price in IDR'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  foodItems[index]['price'] =
                      double.tryParse(priceController.text) ?? foodItems[index]['price'];
                });
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      // Navigate to Food Price page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => FoodPricePage()),
      );
    } else if (index == 0) {
      // Navigate to Dashboard page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen()), 
      );
    } else if (index == 2) {
      // Navigate to Profile page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
      );
    }
  }

  Widget _buildFoodShoppingPage() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButton<String>(
            value: _selectedCurrency,
            onChanged: (String? newValue) {
              setState(() {
                _selectedCurrency = newValue!;
              });
            },
            items: <String>['IDR', 'USD', 'KRW', 'JPY', 'MYR', 'SGD', 'EUR', 'SAR', 'AUD']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: foodItems.length,
            itemBuilder: (context, index) {
              final foodItem = foodItems[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 5,
                child: ListTile(
                  title: Text(
                    foodItem['name'],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green.shade700),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_selectedCurrency == 'IDR') 
                        Text('Price in IDR: Rp ${foodItem['price'].toStringAsFixed(0)}'),
                      if (_selectedCurrency != 'IDR') 
                        Text('Price in $_selectedCurrency: ${convertCurrencyFromIDR(foodItem['price'], _selectedCurrency).toStringAsFixed(2)} $_selectedCurrency'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.edit, color: Colors.green.shade700),
                    onPressed: () => _editPrice(index),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Price'),
        backgroundColor: Colors.green.shade700,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Handle notification action
            },
          ),
        ],
      ),
      body: _buildFoodShoppingPage(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Food Price',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green.shade700,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
