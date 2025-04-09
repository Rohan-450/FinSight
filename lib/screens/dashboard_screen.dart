import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/db_helper.dart';
import '../utils/transaction_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DBHelper _dbHelper = DBHelper();
  Map<String, List<Map<String, dynamic>>> transactionsByDate = {};
  String selectedMonth =
      DateFormat('MMMM').format(DateTime.now()); // Default to current month
  List<String> months = DateFormat.MMMM().dateSymbols.MONTHS;

  double totalIncome = 0.0;
  double totalExpense = 0.0;
  double dailyIncome = 0.0;
  double dailyExpense = 0.0;

  @override
  void initState() {
    super.initState();
    fetchTransactions();
  }

  void fetchTransactions() async {
    final transactions = await _dbHelper.fetchTransactions();

    // Group transactions by date
    final groupedTransactions = <String, List<Map<String, dynamic>>>{};
    for (var transaction in transactions) {
      final date =
          DateFormat('yyyy-MM-dd').format(DateTime.parse(transaction['date']));
      if (!groupedTransactions.containsKey(date)) {
        groupedTransactions[date] = [];
      }
      groupedTransactions[date]!.add(transaction);
    }

    setState(() {
      transactionsByDate = groupedTransactions;
      updateTotalsForSelectedMonth();
      updateDailyTotals();
    });
  }

  void updateTotalsForSelectedMonth() {
    double income = 0.0;
    double expense = 0.0;

    transactionsByDate.forEach((date, transactions) {
      final month = DateFormat('MMMM').format(DateTime.parse(date));
      if (month == selectedMonth) {
        for (var transaction in transactions) {
          if (transaction['type'] == 'Income') {
            income += transaction['amount'];
          } else if (transaction['type'] == 'Expense') {
            expense += transaction['amount'];
          }
        }
      }
    });

    setState(() {
      totalIncome = income;
      totalExpense = expense;
    });
  }

  void updateDailyTotals() {
    double income = 0.0;
    double expense = 0.0;
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    if (transactionsByDate.containsKey(today)) {
      for (var transaction in transactionsByDate[today]!) {
        if (transaction['type'] == 'Income') {
          income += transaction['amount'];
        } else if (transaction['type'] == 'Expense') {
          expense += transaction['amount'];
        }
      }
    }

    setState(() {
      dailyIncome = income;
      dailyExpense = expense;
    });
  }

  List<Map<String, dynamic>> getTransactionsForSelectedMonth() {
    final filteredTransactions = <Map<String, dynamic>>[];
    transactionsByDate.forEach((date, transactions) {
      final month = DateFormat('MMMM').format(DateTime.parse(date));
      if (month == selectedMonth) {
        filteredTransactions.addAll(transactions);
      }
    });
    return filteredTransactions;
  }

  @override
  Widget build(BuildContext context) {
    final String todayDate =
        DateFormat('MMM d').format(DateTime.now()).toUpperCase();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
            left: 16.0, right: 16.0, top: 0.0, bottom: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Monthly Summary Card
            Container(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16.0, top: 30.0, bottom: 16.0),
              decoration: const BoxDecoration(
                color:  Color.fromARGB(255, 21, 20, 57),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          DropdownButton<String>(
                            value: selectedMonth,
                            dropdownColor:
                                const Color.fromARGB(255, 21, 20, 57),
                            items: months.map((month) {
                              return DropdownMenuItem(
                                value: month,
                                child: Text(
                                  month,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedMonth = value!;
                                updateTotalsForSelectedMonth();
                              });
                            },
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          // Show dialog when the avatar is tapped
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor:
                                    const Color.fromARGB(255, 21, 20, 57),
                                title: const Text(
                                  'Account Options',
                                  style: TextStyle(color: Colors.white),
                                ),
                                content: const Text(
                                  'Do you want to logout?',
                                  style: TextStyle(color: Colors.white),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(
                                          context); // Close the dialog
                                    },
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await FirebaseAuth.instance
                                          .signOut(); // Sign out the user
                                      Navigator.pop(
                                          context); // Close the dialog
                                      Navigator.pushReplacementNamed(
                                          context, '/login');
                                    },
                                    child: const Text(
                                      'Logout',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage('assets/icon.png'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Income',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '\₹${totalIncome.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 24,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Expense',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '\₹${totalExpense.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 24,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            // Daily Summary Section
            const Text(
              'Daily Summary',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 21, 20, 57),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Today's Date
                  
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Today',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          todayDate,
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  
                  const SizedBox(
                    height: 60,
                    child: VerticalDivider(
                      color: Colors.blue,
                      thickness: 2,
                      width: 10,
                    ),
                  ),
                  // Income for Today
                  
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Income',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '₹${dailyIncome.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  
                  const SizedBox(
                    height: 60,
                    child: VerticalDivider(
                      color: Colors.blue,
                      thickness: 2,
                      width: 10,
                    ),
                  ),
                  // Expense for Today
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'Expense',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '₹${dailyExpense.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            // All Transactions Section
            const Text(
              'All Transactions',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            //const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: transactionsByDate.entries
                    .where((entry) =>
                        entry.key ==
                        DateFormat('yyyy-MM-dd').format(DateTime.now()))
                    .map((entry) {
                  final transactions = entry.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...transactions.map((transaction) {
                        return Dismissible(
                          key: Key(transaction['id']
                              .toString()), // Unique key for each transaction
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          onDismissed: (direction) async {
                            await _dbHelper.deleteTransaction(transaction['id']);
                            fetchTransactions();

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Transaction "${transaction['title']}" deleted'),
                              ),
                            );
                          },
                          child: TransactionCard(
                            title: transaction['title'],
                            subtitle: transaction['subtitle'],
                            amount: transaction['amount'],
                            isIncome: transaction['type'] == 'Income',
                          ),
                        );
                      }).toList(),
                      const SizedBox(height: 20),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
