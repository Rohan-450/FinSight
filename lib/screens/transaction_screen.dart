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
                  left: 20.0, right: 20.0, top: 60.0, bottom: 20.0),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 21, 20, 57),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25.0),
                  bottomRight: Radius.circular(25.0),
                ),
              ),
              child: Center(
                child: const Text(
                  'Add Transaction',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            
            // Form Section
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const SizedBox(height: 15),

                  // Amount Input Field
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 21, 20, 57),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.3),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Amount',
                        labelStyle: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        prefixIcon: Icon(Icons.currency_rupee, color: Colors.white.withOpacity(0.8), size: 20),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Transaction Type Selector
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 21, 20, 57),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.3),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.swap_horiz,
                              color: Colors.white.withOpacity(0.8),
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Transaction Type',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: (_transactionType == 'Income' ? Colors.green : Colors.red).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: (_transactionType == 'Income' ? Colors.green : Colors.red).withOpacity(0.4),
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
                              size: 18,
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'Income',
                                child: Text(
                                  'Income',
                                  style: TextStyle(color: Colors.green, fontSize: 14, fontWeight: FontWeight.w600),
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'Expense',
                                child: Text(
                                  'Expense',
                                  style: TextStyle(color: Colors.red, fontSize: 14, fontWeight: FontWeight.w600),
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
                  const SizedBox(height: 16),

                  // Title Input Field
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 21, 20, 57),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.3),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        prefixIcon: Icon(Icons.title, color: Colors.white.withOpacity(0.8), size: 20),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Subtitle Input Field
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 21, 20, 57),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.3),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _subtitleController,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        prefixIcon: Icon(Icons.description, color: Colors.white.withOpacity(0.8), size: 20),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Save Button
                  Container(
                    width: double.infinity,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
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
                            size: 20,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Save Transaction',
                            style: TextStyle(
                              fontSize: 16,
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