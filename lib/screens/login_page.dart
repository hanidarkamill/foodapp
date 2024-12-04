import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:FoodApp/screens/dashboard_page.dart'; // Ensure this path matches your actual file
import 'register_page.dart'; // Ensure this path matches your actual file

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameEmailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isEmailLogin = false;
  bool _isPasswordVisible = false;

  // Login function
  void _login() async {
    var box = await Hive.openBox('userBox');
    String usernameEmail = _usernameEmailController.text;
    String password = _passwordController.text;

    var storedUsername = box.get('username');
    var storedEmail = box.get('email');
    var storedPassword = box.get('password');

    if ((_isEmailLogin && usernameEmail == storedEmail) || (!_isEmailLogin && usernameEmail == storedUsername)) {
      if (password == storedPassword) {
        // Successful login
        _showMessage('Login berhasil');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardScreen(),
          ),
        );
      } else {
        _showMessage('Password salah');
      }
    } else {
      _showMessage('Username atau Email salah');
    }
  }

  // Show feedback messages
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: Colors.green.shade700,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo.png', height: 150),
              SizedBox(height: 32), // Increased space between logo and form

              // Username/Email selector
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Login menggunakan: ',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  DropdownButton<bool>(
                    value: _isEmailLogin,
                    onChanged: (value) {
                      setState(() {
                        _isEmailLogin = value!;
                      });
                    },
                    items: [
                      DropdownMenuItem(
                        value: false,
                        child: Text('Username', style: TextStyle(fontSize: 16)),
                      ),
                      DropdownMenuItem(
                        value: true,
                        child: Text('Email', style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Username/Email input field
                    TextFormField(
                      controller: _usernameEmailController,
                      decoration: InputDecoration(
                        labelText: _isEmailLogin ? 'Email' : 'Username',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        prefixIcon: Icon(Icons.person, color: Colors.green.shade700),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return _isEmailLogin ? 'Email tidak boleh kosong' : 'Username tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    // Password input field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        prefixIcon: Icon(Icons.lock, color: Colors.green.shade700),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            color: Colors.green.shade700,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    // Login button
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _login(); // Call login function if form is valid
                        }
                      },
                      child: Text('Login'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        backgroundColor: Colors.green.shade700,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 5,
                      ),
                    ),
                    SizedBox(height: 16),

                    // Register button
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => RegisterPage()),
                        );
                      },
                      child: Text(
                        "Don't have an account? Register here",
                        style: TextStyle(color: Colors.green.shade700, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
