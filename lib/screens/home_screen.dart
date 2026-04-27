import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/item.dart';
import '../providers/item_provider.dart';
import '../widgets/item_card.dart';
import '../widgets/item_form_dialog.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showFormDialog(BuildContext context, {Item? item}) {
    showDialog(
      context: context,
      builder: (_) => ItemFormDialog(itemToEdit: item),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Item Manager',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
        elevation: 0,
      ),
      body: Consumer<ItemProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.items.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.inbox, size: 60, color: Colors.grey),
                    SizedBox(height: 12),
                    Text(
                      'No items yet',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Tap + to add your first item',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: provider.items.length,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            itemBuilder: (context, index) {
              final item = provider.items[index];

              return ItemCard(
                item: item,
                onEdit: () => _showFormDialog(context, item: item),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add item',
        onPressed: () => _showFormDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
