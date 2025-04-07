import 'dart:math';

import 'package:flutter/material.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  // Sample data for transactions grouped by month
  final Map<String, List<Map<String, String>>> transactions = {
    'January': [
      {'title': 'Groceries', 'amount': '-50'},
      {'title': 'Salary', 'amount': '+2000'},
    ],
    'February': [
      {'title': 'Rent', 'amount': '-800'},
      {'title': 'Freelance', 'amount': '+500'},
    ],
    'March': [
      {'title': 'Electricity Bill', 'amount': '-100'},
      {'title': 'Bonus', 'amount': '+300'},
    ],
  };

  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    // Filter transactions based on the search query
    final filteredTransactions = transactions.map((month, monthTransactions) {
      final filtered = monthTransactions
          .where((transaction) => transaction['title']!
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()))
          .toList();
      return MapEntry(month, filtered);
    }).entries.where((entry) => entry.value.isNotEmpty).toMap();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            const SizedBox(height: 40),
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
                  List<Map<String, String>> monthTransactions =
                      filteredTransactions[month]!;

                  // Calculate the total net transaction value for the month
                  double totalNet =
                      monthTransactions.fold(0, (sum, transaction) {
                    double amount = double.parse(transaction['amount']!
                        .replaceAll(RegExp(r'[^\d.-]'), ''));
                    return sum + amount;
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
                              totalNet.toStringAsFixed(2),
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
                          Map<String, String> transaction =
                              monthTransactions[transactionIndex];
                          return Card(
                            color: const Color.fromARGB(255, 21, 20, 57),
                            margin: const EdgeInsets.only(bottom: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              leading: const CircleAvatar(
                                backgroundColor: Colors.blue,
                                child: Icon(
                                  Icons.attach_money,
                                  color: Colors.white,
                                ),
                              ),
                              title: Text(
                                transaction['title']!,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                              trailing: Text(
                                transaction['amount']!,
                                style: TextStyle(
                                    color:
                                        transaction['amount']!.startsWith('+')
                                            ? Colors.green
                                            : Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
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