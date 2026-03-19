import 'package:flutter/material.dart';
import 'package:quiz_app/auth/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiz_app/quiz.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formkey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  void login() async {
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);
        User? user = userCredential.user;
        if (user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Quiz()),
          );
        }
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed: ${e.message}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade800, Colors.purple.shade800],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _header(),
                      const SizedBox(height: 48),
                      _inputField(),
                      const SizedBox(height: 24),
                      _forgotPassword(),
                      const SizedBox(height: 24),
                      _signup(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Column(
      children: [
        Text(
          "Welcome Back",
          style: GoogleFonts.poppins(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Enter your credentials to login",
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _inputField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          decoration: InputDecoration(
            hintText: "Email",
            hintStyle: GoogleFonts.poppins(color: Colors.white60),
            filled: true,
            fillColor: Colors.white.withOpacity(0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            prefixIcon: const Icon(Icons.email, color: Colors.white70),
          ),
          style: GoogleFonts.poppins(color: Colors.white),
          validator: (value) =>
              value!.isEmpty ? 'Please enter your email' : null,
          onSaved: (newValue) => _email = newValue ?? '',
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: InputDecoration(
            hintText: "Password",
            hintStyle: GoogleFonts.poppins(color: Colors.white60),
            filled: true,
            fillColor: Colors.white.withOpacity(0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            prefixIcon: const Icon(Icons.lock, color: Colors.white70),
          ),
          style: GoogleFonts.poppins(color: Colors.white),
          obscureText: true,
          validator: (value) =>
              value!.isEmpty ? 'Please enter your password' : null,
          onSaved: (newValue) => _password = newValue ?? '',
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: login,
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.purple.shade800,
            backgroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Text(
            "Login",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        )
      ],
    );
  }

  Widget _forgotPassword() {
    return TextButton(
      onPressed: () {},
      child: Text(
        "Forgot password?",
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _signup() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: GoogleFonts.poppins(color: Colors.white70),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SignupScreen()),
            );
          },
          child: Text(
            "Sign Up",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}
