import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:neighbourhood/constants.dart';
import 'package:neighbourhood/utils/glass_utils.dart';
import 'package:neighbourhood/utils/snackbar_utils.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;
  final storage = const FlutterSecureStorage();

  Future<void> _login() async {
    if (!_validateInputs()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': emailController.text.trim(),
          'password': passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        await storage.write(key: 'jwt', value: data['access']);
        // The refresh token is handled by the browser as HTTP-only cookie
        SnackBarUtils.showSuccess(context, 'Login successful!');
        context.go('/home');
      } else {
        final error = json.decode(response.body);
        SnackBarUtils.showError(
            context, error['message'] ?? 'Login failed. Please try again.');
      }
    } catch (e) {
      SnackBarUtils.showError(
          context, 'Network error. Please check your connection.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool _validateInputs() {
    if (emailController.text.trim().isEmpty) {
      SnackBarUtils.showError(context, 'Please enter your email');
      return false;
    }
    if (passwordController.text.isEmpty) {
      SnackBarUtils.showError(context, 'Please enter your password');
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Colors.orange.shade900,
              Colors.orange.shade800,
              Colors.orange.shade500,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 80),
              const Padding(
                padding: EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Login",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Text("Welcome Back",
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              GlassContainer(
                customBorderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(60),
                  topRight: Radius.circular(60),
                ),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height - 200,
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      children: <Widget>[
                        const SizedBox(height: 60),
                        GlassTextField(
                          controller: emailController,
                          hintText: "Email",
                          gradientColor: Colors.white,
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: const [
                            AutofillHints.username,
                            AutofillHints.email
                          ],
                        ),
                        const SizedBox(height: 20),
                        GlassTextField(
                          controller: passwordController,
                          hintText: "Password",
                          gradientColor: Colors.white,
                          obscureText: true,
                          autofillHints: const [AutofillHints.password],
                          onEditingComplete: () =>
                              TextInput.finishAutofillContext(),
                        ),
                        const SizedBox(height: 40),
                        GlassButton(
                          onPressed: _isLoading ? null : _login,
                          gradientColor: Colors.white,
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                )
                              : const Text("Login",
                                  style: TextStyle(color: Colors.white)),
                        ),
                        const SizedBox(height: 20),
                        TextButton(
                          onPressed: () => context.push('/signup'),
                          child: const Text("New here? Sign up",
                              style: TextStyle(color: Colors.white70)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
