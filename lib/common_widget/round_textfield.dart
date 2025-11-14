import 'package:flutter/material.dart';
import 'package:upwards2/common/colo_extension.dart';

class RoundTextFeild extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? rightIcon;
  final String hintText;
  final String icon;
  final EdgeInsets? margin;
  const RoundTextFeild({super.key, this.controller, required this.hintText, required this.icon, this.margin, this.keyboardType,this.obscureText=false,this.rightIcon});

  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: margin,
                decoration: BoxDecoration(
                  color: TColor.lightGrey,
                  borderRadius: BorderRadius.circular(15)),
                child:TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  obscureText: obscureText,
                  decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintText: hintText,
                  suffixIcon: rightIcon,
                  prefixIcon: Container(
                    width: 20,
                    height: 20,
                    alignment: Alignment.center,
                  child: Image.asset(
                    icon,
                    height: 20,
                    width: 20,
                    fit: BoxFit.contain,
                    color: TColor.grey,)),
                  hintStyle: TextStyle(color: TColor.grey,fontSize: 14),
                ),
                ),
                );
                }
}