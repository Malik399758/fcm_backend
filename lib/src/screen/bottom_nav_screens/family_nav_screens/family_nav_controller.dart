/*
import 'package:get/get.dart';

class FamilyNavController extends GetxController {
  // Observable list to track selected family members
  final RxSet<int> selectedMembers = <int>{}.obs;

  // Dummy data for family members
  final List<Map<String, String>> familyMembers = [
    {'name': 'Jane Cooper', 'image': 'assets/user1.png'},
    {'name': 'John Doe', 'image': 'assets/user1.png'},
    {'name': 'Kristin Watson', 'image': 'assets/user1.png'},
    {'name': 'Cody Fisher', 'image': 'assets/user1.png'},
    {'name': 'Savannah Nguyen', 'image': 'assets/user1.png'},
  ];

  // Toggle selection of a family member
  void toggleSelection(int index) {
    if (selectedMembers.contains(index)) {
      selectedMembers.remove(index);
    } else {
      selectedMembers.add(index);
    }
  }

  // Check if a member is selected
  bool isSelected(int index) {
    return selectedMembers.contains(index);
  }

  // Check if any member is selected (for Create Now button visibility)
  bool get hasSelection => selectedMembers.isNotEmpty;

  // Get selected count
  int get selectedCount => selectedMembers.length;
}
*/

// controllers/family_nav_controller.dart

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
