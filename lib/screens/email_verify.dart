import 'package:finsight/main.dart';
import 'package:finsight/screens/register_screen.dart';
import 'package:flutter/material.dart';

class EmailVerification extends StatefulWidget {
  const EmailVerification({super.key});

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        //effects: const [ShimmerEffect()],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/images/avatar.png'),
              ),
            const SizedBox(
              height: 40,
            ),
            const Text(
              "A verification mail has been sent  to emailaddress@gmail.com \n  Please verify to continue !",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
                width: 300,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 28, 113, 214)),
                  child: const Text('Verify',
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
            const SizedBox(
              height: 10,
            ),
            TextButton(
              child:const Text('Did not got a email? click here to resend...',
                  style: TextStyle(color: Color.fromARGB(255, 28, 113, 214))),
              onPressed: () {},
            ),
            const SizedBox(height: 10),
            TextButton(
              child:const Text('Wrong email? log out here...',
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
    );
  }
}
