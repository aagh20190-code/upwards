import 'package:flutter/material.dart';
import 'package:upwards2/common/colo_extension.dart';

class StartedView extends StatefulWidget {
  const StartedView({super.key});

  @override
  State<StartedView> createState() => _StartedViewState();
}

class _StartedViewState extends State<StartedView> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColor.white,
      body: Container(
        width: media.width,
        decoration: BoxDecoration(gradient: LinearGradient(
          colors: TColor.primaryGrad,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
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

                     MaterialButton(onPressed: (){

                     }, child: Text("Get Started",style:  TextStyle(
                  color:TColor.grey,
                   fontSize: 16,
                   fontWeight: FontWeight.w700
                   )),)   

              ],)
            ],
          ),
      ),
    );
  }
}