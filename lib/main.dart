import 'package:finsight/firebase_options.dart';
import 'package:finsight/screens/dashboard_screen.dart';
import 'package:finsight/screens/email_verify.dart';
import 'package:finsight/screens/login_screen.dart';
import 'package:finsight/screens/records_screen.dart';
import 'package:finsight/screens/register_screen.dart';
import 'package:finsight/screens/splash_screen.dart';
import 'package:finsight/screens/transaction_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FinSight',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.white,
        scaffoldBackgroundColor: const Color.fromARGB(206, 2, 10, 27),
      ),
      initialRoute: '/login', // Set the initial route
      routes: {
        '/': (context) => const SplashScreen(), // Splash screen route
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/email-verify': (context) => const EmailVerification(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  // List of screens for the bottom navigation bar
  final List<Widget> _screens = [
    const DashboardScreen(),
    const TransactionScreen(),
    const RecordScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex], 
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 21, 20, 57), 
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update the selected index
          });
        },
        showSelectedLabels: true,
        showUnselectedLabels: false,
        selectedIconTheme: const IconThemeData(size: 30), 
        unselectedIconTheme: const IconThemeData(size: 25), 
        selectedLabelStyle: const TextStyle(fontSize: 14), 
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Records',
          ),
        ],
      ),
    );
  }
}