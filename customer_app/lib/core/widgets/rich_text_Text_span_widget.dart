import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RichTextTextSpanWidget extends StatefulWidget { 
  final String? richText ; 
  final String? clickableText; 
  final TapGestureRecognizer? recognizer; 
  const RichTextTextSpanWidget({ 
    this.richText, 
    this.clickableText, 
    this.recognizer, 
    super.key});

  @override
  State<RichTextTextSpanWidget> createState() => _RichTextTextSpanWidgetState();
}

class _RichTextTextSpanWidgetState extends State<RichTextTextSpanWidget> {
  @override
  Widget build(BuildContext context) { 
    final theme =Theme.of(context); 
    final colorScheme = Theme.of(context).colorScheme ; 
    return Center(
     child: RichText(
       textAlign: TextAlign.center,
       text: TextSpan(
         text: widget.richText ?? "dont_have_account".tr(),
         style: theme.textTheme.bodyMedium!.copyWith(
           color: colorScheme.onSurfaceVariant,
           fontSize: 13.sp,
           fontWeight: FontWeight.w400,
         ),
         children: [
           TextSpan(
             text:widget.clickableText ??  "sign_up".tr(),
             style: theme.textTheme.bodyMedium!.copyWith(
               color: colorScheme.primary,
               fontSize: 13.sp,
               fontWeight: FontWeight.w600,
             ),
             recognizer: widget.recognizer,
           ),
         ],
       ),
     ),
   );
  }
}