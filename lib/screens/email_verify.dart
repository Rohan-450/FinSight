import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailVerification extends StatefulWidget {
  const EmailVerification({super.key});

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  bool _isEmailVerified = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    _isEmailVerified = _user?.emailVerified ?? false;

    if (!_isEmailVerified) {
      _sendVerificationEmail();
    }
  }

  // Function to send verification email
  Future<void> _sendVerificationEmail() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await _user?.sendEmailVerification();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verification email sent!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Function to check if the email is verified
  Future<void> _checkEmailVerified() async {
    await _user?.reload();
    setState(() {
      _isEmailVerified = _auth.currentUser?.emailVerified ?? false;
    });

    if (_isEmailVerified) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email not verified yet!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/icon.png'),
            ),
            const SizedBox(height: 40),
            const Text(
              "A verification mail has been sent to your email address.\nPlease verify to continue!",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
            ),
            const SizedBox(height: 30),
            _isLoading
                ? const CircularProgressIndicator() // Show loading indicator while sending email
                : Container(
                    width: 300,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 28, 113, 214),
                      ),
                      child: const Text('Verify',
                          style: TextStyle(color: Colors.white)),
                      onPressed: _checkEmailVerified, // Check email verification
                    ),
                  ),
            const SizedBox(height: 10),
            TextButton(
              child: Text(
                'Did not get an email? Click here to resend...',
                style: TextStyle(color: Color.fromARGB(255, 28, 113, 214)),
              ),
              onPressed: _sendVerificationEmail, // Resend verification email
            ),
            const SizedBox(height: 10),
            TextButton(
              child: const Text(
                'Wrong email? Log out here...',
                style: TextStyle(color: Color.fromARGB(255, 28, 113, 214)),
              ),
              onPressed: () async {
                await _auth.signOut();
                Navigator.pushReplacementNamed(context, '/register');
              },
            ),
          ],
        ),
      ),
    );
  }
}