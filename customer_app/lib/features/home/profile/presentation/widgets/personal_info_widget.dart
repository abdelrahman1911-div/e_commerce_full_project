import 'package:e_commerce_full_project/core/styling/app_text_styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PersonalInfoWidget extends StatelessWidget {
  final String? personal_name;
  final String? personal_job;
  final String? person_image;
  const PersonalInfoWidget({
    super.key,
    this.person_image,
    this.personal_name,
    this.personal_job,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.h),
          Row(
            children: [
        ClipOval(
  child: person_image != null && person_image!.isNotEmpty
      ? Image.network(
          person_image!,
          width: 60.r,
          height: 60.r,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            debugPrint('FACEBOOK IMAGE ERROR: $error');

            return Container(
              width: 60.r,
              height: 60.r,
              color: Colors.grey.shade300,
              child: Icon(
                Icons.person,
                size: 30.r,
                color: Colors.grey.shade600,
              ),
            );
          },
        )
      : Container(
          width: 60.r,
          height: 60.r,
          color: Colors.grey.shade300,
          child: Icon(
            Icons.person,
            size: 30.r,
            color: Colors.grey.shade600,
          ),
        ),
),
              SizedBox(width: 15.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    personal_name ?? 'samyha_ayoub'.tr(),
                    style: AppTextStyles.headline(
                      context,
                    ).copyWith(fontSize: 17.sp, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    personal_job ?? 'mobile_app_developer'.tr(),
                    style: AppTextStyles.subheadline(context),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
