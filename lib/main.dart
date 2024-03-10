//import 'package:finsight/screens/login_screen.dart';
//import 'package:finsight/screens/register_screen.dart';
import 'package:finsight/screens/login_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FinSight',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Color.fromARGB(206, 1, 15, 46),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height / 3.1,
          padding: EdgeInsets.all(10.0),
          decoration: const BoxDecoration(
            color: Color.fromRGBO(36, 34, 96, 0.612),
            borderRadius: BorderRadius.only(
              topLeft: Radius.zero,
              topRight: Radius.zero,
              bottomLeft: Radius.circular(25.0),
              bottomRight: Radius.circular(25.0),
            ),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 30.0),
              Row(
                children: [
                  SizedBox(width: 10.0),
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          'March',
                          style: TextStyle(
                            fontSize: 25.0,
                            //fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.arrow_drop_down),
                          onPressed: null,
                        ),
                      ],
                    ),
                  ),
                  CircleAvatar(
                      radius: 23,
                      backgroundImage: AssetImage('assets/images/avatar.png')),
                  SizedBox(width: 10.0),
                ],
              ),
              SizedBox(height: 30.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      SizedBox(width: 20.0),
                      Expanded(
                        child: Text(
                          'Income',
                          style: TextStyle(
                            fontSize: 40.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '1000',
                          style: TextStyle(
                            fontSize: 40.0,
                            color: Colors.green,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                      SizedBox(width: 30.0),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(width: 20.0),
                      Expanded(
                        child: Text(
                          'Expense',
                          style: TextStyle(
                            fontSize: 40.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '2000',
                          style: TextStyle(
                            fontSize: 40.0,
                            color: Colors.red,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                      SizedBox(width: 30.0),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 15.0),
        Container(
          margin: EdgeInsets.all(10.0),
          padding: EdgeInsets.all(10.0),
          height: 70,
          decoration: const BoxDecoration(
            color: Color.fromRGBO(36, 34, 96, 0.612),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                'Date',
                style: TextStyle(fontSize: 20.0),
              ),
              Text(
                'Income',
                style: TextStyle(fontSize: 20.0),
              ),
              Text(
                'Expense',
                style: TextStyle(fontSize: 20.0),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20.0),
        const Text(
          'All Transactions',
          style: TextStyle(
            fontSize: 23.0,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 100.0),
        ElevatedButton(
          child:const Text('Logout'),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
        ),
      ],
    ));
  }
}
