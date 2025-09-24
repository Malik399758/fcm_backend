import 'package:flutter/material.dart';

class FamilyNavView extends StatelessWidget {
  const FamilyNavView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    return Scaffold(
      body: SafeArea(child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth*.05),
          child: Column(children: [
            
          ],),
        ),
      )),
    );
  }
}
