
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loneliness/src/components/app_colors_images/app_colors.dart';
import 'package:loneliness/src/components/common_widget/black_text.dart';


class GreenButton extends StatelessWidget {
  VoidCallback onTap;
  String text;
  double? height;
  double? width;
  double? fontSize;
  double? borderRadius;
  String? image;
  Color? color;
  String? fontFamily;
  Color? imagecolor;
  Color? borderColor;
  Color? textColor;
  FontWeight fontWeight;

  GreenButton({
    super.key,
    required this.onTap,
    required this.text,
    this.height,
    this.width,
    this.fontSize,
    this.color ,
    this.imagecolor,
    this.borderColor,
    this.fontFamily,
    this.textColor ,
    this.fontWeight = FontWeight.w500,
    this.image,
    this.borderRadius
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? double.infinity,
        height: height ??screenHeight*.06,
        decoration: BoxDecoration(
          color: color ?? AppColors.greenColor,
          border: Border.all(color: borderColor ?? Colors.transparent,width: 2),
          borderRadius: BorderRadius.circular(borderRadius ?? 10),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (image != null)
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: SvgPicture.asset(image!,color: imagecolor ?? Colors.transparent,width: screenWidth*.05,),
                ),
              BlackText(
                text: text,
                textColor: textColor ?? Colors.white,
                fontSize: fontSize ?? 16,
                fontWeight: FontWeight.w700,
                fontFamily: fontFamily,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
