import 'package:get/get.dart';

class ReminderController extends GetxController {
  final RxInt selectedPresetIndex = 0.obs; // 0:30d, 1:60d, 2:custom

  final Rx<DateTime> focusedDay = DateTime.now().obs;
  final Rxn<DateTime> selectedDay = Rxn<DateTime>();

  // Extra selected dates list for multi-select example (as per mock)
  final RxList<DateTime> selectedDates = <DateTime>[].obs;

  void selectPreset(int index) {
    selectedPresetIndex.value = index;
  }

  void onDaySelected(DateTime day, DateTime focus) {
    selectedDay.value = day;
    focusedDay.value = focus;
    final bool exists = selectedDates.any(
      (d) => d.year == day.year && d.month == day.month && d.day == day.day,
    );
    if (exists) {
      selectedDates.removeWhere(
        (d) => d.year == day.year && d.month == day.month && d.day == day.day,
      );
    } else {
      selectedDates.add(day);
    }
  }

  void clearSelections() {
    selectedDay.value = null;
    selectedDates.clear();
  }

  void save() {
    Get.back();
    Get.snackbar('Reminder', 'Memory cycle saved');
  }
}
