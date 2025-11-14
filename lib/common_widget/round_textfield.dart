import 'package:flutter/material.dart';
import 'package:upwards2/common/colo_extension.dart';

class RoundTextfield extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final String icon;
  
  const RoundTextfield({super.key, this.controller, required this.hintText, required this.icon });

  @override
  Widget build(BuildContext context) {
    return  Container(
                decoration: BoxDecoration(color: TColor.lightGrey,borderRadius: BorderRadius.circular(15)),
                child:TextField(decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintText: "First Name",
                  prefixIcon: Container(
                    width: 15,
                    height: 15,
                    alignment: Alignment.center,
                  child: Image.asset(
                    "assets/img/user.png",
                    height: 15,
                    width: 15,
                    fit: BoxFit.contain,
                    color: TColor.grey,)),
                  hintStyle: TextStyle(color: TColor.grey,fontSize: 14),
                ),
                ),
                );
                }
}