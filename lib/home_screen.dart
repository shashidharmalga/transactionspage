import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'all_transactions_page.dart'; // adjust path as per your project

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _transactionType = TextEditingController();
  final TextEditingController _transactionCategory = TextEditingController();
  final TextEditingController _transactionAmount = TextEditingController();
  final TextEditingController _transactionNote = TextEditingController();
  final TextEditingController _transactionDate = TextEditingController();

  Future<void> addTransaction() async {
    final String type = _transactionType.text.trim();
    final String category = _transactionCategory.text.trim();
    final double? amount = double.tryParse(_transactionAmount.text.trim());
    final String note = _transactionNote.text.trim();
    final String date = _transactionDate.text.trim();

    if (type.isEmpty || category.isEmpty || amount == null || date.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    try {
      await Supabase.instance.client.from('expenses').insert({
        'user_id': Supabase.instance.client.auth.currentUser?.id,
        'type': type,
        'category': category,
        'amount': amount,
        'note': note,
        'transaction_date': date,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Transaction added successfully")),
      );

      _transactionType.clear();
      _transactionCategory.clear();
      _transactionAmount.clear();
      _transactionNote.clear();
      _transactionDate.clear();

      // Navigate to AllTransactionsPage after adding
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AllTransactionsPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      setState(() {
        _transactionDate.text = formattedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Transaction Page"),
        titleTextStyle: const TextStyle(
          color: Color.fromARGB(255, 245, 243, 241),
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Add Transaction",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 213, 47, 10),
                ),
              ),
              const SizedBox(height: 10.0),

              TextFormField(
                controller: _transactionType,
                decoration: InputDecoration(
                  hintText: "Type",
                  labelText: "Enter type (income/expense)",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Color.fromARGB(255, 218, 122, 26)),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),

              TextFormField(
                controller: _transactionCategory,
                decoration: InputDecoration(
                  hintText: "Category",
                  labelText: "Enter the category",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Color.fromARGB(255, 215, 141, 20)),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),

              TextFormField(
                controller: _transactionAmount,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Amount",
                  labelText: "Enter the amount",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Color.fromARGB(255, 215, 141, 20)),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),

              TextFormField(
                controller: _transactionNote,
                decoration: InputDecoration(
                  hintText: "Note",
                  labelText: "Any Note (optional)",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Color.fromARGB(255, 215, 141, 20)),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),

              TextFormField(
                controller: _transactionDate,
                onTap: _selectDate,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: "Date",
                  labelText: "Select your Date",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Color.fromARGB(255, 215, 141, 20)),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 82, 184, 104),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: addTransaction,
                      child: const Text("Add Transaction"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 235, 237, 108),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AllTransactionsPage()),
                        );
                      },
                      child: const Text("All Transactions"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
