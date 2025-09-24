import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loneliness/src/components/app_colors_images/app_colors.dart';
import 'package:loneliness/src/components/app_colors_images/app_images.dart';
import 'package:loneliness/src/components/common_widget/black_text.dart';
import 'package:loneliness/src/components/common_widget/custom_back_button.dart';
import 'package:loneliness/src/components/common_widget/green_button.dart';
import 'package:loneliness/src/screen/bottom_nav_screens/settings_nav_screens/reminder_controller.dart';
import 'package:table_calendar/table_calendar.dart';

class ReminderCalendarScreen extends StatelessWidget {
  const ReminderCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ReminderController controller = Get.find<ReminderController>();
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            CustomBackButton(),
            Spacer(),
            BlackText(
              text: 'Memory Cycles',
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
            Spacer(),
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.05),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Color(0xffE9E9E9)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const BlackText(
                              text: 'Select Date',
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(height: screenHeight * 0.006),
                            Row(
                              children: [
                                Expanded(
                                  child: Obx(() {
                                    final DateTime? sel =
                                        controller.selectedDates.isNotEmpty
                                            ? controller.selectedDates.last
                                            : controller.selectedDay.value ??
                                                controller.focusedDay.value;
                                    return BlackText(
                                      text: _formatLong(sel),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 32,
                                      textAlign: TextAlign.left,
                                    );
                                  }),
                                ),
                                SvgPicture.asset(AppImages.edit,width: screenWidth*.06,),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Obx(
                        () => TableCalendar(
                          firstDay: DateTime.utc(2010, 1, 1),
                          lastDay: DateTime.utc(2035, 12, 31),
                          focusedDay: controller.focusedDay.value,
                          selectedDayPredicate:
                              (d) => controller.selectedDates.any(
                                (x) => isSameDay(x, d),
                              ),
                          onDaySelected:
                              (d, f) => controller.onDaySelected(d, f),
                          headerStyle: const HeaderStyle(
                            formatButtonVisible: false,
                            titleCentered: true,
                          ),
                          calendarStyle: CalendarStyle(
                            todayDecoration: BoxDecoration(
                              color: AppColors.greenColor.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            selectedDecoration: BoxDecoration(
                              color: AppColors.greenColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          availableGestures: AvailableGestures.horizontalSwipe,
                        ),
                      ),
                      Padding(
                        padding:  EdgeInsets.symmetric(
                          horizontal: screenWidth*.05,
                          vertical: screenHeight*.015,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            BlackText(text: 'Cancel', onTap: () => Get.back()),
                             SizedBox(width: screenWidth*.05),
                            BlackText(text: 'Ok', onTap: () => Get.back()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                const BlackText(
                  text: 'Select Date',
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: screenHeight * 0.01),
                Obx(() {
                  return Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children:
                        controller.selectedDates
                            .map((d) => _DateChip(label: _fmt(d)))
                            .toList(),
                  );
                }),
                SizedBox(height: screenHeight * 0.05),
                GreenButton(text: 'Save Memory Cycle', onTap: controller.save),
                SizedBox(height: screenHeight * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String _fmt(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final yy = d.year.toString();
    return '$dd / $mm / $yy';
  }

  static String _formatLong(DateTime? d) {
    if (d == null) return '';
    // Example: Wed, Sep 14
    const List<String> weekdays = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];
    const List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final String wd = weekdays[(d.weekday + 6) % 7];
    final String m = months[d.month - 1];
    return '$wd, $m ${d.day}';
  }
}

class _DateChip extends StatelessWidget {
  final String label;
  const _DateChip({required this.label});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * .02,
        vertical: screenHeight * .012,
      ),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xffE9E9E9)),
      ),
      child: BlackText(text: label, fontSize: 12, fontWeight: FontWeight.w500),
    );
  }
}
