import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/transaction_provider.dart';
import '../models/transaction.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transaksi = ref.watch(transactionProvider);
    final total = ref.watch(transactionProvider.notifier).total;

    final titleController = TextEditingController();
    final amountController = TextEditingController();
    String selectedCategory = 'Makanan & Minuman';
    final categories = [
      'Makanan & Minuman',
      'Transportasi',
      'Belanja',
      'Tagihan',
      'Lainnya'
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Pengeluaranku 💸'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: StatefulBuilder(builder: (context, setState) {
                  return Column(
                    children: [
                      TextField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          labelText: 'Nama Transaksi',
                          prefixIcon: Icon(Icons.note_alt_outlined),
                        ),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: selectedCategory,
                        items: categories
                            .map((cat) => DropdownMenuItem(
                          value: cat,
                          child: Text(cat),
                        ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value!;
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Kategori',
                          prefixIcon: Icon(Icons.category),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Jumlah (Rp)',
                          prefixIcon: Icon(Icons.attach_money),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.save),
                          label: const Text('Simpan Transaksi'),
                          onPressed: () {
                            final title = titleController.text.trim();
                            final amount =
                                double.tryParse(amountController.text) ?? 0;
                            if (title.isNotEmpty && amount > 0) {
                              ref
                                  .read(transactionProvider.notifier)
                                  .addTransaction(
                                  title, selectedCategory, amount);
                              titleController.clear();
                              amountController.clear();
                              FocusScope.of(context).unfocus();
                            }
                          },
                        ),
                      )
                    ],
                  );
                }),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: transaksi.isEmpty
                  ? const Center(
                child: Text(
                  'Belum ada transaksi hari ini.',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              )
                  : ListView.builder(
                itemCount: transaksi.length,
                itemBuilder: (context, index) {
                  final tx = transaksi[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.teal,
                        child: Text(
                          tx.category[0],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(tx.title),
                      subtitle: Text(
                        '${tx.category} • ${tx.date.day}/${tx.date.month}/${tx.date.year}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      trailing: Text(
                        'Rp ${tx.amount.toStringAsFixed(0)}',
                        style: const TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Total Pengeluaran Hari Ini: Rp ${total.toStringAsFixed(0)}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
