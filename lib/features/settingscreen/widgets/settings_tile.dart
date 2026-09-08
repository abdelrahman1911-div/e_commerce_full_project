import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class SettingsTile extends StatelessWidget { 
  final IconData icon;  
  final String title; 
  final String subtitle; 
  final GestureTapCallback onTap; 
  const SettingsTile({super.key , required this.icon , required this.title , required this.subtitle , required this.onTap });
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
        ),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
        leading: Container(
          width: 42.w,
          height: 42.h,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(.08),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(icon, color: theme.colorScheme.primary),
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 11.sp, color: Colors.grey),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 15.sp,
          color: Colors.grey,
        ),
      ),
    );
  }
} 
