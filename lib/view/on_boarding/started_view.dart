import 'package:flutter/material.dart';
import 'package:upwards2/common/colo_extension.dart';
import 'package:upwards2/common_widget/round_button.dart';
import 'package:upwards2/view/on_boarding/on_boarding_view.dart';

class StartedView extends StatefulWidget {
  const StartedView({super.key});

  @override
  State<StartedView> createState() => _StartedViewState();
}

class _StartedViewState extends State<StartedView> {
 bool  isChangeColor =false ;
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColor.white,
      body: Container(
        width: media.width,
        decoration: BoxDecoration(
          gradient: isChangeColor ?  LinearGradient(
          colors: TColor.primaryGrad,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight): null,
          ),
          child: 
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                Text("Upwards",
                style: TextStyle(
                  color:TColor.black,
                   fontSize: 36,
                     fontWeight:FontWeight.w800),),

                     Text("Track your life progress",
                style: TextStyle(
                  color:TColor.grey,
                   fontSize: 18
                   ),
                   )
                   ,const Spacer(),

                     SafeArea(
                       child: Padding(
                         padding: const EdgeInsets.symmetric(horizontal: 20),
                         child: RoundButton
                         (title: "Get Started",
                         type: isChangeColor ? RoundButtonType.textGradient: RoundButtonType.bgGradient ,
                          onPressed: () {
                            if(isChangeColor)
                            {
                              //go to next screen
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> const OnBoardingView()));
                            } 
                            else {
                              setState(() {
                                isChangeColor = true;
                              });
                            }
                          }),
                     ) ,
                     )  
              ],
              )),
      );
    
  }
}