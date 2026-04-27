import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/item.dart';
import '../providers/item_provider.dart';

class ItemFormDialog extends StatefulWidget {
  final Item? itemToEdit;

  const ItemFormDialog({super.key, this.itemToEdit});

  @override
  State<ItemFormDialog> createState() => _ItemFormDialogState();
}

class _ItemFormDialogState extends State<ItemFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    //Preloads existing data when editing an item
    _nameController = TextEditingController(
      text: widget.itemToEdit?.name ?? '',
    );

    _descriptionController = TextEditingController(
      text: widget.itemToEdit?.description ?? '',
    );
  }

  @override
  void dispose() {
    //Releases controller resources when the dialog is disposed
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final provider = context.read<ItemProvider>();

      if (widget.itemToEdit == null) {
        await provider.addItem(
          _nameController.text.trim(),
          _descriptionController.text.trim(),
        );
      } else {
        await provider.updateItem(
          widget.itemToEdit!,
          _nameController.text.trim(),
          _descriptionController.text.trim(),
        );
      }

      if (mounted) {
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.itemToEdit == null ? 'Item created' : 'Item updated',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Error saving item')));
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.itemToEdit != null;

    return AlertDialog(
      title: Text(isEditing ? 'Edit Item' : 'New Item'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Name is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Description is required';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.pop(context),
          child: const Text('CANCEL'),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _save,
          child: _isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('SAVE'),
        ),
      ],
    );
  }
}
