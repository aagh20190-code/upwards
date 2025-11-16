import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:upwards2/common/colo_extension.dart';
import 'package:upwards2/common_widget/round_button.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: SafeArea(child: 
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                 Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
                  Text(
                  "Welcome back",
                  style: TextStyle(color: TColor.grey,
                  fontSize: 12),
                  ),
                  Text(
                  "Sami Chowdhury",
                  style: TextStyle(color: TColor.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
                  ),
                
           
           
            ],
           ),
              IconButton(onPressed: (){}, icon: Image.asset("assets/img/notificationact.png",width: 25,height: 25,fit: BoxFit.fitHeight,))
           
              ],),

              SizedBox(height: media.width*0.05,),
              Container(
                height: media.width*0.4,
                
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: TColor.primaryGrad),borderRadius: BorderRadius.circular(media.width*0.075)
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                  Image.asset(
                    "assets/img/Banner-Dots.png",
                    height: media.width*0.7,
                    width: double.maxFinite,
                    fit: BoxFit.fitHeight,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 25,horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                        "BMI (Body Mass Index)",
                                        style: TextStyle(color: TColor.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700),
                                        ),
                      
                                      Text(
                                        "You have a normal weight",
                                        style: TextStyle(color: TColor.white.withOpacity(0.7),
                                        fontSize: 12),
                                        ),

                                        SizedBox(
                                          height: media.width*0.05,
                                          ),

                                          SizedBox(
                                            width: 120,

                                            height: 35,
                                            child: RoundButton(title: "View More",type: RoundButtonType.bgSGradient,fontSize: 12,fontWeight: FontWeight.w400, onPressed: (){},))
                                        
                      
                            ],
                          ),


                          AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                     
                    },
                  ),
                  startDegreeOffset: 250,
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 1,
                  centerSpaceRadius: 0,
                  sections: showingSections(),
                ),
              ),
            ),
                        ],
                      ),
                    )
                    ]
                ),
              )
          
           
            ],
           ),
        ),
        ),
      ),
    );
  }
    List<PieChartSectionData> showingSections() {
    return List.generate(
      2,
      (i) {
        var color0 = TColor.secondaryColor1;

        switch (i) {
          case 0:
            return PieChartSectionData(
                color: color0,
                value: 33,
                title: '',
                radius: 55,
                titlePositionPercentageOffset: 0.55,
                badgeWidget: const Text(
                  "20,1",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700),
                ));
          case 1:
            return PieChartSectionData(
              color: Colors.white,
              value: 75,
              title: '',
              radius: 45,
              titlePositionPercentageOffset: 0.55,
            );

          default:
            throw Error();
        }
      },
    );
  }
}