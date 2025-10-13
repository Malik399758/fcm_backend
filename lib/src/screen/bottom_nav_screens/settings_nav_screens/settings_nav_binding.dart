
import 'package:get/get.dart';
import 'settings_nav_controller.dart';

class SettingsNavBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SettingsNavController());
  }
}
