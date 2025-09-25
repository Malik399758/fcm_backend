import 'package:get/get.dart';

class PaymentController extends GetxController {
  final RxString selectedPaymentMethod = ''.obs;
  final RxBool saveCard = false.obs;

  void selectPaymentMethod(String methodName) {
    selectedPaymentMethod.value = methodName;
  }

  bool isSelected(String methodName) {
    return selectedPaymentMethod.value == methodName;
  }

  void toggleSaveCard() {
    saveCard.toggle();
  }
}
