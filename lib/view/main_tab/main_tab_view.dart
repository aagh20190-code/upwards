import 'package:flutter/material.dart';
import 'package:upwards2/common/colo_extension.dart';
import 'package:upwards2/common_widget/tab_button.dart';
import 'package:upwards2/view/home/activity_tracker_view.dart';
import 'package:upwards2/view/home/blankView.dart';
import 'package:upwards2/view/home/home_view.dart';

class MainTabView extends StatefulWidget {
  const MainTabView({super.key});

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView> {
  int selectTab = 0;
  final PageStorageBucket pageBucket = PageStorageBucket();
  Widget currentTab =const HomeView();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
      body: PageStorage(bucket: pageBucket, child: currentTab),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        width: 70,
        height: 70,
        child: InkWell(
          onTap: (){},
          child: Container(
                      width: 65,
                      height: 65,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: TColor.primaryGrad),
                        borderRadius: BorderRadius.circular(35),
                        boxShadow: const [
                            BoxShadow(
                                color: Colors.black12, blurRadius: 2)
                                ]),


                        child: Icon(Icons.search,color: TColor.white,size: 35,),
                    ),),),
    
    
      bottomNavigationBar: BottomAppBar(
        child:Container(
          decoration: BoxDecoration(
            color: TColor.white,
            boxShadow: const [
            BoxShadow(
              color: Colors.black12, blurRadius: 2,offset: Offset(0, -2))
            ]),
            height: kToolbarHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                
                TabButton(
                  icon: "assets/img/Home.png",
                  selectIcon: "assets/img/Home2.png",
                  isActive: selectTab==0,
                  onTap: () {
                  selectTab=0;
                  currentTab = const HomeView();
                  if(mounted){
                     setState(() {
                  });
                  }
                }),
                         
                TabButton(
                  icon: "assets/img/Activity.png",
                   selectIcon: "assets/img/acitivity2.png",
                   isActive: selectTab==1, onTap: () {
                  selectTab=1;
                  currentTab = const ActivityTrackerView();
                  if(mounted){
                     setState(() {
                    
                  });
                  }
                 
                }),
                const SizedBox(width: 40,),


                TabButton(
                  icon: "assets/img/camera.png",
                   selectIcon: "assets/img/camera2.png",
                   isActive: selectTab==2,
                   
                  onTap: () {
                  selectTab=2;
                  currentTab = const Blankview();
                  if(mounted){
                     setState(() {
                    
                  });
                  }
                 
                }),

                TabButton(
                  icon: "assets/img/user.png",
                   selectIcon: "assets/img/user2.png",
                   isActive: selectTab==3, onTap: () {
                  selectTab=3;
                  currentTab = const Blankview();
                  if(mounted){
                     setState(() {
                    
                  });
                  }
                 
                }),
              ],
            ),
          ),
        ),
    );
  }
}