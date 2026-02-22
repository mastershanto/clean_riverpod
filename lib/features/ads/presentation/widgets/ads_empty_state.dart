import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdsEmptyState extends StatelessWidget {
  const AdsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.campaign_outlined, size: 72.sp, color: Colors.grey),
          SizedBox(height: 16.h),
          Text(
            'No ads yet.\nTap + to create your first ad.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 16.sp),
          ),
        ],
      ),
    );
  }
}
