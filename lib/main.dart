import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'signin_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Laravel Auth',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFF48FB1), // Soft pink seed
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFFCE4EC), // Light pink background
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF8BBD0), // AppBar pink
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD81B60), // Darker pink button
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF8BBD0), // Input field pink
          labelStyle: const TextStyle(color: Colors.black54),
          floatingLabelStyle: const TextStyle(color: Color(0xFFD81B60)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFD81B60)),
          ),
        ),
        textTheme: GoogleFonts.nunitoTextTheme(),
      ),
      home: const SignInPage(),
    );
  }
}
