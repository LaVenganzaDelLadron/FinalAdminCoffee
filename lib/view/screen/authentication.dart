import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  final AuthController _authController = Get.put(AuthController());


  bool _loading = false;

  void _login() async {
    if (_usernameController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter both username and password"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _loading = true);

    _authController.login(
      _usernameController.text.trim(),
      _passwordController.text.trim(),
    );

    setState(() => _loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Login attempt..."),
        backgroundColor: Colors.brown,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB98068), Color(0xFF4B2E05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "☕ Coffee Admin",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Login to manage your coffee shop",
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 32),

                    // Username
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_outline),
                        labelText: "Username",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Password
                    TextField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock_outline),
                        labelText: "Password",
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4B2E05),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
