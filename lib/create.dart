import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateTodoPage extends StatefulWidget {
  const CreateTodoPage({super.key});

  @override
  State<CreateTodoPage> createState() => _CreateTodoPageState();
}

class _CreateTodoPageState extends State<CreateTodoPage> {
  final listController = TextEditingController();
  final dateController = TextEditingController();
  final descriptionController = TextEditingController();

  int? userId;
  String status = 'low';
  bool isLoading = false;

  // 🎨 Warna pink
  final Color primaryColor = const Color(0xFFE91E63); // Pink
  final Color backgroundColor = const Color(0xFFFCE4EC); // Light pink
  final Color containerColor = Colors.white.withOpacity(0.1);
  final Color borderColor = Colors.white24;

  @override
  void initState() {
    super.initState();
    loadUserId();
  }

  Future<void> loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('userId');
    });
  }

  Future<void> createTodo() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User belum login')),
      );
      return;
    }

    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/todos'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'list': listController.text,
        'tanggal': dateController.text,
        'deskripsi': descriptionController.text,
        'status': status,
        'id_users': userId,
      }),
    );

    if (response.statusCode == 201) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal: ${response.body}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double maxWidth = 400;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: containerColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
                border: Border.all(color: borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Tambahkan List',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 24),

                  TextField(
                    controller: listController,
                    style: const TextStyle(color: Colors.black),
                    decoration: _inputDecoration('List', Icons.list),
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    controller: dateController,
                    readOnly: true,
                    style: const TextStyle(color: Colors.black),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          dateController.text =
                              pickedDate.toIso8601String().split('T')[0];
                        });
                      }
                    },
                    decoration: _inputDecoration('Tanggal', Icons.calendar_today),
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    controller: descriptionController,
                    maxLines: 4,
                    style: const TextStyle(color: Colors.black),
                    decoration: _inputDecoration('Deskripsi', Icons.description),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'Prioritas',
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      border: Border.all(color: borderColor),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: DropdownButton<String>(
                      value: status,
                      isExpanded: true,
                      underline: Container(),
                      dropdownColor: backgroundColor,
                      style: const TextStyle(color: Colors.black),
                      iconEnabledColor: primaryColor,
                      onChanged: (val) => setState(() => status = val!),
                      items: ['low', 'medium', 'high']
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e,
                                  style: const TextStyle(color: Colors.black)),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  ElevatedButton(
                    onPressed: createTodo,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Simpan',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.black54),
      floatingLabelStyle: TextStyle(color: primaryColor),
      prefixIcon: Icon(icon, color: primaryColor),
      filled: true,
      fillColor: Colors.white.withOpacity(0.2),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: primaryColor),
      ),
    );
  }
}
