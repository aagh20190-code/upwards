
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:upwards2/common/colo_extension.dart';
import 'package:upwards2/common_widget/round_button.dart';

class WhatyourgoalView extends StatefulWidget {
  const WhatyourgoalView({super.key});

  @override
  State<WhatyourgoalView> createState() => _WhatyourgoalViewState();
}

class _WhatyourgoalViewState extends State<WhatyourgoalView> {

  CarouselController buttonCarouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColor.white,
      body: SafeArea(child: 
      Stack(
        children: [
          Center(
            child: CarouselSlider(
              items: ["assets/img/sign1.png","assets/img/sign2.png","assets/img/sign3.png"].map((gObject)=>Container(color: Colors.amber,)).toList(),
              carouselController: buttonCarouselController,
              options: CarouselOptions(
                autoPlay: false,
                enlargeCenterPage: true,
                viewportFraction: 0.9,
                aspectRatio: 0.75,
                initialPage: 0,
              ),
            ),
          ),
        
          Container(
            padding:const EdgeInsets.symmetric(horizontal: 25.0),
            width: media.width,
            child: Column(
              children: [
                 SizedBox(
                    height: media.width*0.05,
                  ),
            
                  Text(
                  "What's Your Goal?",
                  style: TextStyle(color: TColor.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
                  ),
            
                  Text(
                  "It will help us to chose a best\nprogram for you",
                    textAlign: TextAlign.center,
                  style: TextStyle(color: TColor.grey,
                  fontSize: 12),
                  ),
                  const Spacer(),

                  SizedBox(height: media.width*0.05,
                  ),

                  RoundButton(title: "Confirm", 
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) =>const WhatyourgoalView(),));
                      },),
              ],
            ),
          )
        ],
      )),
    );
  }
}