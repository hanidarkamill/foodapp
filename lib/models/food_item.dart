import 'dart:convert';
import 'package:http/http.dart' as http;

class FoodItem {
  final String name;
  final double calories;
  final double protein;
  final double fat;
  final double carbohydrates;
  final double fiber;
  final double sugar;
  final String imageUrl; // Menambahkan properti imageUrl

  FoodItem({
    required this.name,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbohydrates,
    required this.fiber,
    required this.sugar,
    required this.imageUrl, // Menambahkan parameter imageUrl
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      name: json['food_name'],
      calories: json['nf_calories'] ?? 0.0,
      protein: json['nf_protein'] ?? 0.0,
      fat: json['nf_total_fat'] ?? 0.0,
      carbohydrates: json['nf_total_carbohydrate'] ?? 0.0,
      fiber: json['nf_dietary_fiber'] ?? 0.0,
      sugar: json['nf_sugars'] ?? 0.0,
      imageUrl: json['photo']['thumb'] ?? '', // Mengambil URL gambar dari API
    );
  }
}

Future<List<FoodItem>> fetchFoodItems(String foodName) async {
  final response = await http.get(Uri.parse(
    'https://api.nutritionix.com/v1_1/search/$foodName?appId=YOUR_APP_ID&appKey=YOUR_APP_KEY'));

  if (response.statusCode == 200) {
    final List<dynamic> foodData = jsonDecode(response.body)['hits'];
    return foodData.map((item) => FoodItem.fromJson(item['fields'])).toList();
  } else {
    throw Exception('Failed to load food data');
  }
}
