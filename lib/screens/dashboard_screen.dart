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
                  left: 20.0, right: 20.0, top: 40.0, bottom: 20.0),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 21, 20, 57),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25.0),
                  bottomRight: Radius.circular(25.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calendar_month,
                              color: Colors.white70,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            DropdownButton<String>(
                              value: selectedMonth,
                              dropdownColor: const Color.fromARGB(255, 21, 20, 57),
                              underline: const SizedBox(),
                              icon: const Icon(Icons.keyboard_arrow_down,
                                  color: Colors.white70, size: 20),
                              items: months.map((month) {
                                return DropdownMenuItem(
                                  value: month,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: Text(
                                      month,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedMonth = value!;
                                  updateTotalsForSelectedMonth();
                                });
                              },
                              selectedItemBuilder: (BuildContext context) {
                                return months.map<Widget>((String month) {
                                  return Center(
                                    child: Text(
                                      month,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                }).toList();
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        child: GestureDetector(
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
                            radius: 25,
                            backgroundImage: AssetImage('assets/icon.png'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: Colors.green.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.trending_up,
                                    color: Colors.green,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Income',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                '\₹${totalIncome.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 26,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: Colors.red.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.trending_down,
                                    color: Colors.red,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Expense',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                '\₹${totalExpense.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 26,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            // Daily Summary Section
            Row(
              children: [
                Icon(
                  Icons.today,
                  color: Colors.white,
                  size: 28,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Daily Summary',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 21, 20, 57),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Row(
                children: [
                  // Today's Date
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Today',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            todayDate,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Income for Today
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.green.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Income',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '₹${dailyIncome.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Expense for Today
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.red.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Expense',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '₹${dailyExpense.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            // All Transactions Section
            Row(
              children: [
                Icon(
                  Icons.receipt_long,
                  color: Colors.white,
                  size: 28,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Today\'s Transactions',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: transactionsByDate.entries
                      .where((entry) =>
                          entry.key ==
                          DateFormat('yyyy-MM-dd').format(DateTime.now()))
                      .isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.receipt_outlined,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No transactions today',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Add your first transaction!',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView(
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
                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                child: Dismissible(
                                  key: Key(transaction['id'].toString()),
                                  direction: DismissDirection.endToStart,
                                  background: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                  ),
                                  onDismissed: (direction) async {
                                    await _dbHelper
                                        .deleteTransaction(transaction['id']);
                                    fetchTransactions();

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Transaction "${transaction['title']}" deleted',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                        backgroundColor: Colors.red,
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    );
                                  },
                                  child: TransactionCard(
                                    title: transaction['title'],
                                    subtitle: transaction['subtitle'],
                                    amount: transaction['amount'],
                                    isIncome: transaction['type'] == 'Income',
                                  ),
                                ),
                              );
                            }).toList(),
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
