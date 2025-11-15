import 'package:flutter/material.dart';
import 'package:upwards2/common/colo_extension.dart';
import 'package:upwards2/common_widget/round_button.dart';
import 'package:upwards2/common_widget/round_textfield.dart';
import 'package:upwards2/view/login/completeProfileView.dart';
import 'package:upwards2/view/login/signup_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            height: media.height*0.9,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                "Hey there",
                style: TextStyle(color: TColor.grey,
                fontSize: 16),
                ),
            
                Text(
                "Welcome Back",
                style: TextStyle(color: TColor.black,
                fontSize: 18,
                fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: media.width*0.05,
                ),

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
                rightIcon: TextButton(
                  onPressed: (){},
                child:
                Container(
                    alignment: Alignment.center,
                    width: 20,
                    height: 20,
                  child: Image.asset(
                   "assets/img/hidepass.png",
                    height: 20,
                    width: 20,
                    fit: BoxFit.contain,
                    color: TColor.grey,))),
                ),
                  SizedBox(
                    height: media.width*0.02,),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                    Text(
                           "Forgot Password?",
                            style: TextStyle(
                              color: TColor.grey,
                            fontSize: 10,
                            decoration: TextDecoration.underline),
                          ),
                          ],
                          ),
                 const Spacer(),
                
                RoundButton(
                  title: "Login",
                  onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                      const Completeprofileview()));
                }),

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
                          color: TColor.grey.withOpacity(0.5),
                          )),
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
                   border: Border.all(
                    width: 1,
                    color: TColor.grey.withOpacity(0.4),
                 ),
                  borderRadius: BorderRadius.circular(15),
                  ),
                  child: Image.asset("assets/img/google.png",
                  width: 20,
                  height: 20,
                  ),
                  ),
                  ),
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
                  borderRadius: BorderRadius.circular(15),
                  
                  ),
                  child: Image.asset("assets/img/facebook.png",
                  width: 20,
                  height: 20,
                  ),
                  ),
                 )
                ],
              ),
                SizedBox(
                  height: media.width*0.04,
                ),
                
                TextButton(onPressed: (){
                  Navigator.pop(context);
                }, 

                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                  Text(
                    "Don't have an account Yet? ",
                 style: TextStyle(
                  color: TColor.black,
                  fontSize: 14),
                ),

                 Text(
                    "Register",
                style: TextStyle(color: TColor.black,fontSize: 14,fontWeight: FontWeight.w700),
                )
                ],
                ),
                ),

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