import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class EditTodoPage extends StatefulWidget {
  final Map todo;
  final int id;
  const EditTodoPage({super.key, required this.todo, required this.id});

  @override
  State<EditTodoPage> createState() => _EditTodoPageState();
}

class _EditTodoPageState extends State<EditTodoPage> {
  late TextEditingController listController;
  late TextEditingController dateController;
  late TextEditingController descriptionController;
  late String status;

  final Color primaryColor = const Color(0xFFF06292); // Pink
  final Color darkColor = const Color(0xFFAD1457); // Dark pink
  final Color backgroundColor = const Color(0xFFFCE4EC); // Light pink
  final Color containerColor = Colors.white.withOpacity(0.9);

  @override
  void initState() {
    super.initState();
    listController = TextEditingController(text: widget.todo['list']);
    dateController = TextEditingController(text: widget.todo['tanggal']);
    descriptionController = TextEditingController(text: widget.todo['deskripsi']);
    status = widget.todo['status'];
  }

  Future<void> updateTodo() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User belum login')),
      );
      return;
    }

    final response = await http.put(
      Uri.parse('http://127.0.0.1:8000/api/edit/${widget.id}'),
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
      }),
    );

    if (response.statusCode == 200) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengedit to-do: ${response.body}')),
      );
    }
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.black54),
      floatingLabelStyle: TextStyle(color: primaryColor),
      prefixIcon: Icon(icon, color: primaryColor),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: primaryColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double maxWidth = 400;
    final double maxHeight = MediaQuery.of(context).size.height * 0.9;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            width: maxWidth,
            constraints: BoxConstraints(maxHeight: maxHeight),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: containerColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
              border: Border.all(color: Colors.pink.shade100),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Edit List',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: darkColor,
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
                      initialDate: DateTime.tryParse(dateController.text) ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        dateController.text = pickedDate.toIso8601String().split('T')[0];
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
                    color: darkColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.pink.shade100),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: DropdownButton<String>(
                    value: status,
                    isExpanded: true,
                    underline: Container(),
                    dropdownColor: Colors.white,
                    style: const TextStyle(color: Colors.black),
                    iconEnabledColor: primaryColor,
                    onChanged: (val) => setState(() => status = val!),
                    items: ['low', 'medium', 'high']
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(
                                e,
                                style: const TextStyle(color: Colors.black),
                              ),
                            ))
                        .toList(),
                  ),
                ),
                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: updateTodo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Update',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
