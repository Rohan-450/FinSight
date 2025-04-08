import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/db_helper.dart';
import '../utils/transaction_card.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  final DBHelper _dbHelper = DBHelper();
  Map<String, List<Map<String, dynamic>>> transactionsByMonth = {};
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchTransactions();
  }

  void fetchTransactions() async {
    final transactions = await _dbHelper.fetchTransactions();

    // Group transactions by month
    final groupedTransactions = <String, List<Map<String, dynamic>>>{};
    for (var transaction in transactions) {
      final month =
          DateFormat('MMMM').format(DateTime.parse(transaction['date']));
      if (!groupedTransactions.containsKey(month)) {
        groupedTransactions[month] = [];
      }
      groupedTransactions[month]!.add(transaction);
    }

    setState(() {
      transactionsByMonth = groupedTransactions;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Filter transactions based on the search query
    final filteredTransactions = transactionsByMonth
        .map((month, monthTransactions) {
          final filtered = monthTransactions
              .where((transaction) => transaction['title']!
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
              .toList();
          return MapEntry(month, filtered);
        })
        .entries
        .where((entry) => entry.value.isNotEmpty)
        .toMap();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            // Search Bar
            TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search transactions...',
                hintStyle: const TextStyle(color: Colors.white),
                filled: true,
                fillColor: const Color.fromARGB(255, 21, 20, 57),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 10),

            // Transactions List
            Expanded(
              child: ListView.builder(
                itemCount: filteredTransactions.keys.length,
                itemBuilder: (context, index) {
                  String month = filteredTransactions.keys.elementAt(index);
                  List<Map<String, dynamic>> monthTransactions =
                      filteredTransactions[month]!;

                  // Calculate the total net transaction value for the month
                  double totalNet =
                      monthTransactions.fold(0, (sum, transaction) {
                    double amount = transaction['amount'];
                    if (transaction['type'] == 'Income') {
                      return sum + amount; // Add income
                    } else if (transaction['type'] == 'Expense') {
                      return sum - amount; // Subtract expense
                    }
                    return sum;
                  });

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Month Header with Total Net Value
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              month,
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '₹${totalNet.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color:
                                    totalNet >= 0 ? Colors.green : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Transactions for the Month
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: monthTransactions.length,
                        itemBuilder: (context, transactionIndex) {
                          Map<String, dynamic> transaction =
                              monthTransactions[transactionIndex];
                          return TransactionCard(
                            title: transaction['title'],
                            subtitle: transaction['subtitle'] ?? '',
                            amount: transaction['amount'],
                            isIncome: transaction['type'] == 'Income',
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension MapFilter<K, V> on Iterable<MapEntry<K, V>> {
  Map<K, V> toMap() => {for (var entry in this) entry.key: entry.value};
}
