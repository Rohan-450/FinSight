import 'package:flutter/material.dart';

import '../database/db_helper.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();
  String _transactionType = 'Income'; 
  final DBHelper _dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(206, 2, 10, 27),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.only(
                  left: 55.0, right: 20.0, top: 60.0, bottom: 20.0),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 21, 20, 57),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25.0),
                  bottomRight: Radius.circular(25.0),
                ),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 40),
                  const Text(
                    'Add Transaction',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            
            // Form Section
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const SizedBox(height: 25),

                  // Amount Input Field
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 21, 20, 57),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Amount',
                        labelStyle: TextStyle(color: Colors.white),
                        prefixIcon: Icon(Icons.currency_rupee, color: Colors.white),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(20),
                      ),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Transaction Type Selector
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 21, 20, 57),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.swap_horiz,
                              color: Colors.white,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Transaction Type',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: (_transactionType == 'Income' ? Colors.green : Colors.red).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: (_transactionType == 'Income' ? Colors.green : Colors.red).withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: DropdownButton<String>(
                            value: _transactionType,
                            dropdownColor: const Color.fromARGB(255, 21, 20, 57),
                            underline: const SizedBox(),
                            icon: Icon(
                              Icons.keyboard_arrow_down,
                              color: _transactionType == 'Income' ? Colors.green : Colors.red,
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'Income',
                                child: Text(
                                  'Income',
                                  style: TextStyle(color: Colors.green, fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'Expense',
                                child: Text(
                                  'Expense',
                                  style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _transactionType = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Title Input Field
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 21, 20, 57),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle: TextStyle(color: Colors.white),
                        prefixIcon: Icon(Icons.title, color: Colors.white),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(20),
                      ),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Subtitle Input Field
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 21, 20, 57),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      controller: _subtitleController,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle: TextStyle(color: Colors.white),
                        prefixIcon: Icon(Icons.description, color: Colors.white),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(20),
                      ),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Save Button
                  Container(
                    width: double.infinity,
                    height: 55,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 21, 20, 57),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () async {
                        // Save transaction logic here
                        final String amount = _amountController.text;
                        final String title = _titleController.text;
                        final String subtitle = _subtitleController.text;

                        if (amount.isNotEmpty && title.isNotEmpty) {
                          final transaction = {
                            'title': title,
                            'subtitle': subtitle,
                            'amount': double.parse(amount),
                            'type': _transactionType,
                            'date': DateTime.now().toString(),
                          };
                          await _dbHelper.insertTransaction(transaction);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                'Transaction Saved Successfully!',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                          _amountController.clear();
                          _titleController.clear();
                          _subtitleController.clear();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                'Please fill in all required fields',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.save,
                            color: Colors.white,
                            size: 24,
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Save Transaction',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}