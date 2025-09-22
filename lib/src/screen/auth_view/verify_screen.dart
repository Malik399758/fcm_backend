import 'package:flutter/material.dart';
import 'package:loneliness/src/components/app_colors_images/app_colors.dart';
import 'package:loneliness/src/components/common_widget/black_text.dart';
import 'package:loneliness/src/components/common_widget/otp_field.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final _c1 = TextEditingController();
  final _c2 = TextEditingController();
  final _c3 = TextEditingController();
  final _c4 = TextEditingController();

  final _f1 = FocusNode();
  final _f2 = FocusNode();
  final _f3 = FocusNode();
  final _f4 = FocusNode();

  @override
  void dispose() {
    _c1.dispose(); _c2.dispose(); _c3.dispose(); _c4.dispose();
    _f1.dispose(); _f2.dispose(); _f3.dispose(); _f4.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.sizeOf(context).height;
    final w = MediaQuery.sizeOf(context).width;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: w*.05,right: w*.05, bottom: h*.04),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: h*.05),
                Center(child: BlackText(text: "Verify Code", fontSize: 24, fontWeight: FontWeight.w500,)),
                SizedBox(height: h*.01),

                SizedBox(height: h*.02),
                Center(
                  child: BlackText(
                    text: "Please enter the code we just sent to",
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                  ),
                ),
                Center(
                  child: BlackText(
                    text: "your@gmail.com",
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    textColor: AppColors.greenColor,
                  ),
                ),
                SizedBox(height: h*.04),
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: w*.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OtpTextformfield(
                        controller: _c1,
                        focusNode: _f1,
                        onNext: () => FocusScope.of(context).requestFocus(_f2),
                      ),
                      OtpTextformfield(
                        controller: _c2,
                        focusNode: _f2,
                        onNext: () => FocusScope.of(context).requestFocus(_f3),
                        onPrevious: () => FocusScope.of(context).requestFocus(_f1),
                      ),
                      OtpTextformfield(
                        controller: _c3,
                        focusNode: _f3,
                        onNext: () => FocusScope.of(context).requestFocus(_f4),
                        onPrevious: () => FocusScope.of(context).requestFocus(_f2),
                      ),
                      OtpTextformfield(
                        controller: _c4,
                        focusNode: _f4,
                        onPrevious: () => FocusScope.of(context).requestFocus(_f3),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: h*.04),
                Center(
                  child: BlackText(text: "Didn’t receive OTP?", fontSize: 12, textColor: AppColors.greyColor, fontWeight: FontWeight.w400,),
                ),
                Center(child: BlackText(
                  onTap: (){},
                  text: "Resend",
                  fontSize: 14, textColor: AppColors.blackColor,
                  fontWeight: FontWeight.w600,)),
                SizedBox(height: h*.02),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
