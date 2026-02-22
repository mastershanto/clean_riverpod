import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Form dialog for creating or editing an ad.
class AdFormDialog extends StatefulWidget {
  const AdFormDialog({
    super.key,
    required this.isEdit,
    required this.onSave,
    this.initialTitle = '',
    this.initialDescription = '',
    this.initialPrice = '',
    this.initialCategory = 'Electronics',
    this.initialVendorName = '',
  });

  final bool isEdit;
  final String initialTitle;
  final String initialDescription;
  final String initialPrice;
  final String initialCategory;
  final String initialVendorName;
  final Future<void> Function(
    String title,
    String description,
    double price,
    String category,
    String vendorName,
  ) onSave;

  @override
  State<AdFormDialog> createState() => _AdFormDialogState();
}

class _AdFormDialogState extends State<AdFormDialog> {
  late final TextEditingController titleCtrl;
  late final TextEditingController descCtrl;
  late final TextEditingController priceCtrl;
  late final TextEditingController vendorCtrl;
  late String selectedCategory;
  final formKey = GlobalKey<FormState>();

  static const categories = [
    'Electronics',
    'Fashion',
    'Furniture',
    'Food',
    'Vehicle',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    titleCtrl = TextEditingController(text: widget.initialTitle);
    descCtrl = TextEditingController(text: widget.initialDescription);
    priceCtrl = TextEditingController(text: widget.initialPrice);
    vendorCtrl = TextEditingController(text: widget.initialVendorName);
    selectedCategory = widget.initialCategory;
  }

  @override
  void dispose() {
    titleCtrl.dispose();
    descCtrl.dispose();
    priceCtrl.dispose();
    vendorCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isEdit ? 'Edit Ad' : 'Create Ad'),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _field(
                controller: titleCtrl,
                label: 'Title',
                icon: Icons.title,
              ),
              SizedBox(height: 12.h),
              _field(
                controller: descCtrl,
                label: 'Description',
                icon: Icons.description_outlined,
                maxLines: 3,
              ),
              SizedBox(height: 12.h),
              _field(
                controller: priceCtrl,
                label: 'Price (৳)',
                icon: Icons.attach_money,
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Required';
                  if (double.tryParse(v) == null) return 'Enter a valid number';
                  return null;
                },
              ),
              SizedBox(height: 12.h),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Category',
                  prefixIcon: const Icon(Icons.category_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                items: categories.map((c) {
                  return DropdownMenuItem(value: c, child: Text(c));
                }).toList(),
                onChanged: (v) {
                  if (v != null) setState(() => selectedCategory = v);
                },
              ),
              SizedBox(height: 12.h),
              _field(
                controller: vendorCtrl,
                label: 'Vendor / Store Name',
                icon: Icons.store_outlined,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(widget.isEdit ? 'Update' : 'Create'),
        ),
      ],
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
      validator: validator ??
          (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
    );
  }

  void _submit() async {
    if (!formKey.currentState!.validate()) return;
    await widget.onSave(
      titleCtrl.text.trim(),
      descCtrl.text.trim(),
      double.parse(priceCtrl.text.trim()),
      selectedCategory,
      vendorCtrl.text.trim(),
    );
    if (mounted) Navigator.pop(context);
  }
}
