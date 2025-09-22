import 'package:get/get.dart';
import 'package:loneliness/src/routes/app_routes.dart';

class StartingController extends GetxController
{

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    Future.delayed(Duration(seconds: 3),(){

      Get.toNamed(AppRoutes.onBoardingScreen);

    });
  }

}