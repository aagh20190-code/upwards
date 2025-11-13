import 'package:flutter/material.dart';
import 'package:upwards2/common/colo_extension.dart';
import 'package:upwards2/common_widget/on_boardig_page.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
var selectPage=0;
PageController controller =PageController();
@override
void initState() {
  super.initState();
  controller.addListener(() {
    selectPage = controller.page?.round()?? 0;
    setState(() {
      
    });
  });
}
List pageArr =[
  {
    "title":"Track Your Goals",
    "subtitle":"Don't worry if you have trouble determining your goals, We can help you determine your goals and track your goals",
    "image":"assets/img/one.png"
  },
  {
    "title":"Get Burn",
    "subtitle":"Let’s keep burning, to achive yours goals, it hurts only temporarily, if you give up now you will be in pain forever",
    "image":"assets/img/on2.png"
  },
  {
    "title":"Eat Well",
    "subtitle":"Let's start a healthy lifestyle with us, we can determine your diet every day. healthy eating is fun",
    "image":"assets/img/on3.png"
  },
  {
    "title":"Improve Sleep \nQuality",
    "subtitle":"Improve the quality of your sleep with us, good quality sleep can bring a good mood in the morning",
    "image":"assets/img/on4.png"
  },
  {
    "title":"Track Your Study",
    "subtitle":"track how much effort you are giving to your study and ",
    "image":"assets/img/on5.png"
  }
];

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColor.white,
      body: Stack(
        alignment: Alignment.bottomRight,
        children: [
        PageView.builder(
          controller: controller,
          itemCount: pageArr.length,
          itemBuilder: (context, index) {
            var pObj = pageArr[index] as Map? ?? {};
          return OnBoardingPage(pObj: pObj);
        },),
        //this is our new changes 
        SizedBox(
          width: 120,
          height: 120,
          child: Stack(
            alignment: Alignment.center,
            children: [
                   SizedBox(
                width: 70,
                height: 70,
                child: CircularProgressIndicator(
                  color: TColor.primaryColor1,
                  value: (selectPage + 1) / 5,
                  strokeWidth: 2,),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 25,vertical: 25),
                width: 60,
                height: 60,
                decoration: BoxDecoration(color: TColor.primaryColor1,borderRadius: BorderRadius.circular(35)),
                child: IconButton(icon: Icon(Icons.navigate_next,color: TColor.white), onPressed: (){
                  if(selectPage<4){
                    selectPage=selectPage+1;
                    
                  controller.jumpToPage(selectPage);
                  setState(() {
                    
                  });
              
                  } else
                  
                  {
                  
                  print("Open welcome screen");
                  
                  }
                }, ),
              ),
         
            ],
          ),
        )
      ],),
    );
  }
}