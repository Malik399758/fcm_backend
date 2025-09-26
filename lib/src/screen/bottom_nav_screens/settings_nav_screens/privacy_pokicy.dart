import 'package:flutter/material.dart';
import 'package:loneliness/src/components/common_widget/black_text.dart';
import 'package:loneliness/src/components/common_widget/custom_back_button.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.transparent,
        title: Row(
          children: [
            const CustomBackButton(),
            const Spacer(),
            const BlackText(
              text: 'Privacy Policy',
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
            const Spacer(),
          ],
        ),
      ),
      body: SafeArea(child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth*.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            SizedBox(height: screenHeight*.03),

          ],),
        ),
      )),
    );
  }
}
