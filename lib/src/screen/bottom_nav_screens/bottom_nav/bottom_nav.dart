import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loneliness/src/screen/bottom_nav_screens/family_nav_screens/family_nav_view.dart';
import 'package:loneliness/src/screen/bottom_nav_screens/home_nav_screens/home_screen.dart';
import 'package:loneliness/src/screen/bottom_nav_screens/record_nav_screens/voice_record.dart';

import '../../../components/app_colors_images/app_colors.dart';
import '../../../components/app_colors_images/app_images.dart';
import '../../../components/common_widget/black_text.dart';

class BottomNavController extends GetxController {
  final RxInt currentIndex = 0.obs;

  void changeIndex(int index) {
    currentIndex.value = index;
  }
}

class BottomNaV extends StatelessWidget {
  final List<Widget>? pages;

  const BottomNaV({super.key, this.pages});

  // List of screens
  List<Widget> get _screens => [
    HomeScreen(),
    VoiceRecordScreen(),
    FamilyNavView(),
    Center(child: BlackText(text: "4")),
  ];

  List<_NavItem> get _items => [
    _NavItem(label: 'Messages', assetPath: AppImages.home),
    _NavItem(label: 'Record', assetPath: AppImages.record),
    _NavItem(label: 'Family', assetPath: AppImages.family),
    _NavItem(label: 'Setting', assetPath: AppImages.settings),
  ];

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    final controller = Get.put(BottomNavController());
    final screens = pages ?? _screens;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: screens,
        ),
      ),
      bottomNavigationBar: _BottomBar(items: _items, controller: controller),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final List<_NavItem> items;
  final BottomNavController controller;

  const _BottomBar({required this.items, required this.controller});

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Responsive.width(20)),
            topRight: Radius.circular(Responsive.width(20)),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        padding: EdgeInsets.fromLTRB(
          Responsive.width(12),
          0,
          Responsive.width(12),
          0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (int i = 0; i < items.length; i++)
              Obx(
                () => _BottomBarItem(
                  item: items[i],
                  selected: i == controller.currentIndex.value,
                  onTap: () => controller.changeIndex(i),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _BottomBarItem extends StatelessWidget {
  final _NavItem item;
  final bool selected;
  final VoidCallback onTap;

  const _BottomBarItem({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    final Color iconColor =
        selected ? AppColors.greenColor : AppColors.greyColor;
    final Color textColor =
        selected ? AppColors.greenColor : AppColors.greyColor;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Responsive.width(12)),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: Responsive.height(6)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: Responsive.height(40),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    if (selected)
                      Positioned(
                        top: Responsive.height(-8),
                        child: _Teardrop(size: Responsive.width(16)),
                      ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SvgPicture.asset(
                        item.assetPath,
                        width: Responsive.width(22),
                        height: Responsive.height(22),
                        colorFilter: ColorFilter.mode(
                          iconColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: Responsive.height(4)),
              BlackText(
                text: item.label,
                fontSize: Responsive.fontSize(12),
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                textColor: textColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Teardrop extends StatelessWidget {
  final double size;
  const _Teardrop({required this.size});

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return CustomPaint(
      size: Size(Responsive.width(size), Responsive.height(size)),
      painter: _TeardropPainter(
        color: AppColors.greenColor,
        borderColor: AppColors.greenColor,
      ),
    );
  }
}

class _TeardropPainter extends CustomPainter {
  final Color color;
  final Color borderColor;

  _TeardropPainter({required this.color, required this.borderColor});

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2;
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    // Create semi-circle path (bottom half of circle)
    final Path semiCircle =
        Path()..addArc(
          Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
          0, // Start from 0 degrees
          3.14159, // Sweep π (180 degrees) to complete semi-circle
        );

    final Paint fill = Paint()..color = AppColors.greenColor;
    final Paint stroke =
        Paint()
          ..color = AppColors.greenColor.withOpacity(0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2;

    canvas.drawPath(semiCircle, fill);
    canvas.drawPath(semiCircle, stroke);
  }

  @override
  bool shouldRepaint(covariant _TeardropPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.borderColor != borderColor;
  }
}

class _NavItem {
  final String label;
  final String assetPath;

  const _NavItem({required this.label, required this.assetPath});
}
