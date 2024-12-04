import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'login_page.dart';
import 'dashboard_page.dart';
import 'food_price.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Box userBox;
  String username = '';
  String email = '';
  String name = '';
  DateTime? birthDate;
  double? weight;
  double? height;

  TextEditingController nameController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  int _selectedIndex = 2; // Profile page index
  bool isEditing = false;
  String selectedTimeZone = 'WIB'; // Default timezone

  DateTime currentTime = DateTime.now();

  // List of Timezones
  final List<String> timeZones = ['WIB', 'WITA', 'WIT', 'London', 'Seoul'];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _updateCurrentTime();
  }

  void _updateCurrentTime() {
    final timeZoneOffsets = {
      'WIB': 7,
      'WITA': 8,
      'WIT': 9,
      'London': 0,
      'Seoul': 9,
    };
    final offset = timeZoneOffsets[selectedTimeZone]!;
    setState(() {
      currentTime = DateTime.now().toUtc().add(Duration(hours: offset));
    });
  }

  Future<void> _loadUserData() async {
    userBox = await Hive.openBox('userBox');
    setState(() {
      name = userBox.get('name', defaultValue: '');
      username = userBox.get('username', defaultValue: '');
      email = userBox.get('email', defaultValue: '');
      birthDate = userBox.get('birthDate');
      weight = userBox.get('weight');
      height = userBox.get('height');
      selectedTimeZone = userBox.get('selectedTimeZone', defaultValue: 'WIB');

      nameController.text = name;
      birthDateController.text = birthDate != null
          ? '${birthDate!.day}/${birthDate!.month}/${birthDate!.year}'
          : '';
      weightController.text = weight?.toString() ?? '';
      heightController.text = height?.toString() ?? '';
    });
  }

  void _logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  Future<void> _saveProfile() async {
    setState(() {
      name = nameController.text;
      weight = double.tryParse(weightController.text);
      height = double.tryParse(heightController.text);
    });

    await userBox.put('name', name);
    await userBox.put('birthDate', birthDate);
    await userBox.put('weight', weight);
    await userBox.put('height', height);
    await userBox.put('selectedTimeZone', selectedTimeZone);

    setState(() {
      isEditing = false;
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Profile berhasil diperbarui!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen()),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FoodPricePage()),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: birthDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (selectedDate != null && selectedDate != birthDate) {
      setState(() {
        birthDate = selectedDate;
        birthDateController.text =
            '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedTime = DateFormat('HH:mm:ss').format(currentTime);

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
        backgroundColor: Colors.green.shade700,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/images/kamil.jpg'),
              ),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 4,
              child: ListTile(
                title: Center(
                  child: Text(
                    'Username: $username',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                subtitle: Center(
                  child: Text(
                    'Email: $email',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            isEditing
                ? Card(
                    elevation: 5,
                    shadowColor: Colors.green.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              labelText: 'Name',
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 16),
                          TextField(
                            controller: birthDateController,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Birth Date',
                              prefixIcon: Icon(Icons.cake),
                              border: OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.calendar_today),
                                onPressed: () => _selectDate(context),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          TextField(
                            controller: weightController,
                            decoration: InputDecoration(
                              labelText: 'Weight (kg)',
                              prefixIcon: Icon(Icons.line_weight),
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(height: 16),
                          TextField(
                            controller: heightController,
                            decoration: InputDecoration(
                              labelText: 'Height (cm)',
                              prefixIcon: Icon(Icons.height),
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Ingin ubah waktu saat ini?',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          DropdownButton<String>(
                            value: selectedTimeZone,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedTimeZone = newValue!;
                                _updateCurrentTime();
                              });
                            },
                            items: timeZones.map<DropdownMenuItem<String>>(
                                (String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name: $name', style: TextStyle(fontSize: 16)),
                      SizedBox(height: 8),
                      Text('Birth Date: ${birthDateController.text}',
                          style: TextStyle(fontSize: 16)),
                      SizedBox(height: 8),
                      Text('Weight: ${weight?.toStringAsFixed(1) ?? '-'} kg',
                          style: TextStyle(fontSize: 16)),
                      SizedBox(height: 8),
                      Text('Height: ${height?.toStringAsFixed(1) ?? '-'} cm',
                          style: TextStyle(fontSize: 16)),
                      SizedBox(height: 8),
                      Text(
                          'Current Time ($selectedTimeZone): $formattedTime',
                          style: TextStyle(fontSize: 16)),
                    ],
                  ),
            SizedBox(height: 20),
            const Text(
              'Saya NIM 124220019 sudah berusaha semaksimal mungkin selama mengikuti mata kuliah Pemrograman Mobile ini, dan mohon maaf jika hasilnya belum sempurna, ya Pak. Semoga saya mendapat nilai yang terbaik. Terima kasih atas bimbingannya pak Bagus.',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isEditing ? _saveProfile : () => setState(() => isEditing = true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                padding: EdgeInsets.symmetric(vertical: 12),
                minimumSize: Size(double.infinity, 48),
              ),
              child: Text(
                isEditing ? 'Save Changes' : 'Edit Profile',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Food',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
