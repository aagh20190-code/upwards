import 'package:flutter/material.dart';
import 'package:upwards2/common/colo_extension.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
              "Hey there",
              style: TextStyle(color: TColor.grey,
              fontSize: 18),
              ),

              Text(
              "Hey there",
              style: TextStyle(color: TColor.black,
              fontSize: 18,
              fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: media.width*0.5,
              ),
              Container(
                decoration: BoxDecoration(color: TColor.lightGrey,borderRadius: BorderRadius.circular(15)),
                child:TextField(decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15,vertical: 4),
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintText: "First Name",
                  prefixIcon: Image.asset("assets/img/profile.png",width: 15,),
                  hintStyle: TextStyle(color: TColor.grey,fontSize: 12),
                ),),
              )
            ],
          ),
        ),
      ),
    );
  }
}