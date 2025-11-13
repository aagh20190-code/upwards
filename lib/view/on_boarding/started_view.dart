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
                Text("Upwards",
                style: TextStyle(
                  color:TColor.black,
                   fontSize: 36,
                     fontWeight:FontWeight.w800),)
              ],)
            ],
          ),
      ),
    );
  }
}