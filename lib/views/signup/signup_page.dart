import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:neighbourhood/constants.dart';
import 'package:neighbourhood/utils/glass_utils.dart';
import 'package:neighbourhood/utils/snackbar_utils.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _signUp() async {
    if (!_validateInputs()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/signup'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': nameController.text,
          'email': emailController.text,
          'password': passwordController.text,
        }),
      );

      if (response.statusCode == 201) {
        SnackBarUtils.showSuccess(
            context, 'Sign up successful! Please log in.');
        context.pop();
      } else {
        final error = json.decode(response.body);
        SnackBarUtils.showError(
            context, error['message'] ?? 'Sign up failed. Please try again.');
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
    if (nameController.text.trim().isEmpty) {
      SnackBarUtils.showError(context, 'Please enter your name');
      return false;
    }
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
              Colors.orange.shade600,
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
                    Text("Sign Up",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Text("Join Us",
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
                          controller: nameController,
                          hintText: "Name",
                          gradientColor: Colors.white,
                        ),
                        const SizedBox(height: 20),
                        GlassTextField(
                          controller: emailController,
                          hintText: "Email",
                          gradientColor: Colors.white,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 20),
                        GlassTextField(
                          controller: passwordController,
                          hintText: "Password",
                          gradientColor: Colors.white,
                          obscureText: true,
                        ),
                        const SizedBox(height: 40),
                        GlassButton(
                          onPressed: _isLoading ? null : _signUp,
                          gradientColor: Colors.white,
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                )
                              : const Text("Sign Up",
                                  style: TextStyle(color: Colors.white)),
                        ),
                        const SizedBox(height: 20),
                        TextButton(
                          onPressed: () => context.pop(),
                          child: const Text("Already have an account? Log in",
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
