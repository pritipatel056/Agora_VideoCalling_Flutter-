import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../core/network/dio_client.dart';
import '../widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _pwController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);


    try {
      if (_emailController.text == "ppatel@gmail.com" &&
          _pwController.text == "123456") {
        // Success → navigate to Users screen
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/users');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid credentials")),
        );
      }
      /*final client = DioClient();
      final res = await client.dio.post('/login', data: {
        'email': _emailController.text,
        'password': _pwController.text,
      });
      if (res.statusCode == 200) {
// success — navigate
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/users');
      }*/
    } on DioException catch (e) {
      final message = e.response?.data['error'] ?? e.message;
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message.toString())));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (v) => (v == null || v.isEmpty) ? 'Enter email' : null,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _pwController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (v) => (v == null || v.isEmpty) ? 'Enter password' : null,
              ),
              const SizedBox(height: 20),
              _loading ? const CircularProgressIndicator() : CustomButton(label: 'Login', onPressed: _login),
            ],
          ),
        ),
      ),
    );
  }
}