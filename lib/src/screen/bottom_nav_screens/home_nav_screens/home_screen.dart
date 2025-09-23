import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loneliness/src/components/app_colors_images/app_colors.dart';
import 'package:loneliness/src/components/app_colors_images/app_images.dart';
import 'package:loneliness/src/components/common_widget/black_text.dart';
import 'package:loneliness/src/components/common_widget/text_field_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final TextEditingController searchController = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: screenWidth,
                height: screenHeight * .3,
                padding: EdgeInsets.all(screenWidth * .05),
                decoration: BoxDecoration(
                  color: AppColors.greenColor,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                ),
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
                              right: screenWidth*.017,
                              top: screenHeight*.007,
                              child: Container(
                                padding: EdgeInsets.all(screenWidth*.013),
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
                    SizedBox(height: screenHeight*.01),
                    BlackText(
                      text: "Let’s start learning!",
                      textColor: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 17,
                    ),
                    SizedBox(height: screenHeight*.05),
                    Row(children: [
                      Expanded(child:
                      TextFieldWidget(
                          controller: searchController,
                          hintText: "Search",
                          prefixIcon: Padding(
                            padding:  EdgeInsets.all(screenWidth*.02),
                            child: SvgPicture.asset(AppImages.search),
                          ),
                      )),
                      SizedBox(width: screenWidth*.03),
                      Container(
                        height: screenHeight*.064,
                        width: screenWidth*.13,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(child: IconButton(onPressed: (){}, icon: SvgPicture.asset(AppImages.filter,width: screenWidth*.07,))
                       ),
                      )
                    ],)
                  ],
                ),
              ),
              SizedBox(height: screenHeight*.03),

            ],
          ),
        ),
      ),
    );
  }
}