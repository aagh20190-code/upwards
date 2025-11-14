import 'package:flutter/material.dart';
import 'package:upwards2/common/colo_extension.dart';
import 'package:upwards2/common_widget/round_button.dart';
import 'package:upwards2/common_widget/round_textfield.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                "Hey there",
                style: TextStyle(color: TColor.grey,
                fontSize: 18),
                ),
            
                Text(
                "Create an Account",
                style: TextStyle(color: TColor.black,
                fontSize: 18,
                fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: media.width*0.05,
                ),
               const RoundTextFeild(
                hintText: "First Name",
                icon: "assets/img/user.png"),

                 SizedBox(
                  height: media.width*0.04,
                ),

                 const RoundTextFeild(
                hintText: "Last Name",
                icon: "assets/img/user.png"),

                 SizedBox(
                  height: media.width*0.04,
                ),

                 const RoundTextFeild(
                hintText: "Email",
                icon: "assets/img/Message.png",
                keyboardType: TextInputType.emailAddress,
                ),

                 SizedBox(
                  height: media.width*0.04,
                ),

                RoundTextFeild(
                hintText: "Password",
                icon: "assets/img/Lock.png",
                obscureText: true,
                rightIcon: TextButton(onPressed: (){}, child: Container(
                    width: 20,
                    height: 20,
                    alignment: Alignment.center,
                  child: Image.asset(
                   "assets/img/hidepass.png",
                    height: 20,
                    width: 20,
                    fit: BoxFit.contain,
                    color: TColor.grey,))),
                ),
                Row(
                  //crossAxisAlignment: CrossAxisAlignment.baseline,
                  children: [
                    IconButton(onPressed: (){
                      setState(() {
                        isChecked = !isChecked;
                      });
                    },
                    icon: Icon(
                     isChecked?Icons.check_box_outlined: Icons.check_box_outline_blank_outlined,
                    color: TColor.grey,
                    size: 20,)
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Expanded(child: Text(
                                      "By continuing you accept our Privacy Policy and\nTerm of Use",
                                      style: TextStyle(color: TColor.grey,
                                      fontSize: 10),
                                      ),
                                      ),
                    )
                
                ],
                ),
                 SizedBox(
                  height: media.width*0.4,
                ),
                
                RoundButton(title: "Register", onPressed: (){},),

                SizedBox(
                  height: media.width*0.04,
                ),

                Row(
                  //crossAxisAlignment: CrossAxisAlignment.baseline,
                  children: [
                    Expanded(
                        child: Container(
                          height: 1,
                          color: TColor.grey.withOpacity(0.5),)),
                    Text(
                      "  Or  ",
                      style: TextStyle(color: TColor.black, fontSize: 12),
                    ),
                    Expanded(
                        child: Container(
                          height: 1,
                          color: TColor.grey.withOpacity(0.5),)),
                  ],
                ),
                SizedBox(
                  height: media.width*0.04,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  GestureDetector(onTap: (){},
                  child: Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                   color: TColor.white,
                   border: Border.all(width: 1,
                  color: TColor.grey.withOpacity(0.4),
                 ),
                  borderRadius: BorderRadius.circular(15),),
                  child: Image.asset("assets/img/google.png",
                  width: 20,
                  height: 20,) 
                 ,)
                 ,),
                 SizedBox(
                  width: media.width*0.04,
                ),

                 GestureDetector(onTap: (){},
                  child: Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                   color: TColor.white,
                   border: Border.all(width: 1,
                  color: TColor.grey.withOpacity(0.4),
                 ),
                  borderRadius: BorderRadius.circular(15),),
                  child: Image.asset("assets/img/facebook.png",
                  width: 20,
                  height: 20,) 
                 ,)
                 ,)
                ],),
                SizedBox(
                  height: media.width*0.04,
                ),
                
                TextButton(onPressed: (){}, child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                  Text(
                    "Already have an account? ",
                style: TextStyle(color: TColor.black,fontSize: 14),
                ),
                 Text(
                    "Login",
                style: TextStyle(color: TColor.black,fontSize: 14,fontWeight: FontWeight.w700),
                )
                ],) ,),

                SizedBox(
                  height: media.width*0.04,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}