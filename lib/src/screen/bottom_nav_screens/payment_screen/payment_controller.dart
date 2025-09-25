import 'package:get/get.dart';

class PaymentController extends GetxController {
  final RxString selectedPaymentMethod = ''.obs;

  void selectPaymentMethod(String methodName) {
    selectedPaymentMethod.value = methodName;
  }

  bool isSelected(String methodName) {
    return selectedPaymentMethod.value == methodName;
  }
}
