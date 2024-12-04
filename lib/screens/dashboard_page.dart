import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:FoodApp/models/food_item.dart';
import 'food_price.dart';
import 'profile_page.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  List<FoodItem> foodItems = [];
  TextEditingController foodController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _searchFood() async {
    final foodName = foodController.text.trim();
    if (foodName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a food name.")),
      );
      return;
    }

    try {
      final foodData = await fetchFoodItems(foodName);
      setState(() {
        foodItems = foodData;
      });

      _showRandomNotification();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $error")),
      );
    }
  }

  Future<List<FoodItem>> fetchFoodItems(String foodName) async {
    final String appId = 'f36bd771'; 
    final String appKey = '01b3c723ed5806969ea642497c864015'; 

    final response = await http.post(
      Uri.parse('https://trackapi.nutritionix.com/v2/natural/nutrients'),
      headers: {
        'x-app-id': appId,
        'x-app-key': appKey,
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "query": foodName,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<FoodItem> items = [];
      for (var item in data['foods']) {
        items.add(FoodItem.fromJson(item));
      }
      return items;
    } else {
      throw Exception('Failed to load food items');
    }
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      // Navigasi ke Dashboard dan hapus riwayat sebelumnya
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen()),
        (Route<dynamic> route) => false, // Hapus semua rute sebelumnya
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FoodPricePage()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
      );
    }
  }

  void _showRandomNotification() {
    const notifications = [
      "Stay hydrated! Don't forget to drink water.",
      "You’re doing amazing! Keep tracking your food to meet your nutrition goals.",
      "Great job! You've reached another step in your food journey!",
      "Remember, small steps lead to big changes. Keep going!",
      "Did you know? Balanced meals fuel your body and mind!",
    ];

    final randomNotification = notifications[Random().nextInt(notifications.length)];

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(randomNotification),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green.shade700,
      ),
    );
  }

  Widget _buildFoodInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Search Food",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade700,
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: foodController,
            decoration: InputDecoration(
              hintText: 'Enter food name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.green.shade700),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              filled: true,
              fillColor: Colors.grey[200],
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: _searchFood,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade700,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            child: const Text("Search", style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodItemCard(FoodItem foodItem) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: ListTile(
        contentPadding: const EdgeInsets.all(10.0),
        leading: foodItem.imageUrl != null
            ? Image.network(foodItem.imageUrl, width: 50, height: 50, fit: BoxFit.cover)
            : Icon(Icons.fastfood, size: 50, color: Colors.green.shade700),
        title: Text(foodItem.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Calories: ${foodItem.calories} kcal'),
            Text('Protein: ${foodItem.protein} g'),
            Text('Fat: ${foodItem.fat} g'),
            Text('Carbs: ${foodItem.carbohydrates} g'),
            Text('Fiber: ${foodItem.fiber} g'),
            Text('Sugar: ${foodItem.sugar} g'),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboard() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.green.shade700,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome to Food Nutrition!",
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 10),
                Text(
                  "In this app, you can explore the nutritional content of various foods. "
                  "Simply enter a food name like 'egg', 'apple', or even phrases like 'two eggs' or 'two apples'.",
                  style: const TextStyle(fontSize: 16, color: Colors.white70),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          _buildFoodInput(),
          ...foodItems.map((item) => _buildFoodItemCard(item)).toList(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Food Nutrition App"),
        backgroundColor: Colors.green.shade700,
        elevation: 0,
      ),
      body: _buildDashboard(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: "Food Price",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
