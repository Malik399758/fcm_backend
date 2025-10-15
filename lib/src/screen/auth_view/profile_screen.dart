
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loneliness/src/components/app_colors_images/app_colors.dart';
import 'package:loneliness/src/components/app_colors_images/app_images.dart';
import 'package:loneliness/src/components/common_widget/black_text.dart';
import 'package:loneliness/src/components/common_widget/custom_back_button.dart';
import 'package:loneliness/src/components/common_widget/green_button.dart';
import 'package:loneliness/src/components/common_widget/text_field_widget.dart';
import 'package:loneliness/src/routes/app_routes.dart';
import 'package:loneliness/src/screen/auth_view/auth_controller.dart';
import 'package:loneliness/src/screen/bottom_nav_screens/bottom_nav/bottom_nav.dart';
import 'package:loneliness/src/screen/bottom_nav_screens/settings_nav_screens/settings_nav_controller.dart';
import 'package:loneliness/src/services/firebase_db_service/profile_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final SettingsNavController controller = Get.find<SettingsNavController>();
  final AuthController authController = Get.put(AuthController());
  final profileService = ProfileService();
  bool loading = false;
  static const success = 'success';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final args = Get.arguments;
    if(args != null){
      final name = args['name'] ?? '';
      final email = args['email'] ?? '';
      final uid = args['uid'] ?? '';

      controller.nameController.text = name;
      controller.emailController.text = email;

    }
  }

  // save
  Future<void> profileSave()async{
    setState(() => loading = true);
    final result =  await profileService.saveProfile(
        controller.nameController.text.trim(),
        controller.phoneController.text.trim(),
        controller.emailController.text.trim(),
        controller.dobController.text,
        controller.selectedGender.string);

    if(result == success){
      Get.snackbar(
        'Success',
        'Profile Saved',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.offAll(() => BottomNaV());
    }else{
      Get.snackbar(
        'Error',
        result ?? 'Profile created failed',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.transparent,
        title: Row(
          children: [
            const CustomBackButton(),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.02),

              Center(child: Text('Complete Your Profile',style: GoogleFonts.inter(fontSize: 24,fontWeight: FontWeight.w500),)),
              SizedBox(height: screenHeight * 0.01),
              Center(child: Text("Don’t worry, only you can see your personal data. No one else will be able to see it.",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(fontSize: 12,fontWeight: FontWeight.w400,
                    color: Colors.grey),
              )),
              SizedBox(height: screenHeight * 0.04),

              // Avatar + edit badge
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Obx(() {
                      final avatar = controller.avatarFile.value;
                      return CircleAvatar(
                        radius: screenWidth * 0.16,
                        backgroundColor: AppColors.lightGrey,
                        backgroundImage:
                        avatar != null ? Image.file(avatar).image : null,
                      );
                    }),
                    GestureDetector(
                      onTap: () => _showAvatarSheet(context, controller),
                      child: Container(
                        width: screenWidth * 0.1,
                        height: screenWidth * 0.1,
                        decoration: BoxDecoration(
                          color: AppColors.greenColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.whiteColor,
                            width: 3,
                          ),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            AppImages.edit2,
                            width: screenWidth * 0.05,
                            color: AppColors.whiteColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.03),

              const BlackText(
                text: 'Name',
                textAlign: TextAlign.left,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(height: screenHeight * 0.008),
              TextFieldWidget(
                controller: controller.nameController,
                hintText: 'Name',
              ),

              SizedBox(height: screenHeight * 0.02),
              const BlackText(
                text: 'Phone Number',
                textAlign: TextAlign.left,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(height: screenHeight * 0.008),
              TextFieldWidget(
                controller: controller.phoneController,
                hintText: '0000000',
                keyboardType: TextInputType.phone,
              ),

              SizedBox(height: screenHeight * 0.02),
              const BlackText(
                text: 'Email',
                textAlign: TextAlign.left,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(height: screenHeight * 0.008),
              TextFieldWidget(
                controller: controller.emailController,
                hintText: 'example@gmail.com',
                keyboardType: TextInputType.emailAddress,
              ),

              SizedBox(height: screenHeight * 0.02),
              const BlackText(
                text: 'DOB',
                textAlign: TextAlign.left,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(height: screenHeight * 0.008),
            /*  TextFieldWidget(
                controller: controller.dobController,
                hintText: 'DD/MM/YY',
                keyboardType: TextInputType.datetime,
              ),*/
              DOBPicker(controller: controller.dobController),

              SizedBox(height: screenHeight * 0.02),
              const BlackText(
                text: 'Gender',
                textAlign: TextAlign.left,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(height: screenHeight * 0.008),
              _GenderDropdown(controller: controller),

              SizedBox(height: screenHeight * 0.04),
              GreenButton(text: loading ? 'Saving...' : 'Complete Profile', onTap: profileSave),
              SizedBox(height: screenHeight * 0.02),
            ],
          ),
        ),
      ),
    );
  }

  void _showAvatarSheet(
      BuildContext context,
      SettingsNavController controller,
      ) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    Get.bottomSheet(
      SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: screenHeight*.02,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: screenWidth*.3,
                height: screenHeight*.006,
                decoration: BoxDecoration(
                  color: Color(0xffD5D7D7),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              SizedBox(height: screenHeight*.015,),
              const BlackText(
                text: 'Change Avatar',
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
              SizedBox(height: screenHeight*.015,),
              _AvatarActionTile(
                icon: AppImages.camera,
                title: 'Take photo',
                onTap: () {
                  Get.back();
                  controller.takePhoto();
                },
              ),
              SizedBox(height: screenHeight*.015,),
              _AvatarActionTile(
                icon: AppImages.gallery,
                title: 'From Gallery',
                onTap: () {
                  Get.back();
                  controller.pickFromGallery();
                },
              ),
              SizedBox(height: screenHeight*.015,),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}

class _GenderDropdown extends StatelessWidget {
  final SettingsNavController controller;
  const _GenderDropdown({required this.controller});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Obx(() {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.lightGrey,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.lightGrey),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            dropdownColor: AppColors.whiteColor,

            value:
            controller.selectedGender.value.isEmpty
                ? null
                : controller.selectedGender.value,
            hint: const BlackText(text: 'Select', fontSize: 14),
            isExpanded: true,
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.greenColor,
              size: screenWidth * 0.08,
            ),
            items: const [
              DropdownMenuItem(value: 'Male', child: Text('Male')),
              DropdownMenuItem(value: 'Female', child: Text('Female')),
              DropdownMenuItem(value: 'Other', child: Text('Other')),
            ],
            onChanged: (value) {
              if (value != null) controller.setGender(value);
            },
          ),
        ),
      );
    });
  }
}

class _AvatarActionTile extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback onTap;
  const _AvatarActionTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding:  EdgeInsets.symmetric(vertical: screenHeight*.03, horizontal: screenWidth*.03),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.greenColor.withOpacity(.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: screenWidth*.08,
              backgroundColor: AppColors.greenColor.withOpacity(.2),
              child: SvgPicture.asset(
                icon,
                width: screenWidth * 0.08,
                color: AppColors.greenColor,
              ),
            ),
            SizedBox(height: screenHeight*.015),
            BlackText(
              text: title,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              textColor: AppColors.blackColor,
            ),
          ],
        ),
      ),
    );
  }
}



class DOBPicker extends StatelessWidget {
  final TextEditingController controller;

  const DOBPicker({required this.controller});

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      String formattedDate = DateFormat('dd/MM/yy').format(picked);
      controller.text = formattedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldWidget(
      controller: controller,
      hintText: 'DD/MM/YY',
      suffixIcon: Icon(Icons.calendar_today),
      readOnly: true,
      onTap: () => _selectDate(context),
    );
  }
}

