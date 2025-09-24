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
