import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditSaveButton extends StatefulWidget { 
    final VoidCallback onPressed; 
    final String? textForButton; 
  const EditSaveButton({super.key , required this.textForButton   , required this.onPressed});
  @override
  State<EditSaveButton> createState() => _EditSaveButtonState();
}

class _EditSaveButtonState extends State<EditSaveButton> { 
  @override
  Widget build(BuildContext context) {
    return SizedBox(
    width: double.infinity,
    height: 52,
    child: ElevatedButton(
      onPressed: widget.onPressed,
      child: Text(
       widget.textForButton??  'personal_information.edit_information'.tr(),
        style:  TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
  }
}