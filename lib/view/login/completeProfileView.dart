import 'package:flutter/material.dart';
import 'package:upwards2/common/colo_extension.dart';
import 'package:upwards2/common_widget/round_button.dart';
import 'package:upwards2/common_widget/round_textfield.dart';

class Completeprofileview extends StatefulWidget {
  const Completeprofileview({super.key});

  @override
  State<Completeprofileview> createState() => _CompleteprofileviewState();
}

class _CompleteprofileviewState extends State<Completeprofileview> {
  TextEditingController txtDate = TextEditingController() ;
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(children: [
              Image.asset("assets/img/sign1.png",
              width: media.width,
              fit: BoxFit.fitWidth,
              ),
              SizedBox(
                  height: media.width*0.05,
                ),

                Text(
                "Let's Complete Your Profile",
                style: TextStyle(color: TColor.black,
                fontSize: 18,
                fontWeight: FontWeight.w700),
                ),

                Text(
                "It will help us to know more about you",
                style: TextStyle(color: TColor.grey,
                fontSize: 12),
                ),
                SizedBox(
                  height: media.width*0.05,
                ),

                 Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 15.0),
                   child: Column(
                     children: [
                      Container(
      
                decoration: BoxDecoration(
                  color: TColor.lightGrey,
                  borderRadius: BorderRadius.circular(15)),
                child:
                DropdownButtonHideUnderline(
                  child: DropdownButton(
                    items: ["Male","Female"].map((name)=>DropdownMenuItem(
                      value: name,
                      child: Text(name,
                                style: TextStyle(
                                  color: TColor.grey,
                                  fontSize: 16),
                                  ),
                                  )).toList(),
                                  onChanged: (value){},
                                  hint: Text(
                                    "Chose Gender",
                                style: TextStyle(
                                  color: TColor.grey,
                                  fontSize: 16),
                                  ),),
                )),

                SizedBox(height: media.width*0.04,),

                       RoundTextFeild(
                        controller: txtDate,
                        hintText: "Date of Birth",
                        icon: "assets/img/dob.png",              
                        ),
                     SizedBox(
                              height: media.width*0.04,),

                        Row(
                          children: [
                             Expanded(
                               child: RoundTextFeild(
                               controller: txtDate,
                               hintText: "Your Weight",
                               icon: "assets/img/weight.png",              
                                                         ),
                             ),
                            const SizedBox(width: 8,),
                             
                             Container(
                              width: 50,
                              height: 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: TColor.secondaryGrad),
                                  borderRadius: BorderRadius.circular(15)),
                              
                              child: Text("KG",
                              style: TextStyle(
                                color: TColor.white,fontSize: 12),),
                             )
                         ],
                        ),

                         SizedBox(
                              height: media.width*0.04,),

                        Row(
                          children: [
                             Expanded(
                               child: RoundTextFeild(
                               controller: txtDate,
                               hintText: "Your Height",
                               icon: "assets/img/height.png",              
                                                         ),
                             ),
                            const SizedBox(width: 8,),
                             
                             Container(
                              width: 50,
                              height: 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: TColor.secondaryGrad),
                                  borderRadius: BorderRadius.circular(15)),
                              
                              child: Text("CM",
                              style: TextStyle(
                                color: TColor.white,fontSize: 12),),
                             )
                         ],
                        ),
                        SizedBox(
                                 height: media.width*0.04,),

                RoundButton(title: "Next >", 
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) =>const Completeprofileview(),));
                      },),
                     ],
                   ),
                 ),
            ],),
          ),
        ),
      ),
    );
  }
}