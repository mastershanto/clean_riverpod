import 'package:flutter/material.dart';

class _FormField extends StatelessWidget {
  const _FormField({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      validator:
          validator ??
          (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
    );
  }
}

class UserFormDialog extends StatefulWidget {
  const UserFormDialog({
    super.key,
    required this.initialName,
    required this.initialEmail,
    required this.initialPhone,
    required this.initialAddress,
    required this.isEdit,
    required this.onSave,
  });

  final String initialName;
  final String initialEmail;
  final String initialPhone;
  final String initialAddress;
  final bool isEdit;
  final Function(String name, String email, String phone, String address)
  onSave;

  @override
  State<UserFormDialog> createState() => _UserFormDialogState();
}

class _UserFormDialogState extends State<UserFormDialog> {
  late final TextEditingController nameCtrl;
  late final TextEditingController emailCtrl;
  late final TextEditingController phoneCtrl;
  late final TextEditingController addressCtrl;
  late final GlobalKey<FormState> formKey;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.initialName);
    emailCtrl = TextEditingController(text: widget.initialEmail);
    phoneCtrl = TextEditingController(text: widget.initialPhone);
    addressCtrl = TextEditingController(text: widget.initialAddress);
    formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    addressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isEdit ? 'Edit User' : 'Add User'),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _FormField(
                controller: nameCtrl,
                label: 'Name',
                icon: Icons.person,
              ),
              const SizedBox(height: 12),
              _FormField(
                controller: emailCtrl,
                label: 'Email',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Required';
                  if (!v.contains('@')) return 'Enter a valid email';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              _FormField(
                controller: phoneCtrl,
                label: 'Phone',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              _FormField(
                controller: addressCtrl,
                label: 'Address',
                icon: Icons.location_on,
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
          onPressed: () {
            if (!formKey.currentState!.validate()) return;
            widget.onSave(
              nameCtrl.text.trim(),
              emailCtrl.text.trim(),
              phoneCtrl.text.trim(),
              addressCtrl.text.trim(),
            );
            Navigator.pop(context);
          },
          child: Text(widget.isEdit ? 'Update' : 'Add'),
        ),
      ],
    );
  }
}
