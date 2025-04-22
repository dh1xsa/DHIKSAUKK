import 'package:coba1/color.dart';
import 'package:coba1/screen/Home/home_screen.dart';
import 'package:coba1/screen/admin/screen_admin/room_admin/room_view_screen.dart';
import 'package:coba1/screen/register_screen.dart';
import 'package:coba1/screen/resepsionis/resep_screen.dart';
import 'package:coba1/widget/my_button.dart';
import 'package:coba1/widget/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

  class _LoginScreenState extends State<LoginScreen> {
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

    final SupabaseClient _supabase = Supabase.instance.client;

    static const String adminEmail = 'admin@gmail.com';
    static const String resepsionisEmail = 'resep@gmail.com';

    void _login() async {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      if (email.isEmpty || password.isEmpty) {
        _showSnackBar('Email dan password tidak boleh kosong');
        return;
      }

      try {
        final response = await _supabase.auth.signInWithPassword(
          email: email,
          password: password,
        );

        if (response.user == null) {
          _showSnackBar('Login gagal: User tidak ditemukan');
          return;
        }
        if (email == adminEmail) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => RoomViewScreen()),
          );
        } else if (email == resepsionisEmail) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ResepsionisScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        }
      } catch (e) {
        _showSnackBar('Login gagal: ${e.toString()}');
      }
    }

    void _showSnackBar(String message) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }

    @override
      Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: kBackgroundColor,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                const Icon(Icons.lock, size: 100),
                const SizedBox(height: 50),
                Text(
                  'Welcome Back, you\'ve been missed',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 50),
                MyTextField(
                    controller: _emailController,
                    hintText: 'Email',
                    obscureText: false,
                ),

                const SizedBox(height: 25),
                MyTextField(
                    controller: _passwordController,
                    hintText: 'Password',
                    obscureText: true,
                ),

                const SizedBox(height: 70),
                MyButton(
                    onTap: _login,
                    text: 'Sign In',
                ),

                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a Member?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),

                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterScreen()),
                      ),
                      child: const Text(
                        'Register Now',
                        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      );
    }
  }


