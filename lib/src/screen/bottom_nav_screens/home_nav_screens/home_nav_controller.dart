import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum SortType { newest, senderAZ, oldest }

class HomeNavController extends GetxController {
  // Reactive state
  final RxInt selectedIndex = (-1).obs;
  final RxInt selectedNotificationIndex = (-1).obs;
  final RxBool isFilterOpen = false.obs;
  final RxBool isSearchSuggestionsOpen = false.obs;

  // Controllers
  final TextEditingController searchController = TextEditingController();

  // Data
  final List<Map<String, String>> allUsers = [
    {"name": "Jane Cooper", "msg": "Good Morning James!", "time": "2 m ago"},
    {"name": "Alice Smith", "msg": "How are you?", "time": "5 m ago"},
    {"name": "Bob Johnson", "msg": "Let's meet up.", "time": "10 m ago"},
    {"name": "Charlie Brown", "msg": "Good luck!", "time": "15 m ago"},
    {"name": "Arslan", "msg": "Good luck!", "time": "20 m ago"},
    {"name": "Farhan", "msg": "Good luck!", "time": "25 m ago"},
    {"name": "Furqan", "msg": "Good luck!", "time": "30 m ago"},
  ];

  // Visible filtered/sorted list
  final RxList<Map<String, String>> visibleUsers = <Map<String, String>>[].obs;
  final Rx<SortType> sortType = SortType.newest.obs;
  final RxList<String> suggestions = <String>[].obs;

  @override
  void onInit() {
    visibleUsers.assignAll(List<Map<String, String>>.from(allUsers));
    searchController.addListener(() {
      _applyQuery(searchController.text.trim());
    });
    super.onInit();
  }

  void onCardTap(int index) {
    selectedIndex.value = index;
  }

  void setSort(SortType type) {
    sortType.value = type;
    _applyQuery(searchController.text.trim());
  }

  void _applyQuery(String query) {
    final String lowered = query.toLowerCase();
    List<Map<String, String>> base = List<Map<String, String>>.from(allUsers);
    if (lowered.isNotEmpty) {
      base =
          base
              .where(
                (u) =>
                    (u['name'] ?? '').toLowerCase().contains(lowered) ||
                    (u['msg'] ?? '').toLowerCase().contains(lowered),
              )
              .toList();
      // suggestions
      final List<String> nameMatches =
          allUsers
              .map((e) => e['name'] ?? '')
              .where((n) => n.toLowerCase().contains(lowered))
              .toSet()
              .toList();
      suggestions.assignAll(nameMatches.take(6));
      isSearchSuggestionsOpen.value = true;
      isFilterOpen.value = false;
    } else {
      suggestions.clear();
      isSearchSuggestionsOpen.value = false;
    }
    visibleUsers.assignAll(_applySort(base));
  }

  List<Map<String, String>> _applySort(List<Map<String, String>> list) {
    switch (sortType.value) {
      case SortType.senderAZ:
        list.sort((a, b) => (a['name'] ?? '').compareTo(b['name'] ?? ''));
        return list;
      case SortType.oldest:
        return list.reversed.toList();
      case SortType.newest:
        return list;
    }
  }

  void toggleFilter() {
    isFilterOpen.value = !isFilterOpen.value;
    if (isFilterOpen.value) {
      isSearchSuggestionsOpen.value = false;
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  void closeOverlays() {
    isFilterOpen.value = false;
    isSearchSuggestionsOpen.value = false;
  }

  void selectSuggestion(String value) {
    searchController.text = value;
    searchController.selection = TextSelection.fromPosition(
      TextPosition(offset: value.length),
    );
    _applyQuery(value);
    isSearchSuggestionsOpen.value = false;
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
