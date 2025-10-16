import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:loneliness/src/components/app_colors_images/app_colors.dart';
import 'package:loneliness/src/components/app_colors_images/app_images.dart';
import 'package:loneliness/src/components/common_widget/black_text.dart';
import 'package:loneliness/src/components/common_widget/text_field_widget.dart';
import 'package:loneliness/src/routes/app_routes.dart';
import 'package:loneliness/src/screen/bottom_nav_screens/home_nav_screens/home_nav_controller.dart';
import 'package:loneliness/src/screen/bottom_nav_screens/home_nav_screens/chat_screen.dart';
import 'package:loneliness/src/services/firebase_db_service/profile_service.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../controllers/backend_controller/name_controller.dart';
import '../../../models/profile_model.dart';
import '../../../services/firebase_db_service/message_service.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<NameProvider>(context, listen: false).startListening();
    final args = Get.arguments;

    if (args == null || args['uid'] == null) {
      // Handle null case: show error, navigate back, or provide fallback
      print('Invalid chat details. Please go back and try again.');
    } else {
      final receiverId = args['uid'];
      ChatService().markMessagesAsRead(receiverId);
      // Use receiverId safely
    }


  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final HomeNavController homeNavController = Get.put(HomeNavController());

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => homeNavController.closeOverlays(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: screenWidth,
                  decoration: BoxDecoration(
                    color: AppColors.greenColor,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Image.asset(AppImages.lines),
                      ),
                      Padding(
                        padding: EdgeInsets.all(screenWidth * .06),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Consumer<NameProvider>(
                                  builder: (context, nameProvider, _) {
                                    if (nameProvider.name.isEmpty) {
                                      // Show shimmer when loading
                                      return Shimmer.fromColors(
                                        baseColor: Colors.grey.shade300,
                                        highlightColor: Colors.grey.shade100,
                                        child: Container(
                                          width: 200,
                                          height: 24,
                                          color: Colors.grey[300],
                                        ),
                                      );
                                    } else {
                                      // Show actual text when loaded
                                      return BlackText(
                                        text: "Hi, ${nameProvider.name} 👋",
                                        textColor: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                      );
                                    }
                                  },
                                ),
                                Stack(
                                  children: [
                                    Container(
                                      height: screenHeight * .043,
                                      width: screenWidth * .1,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(.25),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Center(
                                        child: IconButton(
                                          onPressed: () {
                                            Get.toNamed(
                                              AppRoutes.notificationScreen,
                                            );
                                          },
                                          icon: SvgPicture.asset(
                                            AppImages.bell,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: screenWidth * .017,
                                      top: screenHeight * .007,
                                      child: Container(
                                        padding: EdgeInsets.all(
                                          screenWidth * .013,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight * .01),
                            BlackText(
                              text: "Let’s start learning!",
                              textColor: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 17,
                            ),
                            SizedBox(height: screenHeight * .05),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFieldWidget(
                                    controller:
                                        homeNavController.searchController,
                                    hintText: "Search",
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.all(
                                        screenWidth * .02,
                                      ),
                                      child: SvgPicture.asset(AppImages.search),
                                    ),
                                  ),
                                ),
                                SizedBox(width: screenWidth * .03),
                                Container(
                                  height: screenHeight * .064,
                                  width: screenWidth * .13,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: IconButton(
                                      onPressed: homeNavController.toggleFilter,
                                      icon: SvgPicture.asset(
                                        AppImages.filter,
                                        width: screenWidth * .07,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight * .015),
                            Obx(() {
                              final bool showFilter =
                                  homeNavController.isFilterOpen.value;
                              final bool showSearch =
                                  homeNavController
                                      .isSearchSuggestionsOpen
                                      .value;
                              if (!showFilter && !showSearch)
                                return const SizedBox.shrink();

                              final List<String> items =
                                  showFilter
                                      ? ['Newest', 'Sender', 'Date']
                                      : homeNavController.suggestions;

                              return Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.08),
                                      blurRadius: 20,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * .04,
                                  vertical: screenWidth * .035,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    BlackText(
                                      text:
                                          showFilter
                                              ? 'Filter'
                                              : 'Family Searches',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    SizedBox(height: screenHeight * .012),
                                    if (showSearch && items.isEmpty)
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: screenHeight * .004,
                                        ),
                                        child: BlackText(
                                          text:
                                              'No results found. Try a different search.',
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          textColor: AppColors.greyColor,
                                        ),
                                      ),
                                    ...items.map(
                                      (item) => Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: screenHeight * .005,
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            if (showFilter) {
                                              if (item == 'Newest') {
                                                homeNavController.setSort(
                                                  SortType.newest,
                                                );
                                              } else if (item == 'Sender') {
                                                homeNavController.setSort(
                                                  SortType.senderAZ,
                                                );
                                              } else {
                                                homeNavController.setSort(
                                                  SortType.oldest,
                                                );
                                              }
                                              homeNavController
                                                  .isFilterOpen
                                                  .value = false;
                                            } else {
                                              homeNavController
                                                  .selectSuggestion(item);
                                            }
                                          },
                                          child: Row(
                                            children: [
                                              Container(
                                                height: 8,
                                                width: 8,
                                                decoration: const BoxDecoration(
                                                  color: Color(0xFF7C7C7C),
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              SizedBox(
                                                width: screenWidth * .015,
                                              ),
                                              Flexible(
                                                child: BlackText(
                                                  text: item,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  textColor:
                                                      AppColors.greyColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(screenWidth * .04),
                  child: Obx(() {
                    final bool isSearching =
                        homeNavController.searchController.text
                            .trim()
                            .isNotEmpty;
                    if (homeNavController.visibleUsers.isEmpty) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * .06,
                        ),
                        child: Center(
                          child: BlackText(
                            text:
                                isSearching
                                    ? 'No users found.'
                                    : 'No users to display.',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            textColor: AppColors.greyColor,
                          ),
                        ),
                      );
                    }
                    return buildStream(screenWidth, screenHeight);
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget buildStream(double screenWidth, double screenHeight) {
    final HomeNavController homeNavController = Get.put(HomeNavController());
    final myUid = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder<List<ProfileModel?>>(
      stream: ProfileService().getUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Users not found'));
        } else {
          final users = snapshot.data!;

          return Column(
            children: List.generate(users.length, (index) {
              final user = users[index];
              if (user == null) return const SizedBox.shrink();

              final isSelected = homeNavController.selectedIndex.value == index;

              final chatId = [myUid, user.uid]..sort();
              final combinedChatId = '${chatId[0]}_${chatId[1]}';

              return StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('chats')
                    .doc(combinedChatId)
                    .snapshots(),
                builder: (context, chatSnap) {
                  String lastMessage = 'Start chatting';
                  String time = formatTime(DateTime.now());
                  int unreadCount = 0;

                  if (chatSnap.hasData && chatSnap.data!.exists) {
                    final data = chatSnap.data!.data() as Map<String, dynamic>?;

                    if (data != null) {
                      final rawMessage = (data['lastMessage'] as String?)?.trim();
                      if (rawMessage != null && rawMessage.isNotEmpty) {
                        lastMessage = rawMessage;
                      }

                      final timestamp = (data['lastMessageTime'] as Timestamp?)?.toDate();
                      if (timestamp != null) {
                        time = formatTime(timestamp);
                      } else {
                        time = '';
                      }

                      if (data['unreadCount'] != null && data['unreadCount'] is Map<String, dynamic>) {
                        unreadCount = (data['unreadCount'] as Map<String, dynamic>)[myUid] ?? 0;
                      }
                    }
                  }

                  final isUnread = unreadCount > 0;

                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index == users.length - 1 ? 0 : screenHeight * .005,
                    ),
                    child: GestureDetector(
                      onTap: () async {
                        homeNavController.onCardTap(index);
                        await ChatService().markMessagesAsRead(user.uid);
                        Get.to(
                              () => const ChatScreen(),
                          arguments: {
                            "uid": user.uid,
                            "name": user.name,
                          },
                        );
                      },
                      child: Container(
                        width: screenWidth,
                        padding: EdgeInsets.all(screenWidth * .04),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.lightGreen : Colors.transparent,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: screenWidth * .08,
                              backgroundImage: AssetImage(AppImages.user1),
                            ),
                            SizedBox(width: screenWidth * .03),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          BlackText(
                                            text: user.name,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            textColor: isSelected ? Colors.black : AppColors.greyColor,
                                          ),
                                          if (isUnread)
                                            Container(
                                              margin: const EdgeInsets.only(left: 6),
                                              width: 8,
                                              height: 8,
                                              decoration: const BoxDecoration(
                                                color: Colors.blue,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                        ],
                                      ),
                                      if (time.isNotEmpty)
                                        BlackText(
                                          text: time,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          textColor: AppColors.greyColor,
                                        ),
                                    ],
                                  ),
                                  if (lastMessage.isNotEmpty)
                                    BlackText(
                                      text: lastMessage,
                                      fontSize: 12,
                                      fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textColor: isSelected ? Colors.black : AppColors.greyColor,
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          );
        }
      },
    );
  }

  // Widget buildStream(double screenWidth, double screenHeight) {
  //   final HomeNavController homeNavController = Get.put(HomeNavController());
  //   final myUid = FirebaseAuth.instance.currentUser!.uid;
  //
  //   return StreamBuilder<List<ProfileModel?>>(
  //     stream: ProfileService().getUsers(),
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return const Center(child: CircularProgressIndicator());
  //       } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
  //         return const Center(child: Text('Users not found'));
  //       }
  //
  //       final users = snapshot.data!.whereType<ProfileModel>().toList();
  //
  //       return FutureBuilder<List<Map<String, dynamic>>>(
  //         future: Future.wait(users.map((user) async {
  //           final chatId = [myUid, user.uid]..sort();
  //           final combinedChatId = '${chatId[0]}_${chatId[1]}';
  //           final doc = await FirebaseFirestore.instance.collection('chats').doc(combinedChatId).get();
  //           final data = doc.data();
  //
  //           return {
  //             'user': user,
  //             'chatId': combinedChatId,
  //             'lastMessage': data?['lastMessage'] ?? 'Start chatting',
  //             'lastMessageTime': (data?['lastMessageTime'] as Timestamp?)?.toDate() ?? DateTime.fromMillisecondsSinceEpoch(0),
  //             'unreadCount': (data?['unreadCount'] ?? {})[myUid] ?? 0,
  //           };
  //         }).toList()),
  //         builder: (context, chatSnap) {
  //           if (chatSnap.connectionState == ConnectionState.waiting) {
  //             return const Center(child: CircularProgressIndicator());
  //           }
  //
  //           if (!chatSnap.hasData || chatSnap.data!.isEmpty) {
  //             return const Center(child: Text('No chats found'));
  //           }
  //
  //           // ✅ Sort by lastMessageTime DESC (latest message on top)
  //           final chatData = chatSnap.data!;
  //           chatData.sort((a, b) =>
  //               (b['lastMessageTime'] as DateTime).compareTo(a['lastMessageTime'] as DateTime));
  //
  //           return ListView.builder(
  //             itemCount: chatData.length,
  //             itemBuilder: (context, index) {
  //               final data = chatData[index];
  //               final user = data['user'] as ProfileModel;
  //               final isSelected = homeNavController.selectedIndex.value == index;
  //
  //               final lastMessage = data['lastMessage'];
  //               final time = formatTime(data['lastMessageTime']);
  //               final unreadCount = data['unreadCount'];
  //               final isUnread = unreadCount > 0;
  //
  //               return GestureDetector(
  //                 onTap: () async {
  //                   homeNavController.onCardTap(index);
  //                   await ChatService().markMessagesAsRead(user.uid);
  //                   Get.to(() => const ChatScreen(), arguments: {
  //                     "uid": user.uid,
  //                     "name": user.name,
  //                   });
  //                 },
  //                 child: Container(
  //                   margin: EdgeInsets.only(
  //                     bottom: index == chatData.length - 1 ? 0 : screenHeight * .005,
  //                   ),
  //                   padding: EdgeInsets.all(screenWidth * .04),
  //                   decoration: BoxDecoration(
  //                     color: isSelected ? AppColors.lightGreen : Colors.transparent,
  //                     borderRadius: BorderRadius.circular(15),
  //                   ),
  //                   child: Row(
  //                     children: [
  //                       CircleAvatar(
  //                         radius: screenWidth * .08,
  //                         backgroundImage: AssetImage(AppImages.user1),
  //                       ),
  //                       SizedBox(width: screenWidth * .03),
  //                       Expanded(
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Row(
  //                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                               children: [
  //                                 Row(
  //                                   children: [
  //                                     BlackText(
  //                                       text: user.name,
  //                                       fontSize: 16,
  //                                       fontWeight: FontWeight.w600,
  //                                       textColor: isSelected ? Colors.black : AppColors.greyColor,
  //                                     ),
  //                                     if (isUnread)
  //                                       Container(
  //                                         margin: const EdgeInsets.only(left: 6),
  //                                         width: 8,
  //                                         height: 8,
  //                                         decoration: const BoxDecoration(
  //                                           color: Colors.blue,
  //                                           shape: BoxShape.circle,
  //                                         ),
  //                                       ),
  //                                   ],
  //                                 ),
  //                                 if (time.isNotEmpty)
  //                                   BlackText(
  //                                     text: time,
  //                                     fontSize: 12,
  //                                     fontWeight: FontWeight.w400,
  //                                     textColor: AppColors.greyColor,
  //                                   ),
  //                               ],
  //                             ),
  //                             BlackText(
  //                               text: lastMessage,
  //                               fontSize: 12,
  //                               fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
  //                               maxLines: 1,
  //                               overflow: TextOverflow.ellipsis,
  //                               textColor: isSelected ? Colors.black : AppColors.greyColor,
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               );
  //             },
  //           );
  //         },
  //       );
  //     },
  //   );
  // }






  String formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inDays == 0 && now.day == dateTime.day) {
      return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (diff.inDays == 1 || (diff.inDays == 0 && now.day != dateTime.day)) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return weekdays[dateTime.weekday - 1];
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }





}
