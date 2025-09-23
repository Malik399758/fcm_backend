import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:loneliness/src/components/app_colors_images/app_colors.dart';
import 'package:loneliness/src/components/app_colors_images/app_images.dart';
import 'package:loneliness/src/components/common_widget/black_text.dart';
import 'package:loneliness/src/components/common_widget/text_field_widget.dart';
import 'package:loneliness/src/screen/bottom_nav_screens/home_nav_screens/home_nav_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  List<Map<String, String>> users = [
    {"name": "Jane Cooper", "msg": "Good Morning James!", "time": "2 m ago"},
    {"name": "Alice Smith", "msg": "How are you?", "time": "5 m ago"},
    {"name": "Bob Johnson", "msg": "Let's meet up.", "time": "10 m ago"},
    {"name": "Charlie Brown", "msg": "Good luck!", "time": "15 m ago"},
    {"name": "Arslan", "msg": "Good luck!", "time": "15 m ago"},
    {"name": "Farhan", "msg": "Good luck!", "time": "15 m ago"},
    {"name": "Furqan", "msg": "Good luck!", "time": "15 m ago"},
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final HomeNavController homeNavController = Get.put(HomeNavController());
    final TextEditingController searchController = TextEditingController();

    List<Widget> cardWidgets = [];
    for (int index = 0; index < users.length; index++) {
      var user = users[index];
      bool isSelected = selectedIndex == index;
      cardWidgets.add(
        GestureDetector(
          onTap: () {
            setState(() {
              selectedIndex = index;
            });
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
                          BlackText(
                            text: user["name"]!,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            textColor: isSelected ? Colors.black : AppColors.greyColor,
                          ),
                          BlackText(
                            text: user["time"]!,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            textColor: AppColors.greyColor,
                          ),
                        ],
                      ),
                      BlackText(
                        text: user["msg"]!,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
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
      if (index < users.length - 1) {
      }
    }

    return Scaffold(
      body: SafeArea(
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
                        bottom: 0, right: 0, child: Image.asset(AppImages.lines)),
                    Padding(
                      padding: EdgeInsets.all(screenWidth * .06),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              BlackText(
                                text: "hi, Arslan 👋 ",
                                textColor: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
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
                                        onPressed: () {},
                                        icon: SvgPicture.asset(AppImages.bell),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: screenWidth * .017,
                                    top: screenHeight * .007,
                                    child: Container(
                                      padding: EdgeInsets.all(screenWidth * .013),
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
                                  controller: searchController,
                                  hintText: "Search",
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.all(screenWidth * .02),
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
                                    onPressed: () {},
                                    icon: SvgPicture.asset(
                                      AppImages.filter,
                                      width: screenWidth * .07,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(screenWidth * .04),
                child: Column(
                  children: cardWidgets,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}