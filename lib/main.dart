import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:FoodApp/screens/login_page.dart';

void main() async {
  // Inisialisasi Hive sebelum menjalankan aplikasi
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); // Menginisialisasi Hive

  // Membuka box Hive (misalnya untuk penyimpanan data pengguna)
  await Hive.openBox('userBox');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(), // Langsung mengarahkan ke halaman LoginPage
    );
  }
}
