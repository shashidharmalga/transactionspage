import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AllTransactionsPage extends StatefulWidget {
  const AllTransactionsPage({super.key});

  @override
  State<AllTransactionsPage> createState() => _AllTransactionsPageState();
}

class _AllTransactionsPageState extends State<AllTransactionsPage> {
  List<dynamic> transactions = [];

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
                  ),
                );
              },
            ),
    );
  }
}
