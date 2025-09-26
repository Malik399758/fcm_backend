import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:loneliness/src/components/app_colors_images/app_colors.dart';
import 'package:loneliness/src/components/app_colors_images/app_images.dart';
import 'package:loneliness/src/components/common_widget/black_text.dart';
import 'package:loneliness/src/components/common_widget/custom_back_button.dart';
import 'package:loneliness/src/screen/bottom_nav_screens/settings_nav_screens/settings_nav_controller.dart';

class HelpAndSupport extends StatelessWidget {
  const HelpAndSupport({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsNavController controller =
        Get.put(SettingsNavController(), permanent: false);

    final Size size = MediaQuery.sizeOf(context);
    final double horizontal = size.width * 0.05; // 5% horizontal padding
    final double cardRadius = 12;

    final List<Map<String, String>> faqItems = [
      {
        'q': 'Lorem ipsum dolor sit amet, consectetur',
        'a':
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et.'
      },
      {
        'q': 'How can I reset my password?',
        'a':
            'Go to Settings > Security > Reset Password and follow the on-screen steps.'
      },
      {
        'q': 'How to contact support?',
        'a': 'Use the Contact Us tab to reach Customer Service or WhatsApp.'
      },
      {
        'q': 'Can I change reminder frequency?',
        'a': 'Yes, visit Settings > Reminder Frequency to update presets.'
      },
      {
        'q': 'Is my data private?',
        'a': 'Please review our Privacy Policy in Settings for details.'
      },
      {
        'q': 'How do I edit my profile?',
        'a': 'Navigate to Profile Information from Settings to make updates.'
      },
    ];

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.whiteColor,
          title:  Row(
            children: [
              const CustomBackButton(),
              const Spacer(),
              const BlackText(
                text: 'Help Center',
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              const Spacer(),
            ],
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(48),
            child: Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: horizontal),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
              ),
              child: TabBar(
                isScrollable: false,
                labelPadding: EdgeInsets.symmetric(horizontal: 20),
                labelColor: AppColors.greenColor,
                unselectedLabelColor: AppColors.greyColor,
                indicatorColor: AppColors.greenColor,
                labelStyle: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),
                tabs: const [
                  Tab(text: 'FAQ'),
                  Tab(text: 'Contact Us'),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            //==================== FAQ TAB ====================
            ListView.separated(
              padding: EdgeInsets.symmetric(
                horizontal: horizontal,
                vertical: size.height * 0.02,
              ),
              itemBuilder: (context, index) {
                final item = faqItems[index];
                return _CardExpansion(
                  title: item['q'] ?? '',
                  content: item['a'] ?? '',
                  radius: cardRadius,
                );
              },
              separatorBuilder: (_, __) => SizedBox(height: size.height * 0.012),
              itemCount: faqItems.length,
            ),

            //==================== CONTACT US TAB ====================
            ListView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontal,
                vertical: size.height * 0.02,
              ),
              children: [
                _ContactExpansion(
                  iconPath: AppImages.customerService,
                  title: 'Customer Service',
                  radius: cardRadius,
                  children: const [],
                ),
                SizedBox(height: size.height * 0.012),
                _ContactExpansion(
                  iconPath: AppImages.whatsapp,
                  title: 'WhatsApp',
                  radius: cardRadius,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppColors.greenColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: BlackText(
                            text: '(000) 000-0000',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            textColor: AppColors.greyColor,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CardExpansion extends StatelessWidget {
  final String title;
  final String content;
  final double radius;

  const _CardExpansion({
    required this.title,
    required this.content,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: Color(0xffE9E9E9)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: AppColors.transparentColor),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          iconColor: AppColors.greenColor,
          collapsedIconColor: AppColors.greenColor,
          title: BlackText(
            text: title,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            textColor: AppColors.blackColor,
            textAlign: TextAlign.left,
          ),
          children: [
            BlackText(
              text: content,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              textColor: AppColors.greyColor,
              textAlign: TextAlign.left,
              maxLines: 10,
              overflow: TextOverflow.visible,
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactExpansion extends StatelessWidget {
  final String iconPath;
  final String title;
  final double radius;
  final List<Widget> children;

  const _ContactExpansion({
    required this.iconPath,
    required this.title,
    required this.radius,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: Color(0xffE9E9E9)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: AppColors.transparentColor),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          iconColor: AppColors.greenColor,
          collapsedIconColor: AppColors.greenColor,
          leading: SvgPicture.asset(iconPath, width: 22, height: 22),
          title: BlackText(
            text: title,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            textColor: AppColors.blackColor,
            textAlign: TextAlign.left,
          ),
          children: children,
        ),
      ),
    );
  }
}
