import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AllTransactionsPage extends StatefulWidget {
  const AllTransactionsPage({super.key});

  @override
  State<AllTransactionsPage> createState() => _AllTransactionsPageState();
}

class _AllTransactionsPageState extends State<AllTransactionsPage> {
  List<dynamic> transactions = [];

  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    final response = await Supabase.instance.client
        .from('expenses')
        .select()
        .eq('user_id', Supabase.instance.client.auth.currentUser!.id)
        .order('transaction_date', ascending: false);

    setState(() {
      transactions = response;
    });
  }

  Future<void> deleteTransaction(String transactionId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text("Are you sure you want to delete this transaction?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await Supabase.instance.client
          .from('expenses')
          .delete()
          .eq('transaction_id', transactionId);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Transaction deleted")),
      );

      fetchTransactions();
    }
  }

  void editTransaction(Map transaction) {
    _typeController.text = transaction['type'];
    _categoryController.text = transaction['category'];
    _amountController.text = transaction['amount'].toString();
    _noteController.text = transaction['note'] ?? '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Transaction"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: _typeController,
                decoration: const InputDecoration(labelText: "Type"),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: "Category"),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Amount"),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(labelText: "Note"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final String type = _typeController.text.trim();
              final String category = _categoryController.text.trim();
              final double? amount = double.tryParse(_amountController.text.trim());
              final String note = _noteController.text.trim();

              if (type.isEmpty || category.isEmpty || amount == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please fill all fields")),
                );
                return;
              }

              await Supabase.instance.client
                  .from('expenses')
                  .update({
                    'type': type,
                    'category': category,
                    'amount': amount,
                    'note': note,
                  })
                  .eq('transaction_id', transaction['transaction_id']);

              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Transaction updated")),
              );

              fetchTransactions();
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Transactions"),
        backgroundColor: Colors.blueAccent,
      ),
      body: transactions.isEmpty
          ? const Center(
              child: Text(
                "No transactions yet",
                style: TextStyle(color: Color.fromARGB(255, 79, 211, 223), fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12.0),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final t = transactions[index];
                return Card(
                  color: Colors.blue.shade50,
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    title: Text(
                      "${t['type']} - ${t['category']}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 209, 22, 5),
                      ),
                    ),
                    subtitle: Text(
                      "₹${t['amount']} on ${t['transaction_date']}\nNote: ${t['note'] ?? ''}",
                      style: const TextStyle(color: Color.fromARGB(221, 53, 38, 215)),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.deepPurple),
                          onPressed: () => editTransaction(t),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteTransaction(t['transaction_id']),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
