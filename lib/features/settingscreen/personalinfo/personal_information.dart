import 'package:e_commerce_full_project/features/settingscreen/personalinfo/widgets/Editable_field.dart';
import 'package:e_commerce_full_project/features/settingscreen/personalinfo/widgets/edit_save_button.dart';
import 'package:e_commerce_full_project/features/settingscreen/personalinfo/widgets/image_and_name_widget.dart';
import 'package:e_commerce_full_project/features/settingscreen/personalinfo/widgets/info_tile.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({super.key});
  @override
  State<PersonalInformationScreen> createState() =>
      _PersonalInformationScreenState();
}
class _PersonalInformationScreenState
extends State<PersonalInformationScreen> {
  bool isEditing = false;
  final TextEditingController emailController = TextEditingController(
    text: 'example@email.com',
  );
  final TextEditingController phoneController = TextEditingController(
    text: '+20 100 000 0000',
  );
  final TextEditingController addressController = TextEditingController(
    text: 'Cairo, Egypt',
  );
  @override
  void dispose() {
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  } 
  void changeEditing() {
  setState(() {
    isEditing = true;
  });
} 
  void _saveInformation() {
    FocusScope.of(context).unfocus();
    setState(() {
      isEditing = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'personal_information.updated_successfully'.tr(),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'personal_information.title'.tr(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
             SizedBox(height: 20.h),
            ImageAndNameWidget(), 
            if (isEditing) ...[
             EditableField(controller: emailController, icon: Icons.email_outlined, label: 'personal_information.email'.tr(), keyboardType: TextInputType.emailAddress),
             EditableField(controller:phoneController , icon: Icons.phone_outlined, label: 'personal_information.phone_number'.tr(), keyboardType: TextInputType.phone),  
             EditableField(controller: addressController, icon: Icons.location_on_outlined, label: 'personal_information.address'.tr(), keyboardType: TextInputType.streetAddress),
              const SizedBox(height: 10),
              EditSaveButton(textForButton: 'personal_information.save_changes'.tr(), onPressed: _saveInformation)
            ] else ...[ 
              InfoTile(icon: Icons.email_outlined, title: 'personal_information.email'.tr(), value: emailController.text), 
              InfoTile(icon: Icons.phone_outlined, title: 'personal_information.phone_number'.tr(), value: phoneController.text), 
              InfoTile(icon: Icons.location_on_outlined, title: 'personal_information.address'.tr(), value: addressController.text),               
              const SizedBox(height: 10),
              EditSaveButton(textForButton:'personal_information.edit_information'.tr(), onPressed: changeEditing)
            ],
          ],
        ),
      ),
    );
   }
  }