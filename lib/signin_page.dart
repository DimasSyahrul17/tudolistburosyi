import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'signup_page.dart';
import 'list.dart';

const String apiBaseUrl = 'http://127.0.0.1:8000/api';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});
  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool loading = false;
  String error = '';

  Future<void> signin() async {
    setState(() {
      loading = true;
      error = '';
    });

    final response = await http.post(
      Uri.parse('$apiBaseUrl/signin'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'email': emailController.text,
        'password': passwordController.text,
      }),
    );

    setState(() {
      loading = false;
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final userId = data['user']?['id'];
      final token = data['token'];

      if (userId != null && token != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('id', userId);
        await prefs.setString('token', token);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login berhasil')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const TodoListPage()),
      );
    } else {
      final data = jsonDecode(response.body);
      setState(() {
        error = data['message'] ?? 'Login gagal';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      backgroundColor: const Color(0xFFFCE4EC), // Light pink background
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            width: isWideScreen ? 400 : double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF0F5), // Lightest pink box
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFF8BBD0)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFF48FB1).withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFD81B60), // Deep pink
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
                TextField(
                  controller: emailController,
                  style: const TextStyle(color: Colors.black87),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email, color: Color(0xFFD81B60)),
                    labelText: 'Email',
                    labelStyle: const TextStyle(color: Colors.black54),
                    filled: true,
                    fillColor: const Color(0xFFF8BBD0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.black87),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock, color: Color(0xFFD81B60)),
                    labelText: 'Password',
                    labelStyle: const TextStyle(color: Colors.black54),
                    filled: true,
                    fillColor: const Color(0xFFF8BBD0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                loading
                    ? const Center(
                        child: CircularProgressIndicator(color: Color(0xFFD81B60)),
                      )
                    : ElevatedButton(
                        onPressed: signin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD81B60),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SignUpPage()),
                    );
                  },
                  child: const Text(
                    'Belum punya akun? Daftar',
                    style: TextStyle(color: Color(0xFFD81B60)),
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
