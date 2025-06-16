import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String apiBaseUrl = 'http://127.0.0.1:8000/api';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;
  String error = '';

  Future<void> signup() async {
    setState(() {
      loading = true;
      error = '';
    });

    final response = await http.post(
      Uri.parse('$apiBaseUrl/signup'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'username': usernameController.text,
        'email': emailController.text,
        'password': passwordController.text,
      }),
    );

    setState(() {
      loading = false;
    });

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registrasi berhasil, silakan login')),
      );
      Navigator.pop(context);
    } else {
      final data = jsonDecode(response.body);
      setState(() {
        error = data['message'] ?? 'Registrasi gagal';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5), // Lavender blush
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFB6C1), // Light Pink
        elevation: 0,
        title: const Text(
          'Sign Up',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            width: isWideScreen ? 400 : double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.pinkAccent.withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF1493), // Deep pink
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                if (error.isNotEmpty)
                  Text(
                    error,
                    style: const TextStyle(color: Colors.redAccent),
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: 16),

                // Username
                TextField(
                  controller: usernameController,
                  style: const TextStyle(color: Colors.black87),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person, color: Color(0xFFFF69B4)), // Hot pink
                    labelText: 'Username',
                    labelStyle: const TextStyle(color: Colors.black54),
                    floatingLabelStyle: const TextStyle(color: Color(0xFFFF69B4)),
                    filled: true,
                    fillColor: const Color(0xFFFFE4E1), // Misty Rose
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFFFF69B4)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Email
                TextField(
                  controller: emailController,
                  style: const TextStyle(color: Colors.black87),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email, color: Color(0xFFFF69B4)),
                    labelText: 'Email',
                    labelStyle: const TextStyle(color: Colors.black54),
                    floatingLabelStyle: const TextStyle(color: Color(0xFFFF69B4)),
                    filled: true,
                    fillColor: const Color(0xFFFFE4E1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFFFF69B4)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Password
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.black87),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock, color: Color(0xFFFF69B4)),
                    labelText: 'Password',
                    labelStyle: const TextStyle(color: Colors.black54),
                    floatingLabelStyle: const TextStyle(color: Color(0xFFFF69B4)),
                    filled: true,
                    fillColor: const Color(0xFFFFE4E1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFFFF69B4)),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Submit button
                loading
                    ? const Center(child: CircularProgressIndicator(color: Color(0xFFFF69B4)))
                    : ElevatedButton.icon(
                        onPressed: signup,
                        icon: const Icon(Icons.arrow_forward, color: Colors.white),
                        label: const Text(
                          'Create Account',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF69B4), // Hot pink
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
