import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  String _passwordStrengthMessage = '';
  String _emailErrorMessage = '';

  String? _validateEmail(String? value) {
    final emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
    final regExp = RegExp(emailPattern);

    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    } else if (!regExp.hasMatch(value)) {
      setState(() {
        _emailErrorMessage = 'Email tidak valid';
      });
      return _emailErrorMessage;
    }
    setState(() {
      _emailErrorMessage = '';
    });
    return null;
  }

  String _passwordStrength(String password) {
    if (password.length < 3) {
      setState(() {
        _passwordStrengthMessage = 'Weak';
      });
      return 'Weak';
    } else if (password.length < 6) {
      setState(() {
        _passwordStrengthMessage = 'Medium';
      });
      return 'Medium';
    } else {
      setState(() {
        _passwordStrengthMessage = 'Strong';
      });
      return 'Strong';
    }
  }

  void _register() async {
    if (_passwordController.text == _confirmPasswordController.text) {
      var box = await Hive.openBox('userBox');
      await box.put('name', _nameController.text);
      await box.put('username', _usernameController.text);
      await box.put('email', _emailController.text);
      await box.put('password', _passwordController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registrasi berhasil!'),
          backgroundColor: Colors.green.shade700,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password dan Konfirmasi Password tidak cocok'),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Header dengan ilustrasi dan teks
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/images/logo.png', 
                        height: 150,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Create a New Account",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      ),
                    ),
                    Text(
                      "Complete your information to start using the app.",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                // Form Registrasi
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nama
                      _buildTextField(
                        label: "Nama",
                        controller: _nameController,
                        icon: Icons.person,
                        validator: (value) =>
                            value!.isEmpty ? "Nama tidak boleh kosong" : null,
                      ),
                      SizedBox(height: 16),
                      // Username
                      _buildTextField(
                        label: "Username",
                        controller: _usernameController,
                        icon: Icons.alternate_email,
                        validator: (value) =>
                            value!.isEmpty ? "Username tidak boleh kosong" : null,
                      ),
                      SizedBox(height: 16),
                      // Email
                      _buildTextField(
                        label: "Email",
                        controller: _emailController,
                        icon: Icons.email,
                        validator: _validateEmail,
                      ),
                      SizedBox(height: 16),
                      // Password
                      _buildPasswordField(
                        label: "Password",
                        controller: _passwordController,
                        onChanged: _passwordStrength,
                      ),
                      SizedBox(height: 8),
                      // Kekuatan Password
                      Text(
                        "Kekuatan Password: $_passwordStrengthMessage",
                        style: TextStyle(
                          color: _passwordStrengthMessage == "Weak"
                              ? Colors.red
                              : _passwordStrengthMessage == "Medium"
                                  ? Colors.orange
                                  : Colors.green,
                        ),
                      ),
                      SizedBox(height: 16),
                      // Konfirmasi Password
                      _buildPasswordField(
                        label: "Konfirmasi Password",
                        controller: _confirmPasswordController,
                      ),
                      SizedBox(height: 30),
                      // Tombol Register
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _register();
                          }
                        },
                        child: Text("Daftar"),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                          backgroundColor: Colors.green.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          textStyle: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                // Redirect ke Login
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?"),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.green.shade700),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: validator,
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(Icons.lock, color: Colors.green.shade700),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      onChanged: onChanged,
    );
  }
}
