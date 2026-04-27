import 'package:flutter/material.dart';
import '../models/item.dart';
import '../database/database_helper.dart';

class ItemProvider extends ChangeNotifier {
  List<Item> _items = [];
  bool _isLoading = false;

  List<Item> get items => _items;
  bool get isLoading => _isLoading;

  ItemProvider() {
    loadItems();
  }

  // Loads items from the local database and updates the UI state
  Future<void> loadItems() async {
    _isLoading = true;
    notifyListeners();

    try {
      _items = await DatabaseHelper.instance.getItems();
    } catch (e) {
      debugPrint('Error loading items: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addItem(String name, String description) async {
    final now = DateTime.now();

    final newItem = Item(
      name: name,
      description: description,
      createdAt: now,
      updatedAt: now,
    );

    await DatabaseHelper.instance.insertItem(newItem);

    //Reloads items to include de SQLite-generated id
    await loadItems();
  }

  Future<void> updateItem(
    Item item,
    String newName,
    String newDescription,
  ) async {
    final updatedItem = item.copyWith(
      name: newName,
      description: newDescription,
      updatedAt: DateTime.now(),
    );

    await DatabaseHelper.instance.updateItem(updatedItem);
    await loadItems();
  }

  Future<void> deleteItem(int id) async {
    await DatabaseHelper.instance.deleteItem(id);
    await loadItems();
  }
}
