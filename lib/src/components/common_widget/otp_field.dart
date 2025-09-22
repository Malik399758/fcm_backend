import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loneliness/src/components/app_colors_images/app_colors.dart';

class OtpTextformfield extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;

  OtpTextformfield({
    super.key,
    required this.controller,
    this.focusNode,
    this.onNext,
    this.onPrevious,
  });

  @override
  State<OtpTextformfield> createState() => _OtpTextformfieldState();
}

class _OtpTextformfieldState extends State<OtpTextformfield> {
  @override
  void initState() {
    super.initState();
    widget.focusNode?.addListener(_handleFocus);
  }

  @override
  void didUpdateWidget(covariant OtpTextformfield oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      oldWidget.focusNode?.removeListener(_handleFocus);
      widget.focusNode?.addListener(_handleFocus);
    }
  }

  void _handleFocus() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    widget.focusNode?.removeListener(_handleFocus);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    final bool isFocused = widget.focusNode?.hasFocus ?? false;

    return Container(
      width: width * .15,
      child: TextFormField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 24,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          counterText: '',
          border: InputBorder.none,
          filled: true,
          hintText: '-',
          fillColor: AppColors.lightGrey,
          hintStyle: TextStyle(color: Colors.grey, fontSize: 24, fontWeight: FontWeight.w600),
          //fillColor: isFocused ? AppColors.greenColor : Colors.black.withOpacity(.03),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppColors.greenColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.transparent),
          ),
        ),
        onChanged: (value) {
          if (value.length == 1) {
            widget.onNext?.call();
          } else if (value.isEmpty) {
            widget.onPrevious?.call();
          }
        },
      ),
    );
  }
}