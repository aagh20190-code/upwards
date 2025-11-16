import 'package:flutter/material.dart';
import 'package:upwards2/common/colo_extension.dart';
import 'package:upwards2/common_widget/round_button.dart';
import 'package:upwards2/view/main_tab/main_tab_view.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColor.white,
      body: SafeArea(
        child: Container(
          width: media.width,
          padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                  height: media.width*0.05,
                ),

              
              Image.asset("assets/img/sign5.png",
              width: media.width*0.8,
              fit: BoxFit.fitWidth,

              ),
              SizedBox(
                  height: media.width*0.2,
                ),

                Text(
                "Welcome, Sami",
                style: TextStyle(color: TColor.black,
                fontSize: 24,
                fontWeight: FontWeight.w700),
                ),

                Text(
                "You are all set now. Let’s\nreach your goals together with us",
                textAlign: TextAlign.center,
                style: TextStyle(color: TColor.grey,
                fontSize: 16),
                ),
                const Spacer(),

                RoundButton(title: "Go To Home", 
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) =>const MainTabView(),));
                      },),

            ],
          ),
          ),
      ),
    );
  }
}