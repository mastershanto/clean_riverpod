import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DeleteAdDialog extends StatelessWidget {
  const DeleteAdDialog({
    super.key,
    required this.adTitle,
    required this.onConfirm,
  });

  final String adTitle;
  final Future<void> Function() onConfirm;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Ad'),
      content: Text(
        'Are you sure you want to delete "$adTitle"?',
        style: TextStyle(fontSize: 14.sp),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
          onPressed: () async {
            await onConfirm();
          },
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
