import 'package:flutter/material.dart';
import 'package:upwards2/common/colo_extension.dart';

class Blankview extends StatefulWidget {
  const Blankview({super.key});

  @override
  State<Blankview> createState() => _BlankviewState();
}

class _BlankviewState extends State<Blankview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
      
      body:Center( child: Text("PAGE IS UNDER DEVELOPMENT\nPLEASE WAIT!",style: TextStyle(color: TColor.grey,fontWeight: FontWeight.w700,fontSize: 18),),)
    );
  }
}