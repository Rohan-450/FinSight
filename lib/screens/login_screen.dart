import 'package:finsight/main.dart';
import 'package:finsight/screens/register_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/images/avatar.png'),
              ),
              const SizedBox(height: 35),
              const Text('Welcome Back..',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              const SizedBox(height: 15),
              const TextField(
                decoration: InputDecoration(
                  label: Text('Email', style: TextStyle(color: Colors.white)),
                  filled: true,
                  fillColor: Colors.transparent,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  prefixIcon: Icon(Icons.email,color: Colors.white),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 15),
              const TextField(
                decoration: InputDecoration(
                  label:
                      Text('Password', style: TextStyle(color: Colors.white)),
                  filled: true,
                  fillColor: Colors.transparent,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(
                        color: Colors
                            .blue), // Change this to your desired color
                  ),
                  prefixIcon: Icon(Icons.lock, color: Colors.white),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 15),
              Container(
                width: 300,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 28, 113, 214)),
                  child: const Text('Login',
                      style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomePage()),
                    );
                  },
                ),
              ),
              TextButton(
                child: const Text('Don\'t have an account? Register here',
                    style: TextStyle(color: Color.fromARGB(255, 28, 113, 214))),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
