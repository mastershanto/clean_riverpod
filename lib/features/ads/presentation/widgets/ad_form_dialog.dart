import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

/// Form dialog for creating or editing an ad — now with image uploading.
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
    this.initialImages = const [],
  });

  final bool isEdit;
  final String initialTitle;
  final String initialDescription;
  final String initialPrice;
  final String initialCategory;
  final String initialVendorName;

  /// Existing image paths/URLs (for editing).
  final List<String> initialImages;
  final Future<void> Function(
    String title,
    String description,
    double price,
    String category,
    String vendorName,
    List<String> imagePaths,
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
  final _picker = ImagePicker();

  /// Currently selected image paths (local files or existing URLs).
  late final List<String> _imagePaths;

  static const categories = [
    'Electronics',
    'Fashion',
    'Furniture',
    'Food',
    'Vehicle',
    'Other',
  ];

  static const int _maxImages = 5;

  @override
  void initState() {
    super.initState();
    titleCtrl = TextEditingController(text: widget.initialTitle);
    descCtrl = TextEditingController(text: widget.initialDescription);
    priceCtrl = TextEditingController(text: widget.initialPrice);
    vendorCtrl = TextEditingController(text: widget.initialVendorName);
    selectedCategory = widget.initialCategory;
    _imagePaths = List.from(widget.initialImages);
  }

  @override
  void dispose() {
    titleCtrl.dispose();
    descCtrl.dispose();
    priceCtrl.dispose();
    vendorCtrl.dispose();
    super.dispose();
  }

  // ── Image picking ─────────────────────────────────────────────────

  Future<void> _pickFromGallery() async {
    final remaining = _maxImages - _imagePaths.length;
    if (remaining <= 0) {
      _showMaxImagesSnackbar();
      return;
    }
    final picked = await _picker.pickMultiImage(
      imageQuality: 80,
      maxWidth: 1200,
      maxHeight: 1200,
    );
    if (picked.isNotEmpty) {
      setState(() {
        _imagePaths.addAll(
          picked.take(remaining).map((f) => f.path),
        );
      });
    }
  }

  Future<void> _pickFromCamera() async {
    if (_imagePaths.length >= _maxImages) {
      _showMaxImagesSnackbar();
      return;
    }
    final picked = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
      maxWidth: 1200,
      maxHeight: 1200,
    );
    if (picked != null) {
      setState(() => _imagePaths.add(picked.path));
    }
  }

  void _removeImage(int index) {
    setState(() => _imagePaths.removeAt(index));
  }

  void _showMaxImagesSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Maximum $_maxImages images allowed'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(widget.isEdit ? 'Edit Ad' : 'Create Ad'),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Image Section ───────────────────────────────────
                Text(
                  'Photos (${_imagePaths.length}/$_maxImages)',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 8.h),
                _buildImageGrid(theme),
                SizedBox(height: 16.h),

                // ── Text Fields ─────────────────────────────────────
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
                    if (double.tryParse(v) == null) {
                      return 'Enter a valid number';
                    }
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

  // ── Image grid with add buttons ───────────────────────────────────

  Widget _buildImageGrid(ThemeData theme) {
    return SizedBox(
      height: 100.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          // Existing images
          ..._imagePaths.asMap().entries.map((entry) {
            return _buildImageTile(entry.key, entry.value, theme);
          }),

          // Add buttons (if room remains)
          if (_imagePaths.length < _maxImages) ...[
            _buildAddButton(
              icon: Icons.photo_library_outlined,
              label: 'Gallery',
              onTap: _pickFromGallery,
              theme: theme,
            ),
            SizedBox(width: 8.w),
            _buildAddButton(
              icon: Icons.camera_alt_outlined,
              label: 'Camera',
              onTap: _pickFromCamera,
              theme: theme,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildImageTile(int index, String path, ThemeData theme) {
    final isFile = path.startsWith('/') || path.startsWith('file://');
    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: SizedBox(
              width: 100.w,
              height: 100.h,
              child: isFile
                  ? Image.file(File(path), fit: BoxFit.cover)
                  : Image.network(path,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                            color: theme.colorScheme.surfaceContainerHighest,
                            child: const Icon(Icons.broken_image_outlined),
                          )),
            ),
          ),
          // Remove button
          Positioned(
            top: 2.h,
            right: 2.w,
            child: GestureDetector(
              onTap: () => _removeImage(index),
              child: Container(
                padding: EdgeInsets.all(2.w),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close, size: 14.sp, color: Colors.white),
              ),
            ),
          ),
          // Index badge
          if (index == 0)
            Positioned(
              bottom: 4.h,
              left: 4.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  'Cover',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAddButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100.w,
        height: 100.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: theme.colorScheme.primary.withValues(alpha: 0.4),
            width: 1.5,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
          color: theme.colorScheme.primaryContainer.withValues(alpha: 0.2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28.sp, color: theme.colorScheme.primary),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Text field helper ─────────────────────────────────────────────

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
      List.unmodifiable(_imagePaths),
    );
  }
}
