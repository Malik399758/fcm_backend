import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:loneliness/src/components/app_colors_images/app_colors.dart';
import 'package:loneliness/src/components/app_colors_images/app_images.dart';
import 'package:loneliness/src/components/common_widget/black_text.dart';
import 'package:loneliness/src/components/common_widget/custom_back_button.dart'
    show CustomBackButton;
import 'package:loneliness/src/components/common_widget/green_button.dart';
import 'package:loneliness/src/routes/app_routes.dart';

class ManageSubscription extends StatelessWidget {
  const ManageSubscription({super.key});

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
            const Spacer(),
            const BlackText(
              text: 'Subscription & Payments',
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
            const Spacer(),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.02),
              const _TrialBannerCard(),
              SizedBox(height: screenHeight * 0.02),
              const _AnnualSubscriptionCard(),
              SizedBox(height: screenHeight * 0.02),
              const _MembershipRenewalCard(),
              SizedBox(height: screenHeight * 0.03),
            ],
          ),
        ),
      ),
    );
  }
}

//==================== TRIAL CARD ====================
class _TrialBannerCard extends StatelessWidget {
  const _TrialBannerCard();

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * 0.02,
        horizontal: screenWidth * 0.04,
      ),
      decoration: BoxDecoration(
        color: AppColors.greenColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: screenWidth * 0.08,
            backgroundImage: AssetImage(AppImages.user1),
          ),
          SizedBox(height: screenHeight * 0.012),
          const BlackText(
            text: 'Start Your 7 - Day Free\nTrial!',
            fontWeight: FontWeight.w600,
            fontSize: 16,
            textAlign: TextAlign.center,
            textColor: Colors.white,
          ),
          SizedBox(height: screenHeight * 0.008),
          const BlackText(
            text:
                'Experience Family Connect Premium With\nUnlimited Messages And Full Features. Cancel\nAnytime.',
            fontWeight: FontWeight.w500,
            fontSize: 12,
            textAlign: TextAlign.center,
            textColor: Colors.white,
          ),
          SizedBox(height: screenHeight * 0.014),
          GreenButton(
            text: 'Unlock Premium Access',
            color: AppColors.whiteColor,
            textColor: AppColors.greenColor,
            borderRadius: 8,
            onTap: () {
              Get.toNamed(AppRoutes.paymentMethodScreen);
            },
          ),
        ],
      ),
    );
  }
}

//==================== PLAN CARD ====================
class _AnnualSubscriptionCard extends StatelessWidget {
  const _AnnualSubscriptionCard();

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * 0.02,
        horizontal: screenWidth * 0.04,
      ),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xffE9E9E9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: CircleAvatar(
              radius: screenWidth * 0.09,
              backgroundColor: AppColors.greenColor.withOpacity(0.15),
              child: SvgPicture.asset(AppImages.flash,width: screenWidth*.09,),
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          const BlackText(
            text: 'Annual Subscription',
            fontWeight: FontWeight.w600,
            fontSize: 20,
            textAlign: TextAlign.left,
          ),
          SizedBox(height: screenHeight * 0.006),
          BlackText(
            text: 'Invest in lasting family connections.',
            fontWeight: FontWeight.w600,
            fontSize: 12,
            textAlign: TextAlign.left,
            textColor:AppColors.greyColor,
          ),
          SizedBox(height: screenHeight * 0.02),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlackText(
                text: '\$4100',
                fontWeight: FontWeight.w700,
                fontSize: 36,
                textColor: Color(0xFF34B5A6),
                textAlign: TextAlign.left,
              ),
              SizedBox(width: 4),
              BlackText(
                text: '/year',
                fontWeight: FontWeight.w600,
                fontSize: 36,
                textColor: Color(0xFF34B5A6),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.012),
          const _FeatureRow(text: 'Unlimited video & voice messages'),
          const _FeatureRow(
            text: 'Custom memory cycles for preserving memories',
          ),
          const _FeatureRow(text: 'Priority customer support'),
          const _FeatureRow(text: 'Early access to new features'),
          const SizedBox(height: 4),
          const BlackText(
            text: 'Select Annual Plan',
            fontWeight: FontWeight.w400,
            fontSize: 12,
            textAlign: TextAlign.left,
            textColor: Color(0xFF6B7280),
          ),
          SizedBox(height: screenHeight * 0.014),
          GreenButton(
            text: 'Select Annual Plan',
            onTap: () {},
            height: screenHeight * 0.05,
            width: screenWidth,
            borderRadius: 8,
          ),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final String text;
  const _FeatureRow({required this.text});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(bottom: screenHeight * 0.01),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset('assets/Checkicon.svg',width: screenWidth*.05,),
         SizedBox(width: screenWidth*.03),
          Expanded(
            child: BlackText(
              text: text,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              textAlign: TextAlign.left,
              textColor: AppColors.greyColor,
            ),
          ),
        ],
      ),
    );
  }
}

//==================== RENEWAL CARD ====================
class _MembershipRenewalCard extends StatelessWidget {
  const _MembershipRenewalCard();

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: screenHeight * 0.02,
        horizontal: screenWidth * 0.04,
      ),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xffE9E9E9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BlackText(
            text: 'Membership Renewal',
            fontWeight: FontWeight.w600,
            fontSize: 20,
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 6),
           BlackText(
            text: 'Your current premium plan renews on\nNovember 15, 2025',
            fontWeight: FontWeight.w600,
            fontSize: 12,
            textAlign: TextAlign.left,
            textColor: AppColors.greyColor,
          ),
          SizedBox(height: screenHeight * 0.016),
          Row(
            children: [
               BlackText(
                text: 'Status:',
                fontWeight: FontWeight.w400,
                fontSize: 16,
                textColor: AppColors.greyColor,
              ),
              SizedBox(width: screenWidth * 0.02),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.005,
                  horizontal: screenWidth * 0.03,
                ),
                decoration: BoxDecoration(
                  color: AppColors.greenColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: BlackText(
                  text: 'Active',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  textColor: AppColors.whiteColor,
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.016),
          GreenButton(
            text: 'Cancel Subscription',
            onTap: () {},
            height: screenHeight * 0.05,
            width: screenWidth,
            borderColor: AppColors.greenColor,
            color: AppColors.transparentColor,
            textColor: AppColors.greenColor,
            borderRadius: 8,
          ),
        ],
      ),
    );
  }
}
