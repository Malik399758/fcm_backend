import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../models/group_model.dart';
import '../../../services/firebase_db_service/group_service.dart';

class FamilyNavController extends GetxController {
  final GroupService _groupService = GroupService();

  RxBool isLoading = false.obs;

  Future<void> createGroup(String name, List<String> memberIds) async {
    try {
      isLoading.value = true;
      final group = GroupModel(
        id: '', // Firestore will generate it
        name: name,
        members: memberIds,
        createdBy: FirebaseAuth.instance.currentUser!.uid,
        createdAt: DateTime.now(),
      );

      await _groupService.createGroup(group);
      Get.snackbar("Success", "Group created successfully");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
