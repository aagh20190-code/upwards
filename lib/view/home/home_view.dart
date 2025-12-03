import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Needed for date formatting
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';
import 'package:upwards2/common/colo_extension.dart';
import 'package:upwards2/common_widget/round_button.dart';
import 'package:upwards2/common_widget/workout_row.dart';
import 'package:upwards2/view/home/activity_tracker_view.dart';
import 'package:upwards2/view/home/finished_workout_view.dart';
import 'package:upwards2/view/home/notification_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // --- STATE VARIABLES ---
  String displayName = "User";
  double bmiValue = 0.0;
  String bmiMessage = "Calculating...";
  
  // Water
  int waterTaken = 0;
  int waterGoal = 2000; // Default target in ml
  List<Map<String, String>> waterHistory = [];

  // Sleep & Calories
  String sleepTime = "0h";
  int caloriesBurned = 0;
  int caloriesTarget = 1000; 

  // Workout Data
  List lastWorkoutArr = [];
  
  // Graph Data (Static for now, can be made dynamic later)
  List<FlSpot> weeklyProgressSpots = [
    const FlSpot(1, 0), const FlSpot(2, 0), const FlSpot(3, 0), 
    const FlSpot(4, 0), const FlSpot(5, 0), const FlSpot(6, 0), const FlSpot(7, 0)
  ];

  // Controllers for Quick Log Inputs
  TextEditingController waterController = TextEditingController();
  TextEditingController sleepController = TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDashboardData();
  }

  @override
  void dispose() {
    waterController.dispose();
    sleepController.dispose();
    super.dispose();
  }

  // --- BACKEND FUNCTIONS ---

  Future<void> fetchDashboardData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return;
      String uid = user.uid;
      String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

      // 1. Fetch User Profile (Name, Weight, Height for BMI)
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (userDoc.exists) {
        var data = userDoc.data() as Map<String, dynamic>;
        displayName = "${data['firstName'] ?? 'User'} ${data['lastName'] ?? ''}";
        
        // Calculate BMI
        double weight = double.tryParse(data['weight'].toString()) ?? 0;
        double heightCm = double.tryParse(data['height'].toString()) ?? 0;
        
        if (weight > 0 && heightCm > 0) {
          // BMI Formula: kg / m^2
          double heightM = heightCm / 100;
          bmiValue = weight / (heightM * heightM);
          
          if(bmiValue < 18.5) bmiMessage = "Underweight";
          else if(bmiValue < 25) bmiMessage = "You have a normal weight";
          else if(bmiValue < 30) bmiMessage = "Overweight";
          else bmiMessage = "Obese";
        }
      }

      // 2. Fetch Today's Activity Log
      DocumentSnapshot todayLog = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('daily_logs')
          .doc(todayDate)
          .get();

      if (todayLog.exists) {
        var data = todayLog.data() as Map<String, dynamic>;
        waterTaken = data['water_intake'] ?? 0;
        sleepTime = data['sleep_hours'] ?? "0h";
        caloriesBurned = data['calories_burned'] ?? 0;
        
        // Get Water history array
        if(data['water_logs'] != null) {
           var logs = data['water_logs'] as List;
           waterHistory = logs.map((item) => {
             "title": item['time'].toString(),
             "subtitle": "${item['amount']}ml"
           }).toList().cast<Map<String, String>>();
        }
      }

      // 3. Fetch Latest Workouts
      QuerySnapshot workoutSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('workouts')
          .orderBy('timestamp', descending: true)
          .limit(3)
          .get();

      lastWorkoutArr = workoutSnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return {
           "name": data['workout_name'] ?? "Workout",
           "image": data['image'] ?? "assets/img/work1.png",
           "kcal": data['calories'].toString(),
           "time": data['duration'].toString(),
           "progress": data['progress'] ?? 0.5 
        };
      }).toList();

      if(mounted) {
        setState(() {
          isLoading = false;
        });
      }

    } catch (e) {
      print("Error fetching dashboard: $e");
      if(mounted) setState(() => isLoading = false);
    }
  }

  Future<void> addWater() async {
    int amount = int.tryParse(waterController.text) ?? 0;
    if (amount <= 0) return;

    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      String timeNow = DateFormat('h:mm a').format(DateTime.now());

      // Update Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('daily_logs')
          .doc(todayDate)
          .set({
        'water_intake': FieldValue.increment(amount),
        'water_logs': FieldValue.arrayUnion([
          {'time': timeNow, 'amount': amount}
        ])
      }, SetOptions(merge: true));

      // Update Local State
      setState(() {
        waterTaken += amount;
        waterHistory.add({'title': timeNow, 'subtitle': '${amount}ml'});
        waterController.clear();
      });

      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Water added!")),
        );
      }
    } catch (e) {
      print("Error adding water: $e");
    }
  }

  Future<void> updateSleep() async {
    String sleepInput = sleepController.text.trim();
    if (sleepInput.isEmpty) return;

    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

      // Update Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('daily_logs')
          .doc(todayDate)
          .set({
        'sleep_hours': sleepInput,
      }, SetOptions(merge: true));

      // Update Local State
      setState(() {
        sleepTime = sleepInput;
        sleepController.clear();
      });
      
      if(mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Sleep time updated!")),
        );
      }
    } catch (e) {
      print("Error updating sleep: $e");
    }
  }


  // ---heart rate data---
  List<int> showingTooltipOnSpots = [21];
  List<FlSpot> get allSpots => const [
        FlSpot(0, 40), FlSpot(1, 25), FlSpot(2, 40), FlSpot(3, 50),
        FlSpot(4, 35), FlSpot(5, 40), FlSpot(6, 30), FlSpot(7, 20),
        FlSpot(8, 25), FlSpot(9, 40), FlSpot(10, 50), FlSpot(11, 35),
        FlSpot(12, 50), FlSpot(13, 60), FlSpot(14, 40), FlSpot(15, 50),
        FlSpot(16, 20), FlSpot(17, 25), FlSpot(18, 40), FlSpot(19, 50),
        FlSpot(20, 35), FlSpot(21, 80), FlSpot(22, 30), FlSpot(23, 20),
        FlSpot(24, 25), FlSpot(25, 40), FlSpot(26, 50), FlSpot(27, 35),
        FlSpot(28, 50), FlSpot(29, 60), FlSpot(30, 40),
      ];

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    final lineBarsData = [
      LineChartBarData(
        showingIndicators: showingTooltipOnSpots,
        spots: allSpots,
        isCurved: true,
        barWidth: 2,
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(colors: [
            TColor.primaryColor2.withOpacity(0.4),
            TColor.primaryColor1.withOpacity(0.1),
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        dotData: FlDotData(show: false),
        gradient: LinearGradient(
          colors: TColor.primaryGrad,
        ),
      ),
    ];

    final tooltipsOnBar = lineBarsData[0];

    return Scaffold(
      backgroundColor: TColor.white,
      body: isLoading 
      ? const Center(child: CircularProgressIndicator()) 
      : SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- HEADER ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome back",
                          style: TextStyle(color: TColor.grey, fontSize: 12),
                        ),
                        Text(
                          displayName, 
                          style: TextStyle(
                              color: TColor.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NotificationView(),
                            ),
                          );
                        },
                        icon: Image.asset(
                          "assets/img/notificationact.png",
                          width: 25,
                          height: 25,
                          fit: BoxFit.fitHeight,
                        ))
                  ],
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                
                // --- BMI SECTION ---
                Container(
                  height: media.width * 0.4,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: TColor.primaryGrad),
                      borderRadius:
                          BorderRadius.circular(media.width * 0.075)),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        "assets/img/Banner-Dots.png",
                        height: media.width * 0.7,
                        width: double.maxFinite,
                        fit: BoxFit.fitHeight,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 25, horizontal: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "BMI (Body Mass Index)",
                                  style: TextStyle(
                                      color: TColor.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  bmiMessage, 
                                  style: TextStyle(
                                      color: TColor.white.withOpacity(0.7),
                                      fontSize: 12),
                                ),
                                SizedBox(
                                  height: media.width * 0.05,
                                ),
                                SizedBox(
                                    width: 120,
                                    height: 35,
                                    child: RoundButton(
                                      title: "View More",
                                      type: RoundButtonType.bgSGradient,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      onPressed: () {},
                                    ))
                              ],
                            ),
                            AspectRatio(
                              aspectRatio: 1,
                              child: PieChart(
                                PieChartData(
                                  pieTouchData: PieTouchData(
                                    touchCallback: (FlTouchEvent event,
                                        pieTouchResponse) {},
                                  ),
                                  startDegreeOffset: 250,
                                  borderData: FlBorderData(
                                    show: false,
                                  ),
                                  sectionsSpace: 1,
                                  centerSpaceRadius: 0,
                                  sections: showingSections(), // Uses bmiValue
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                
                // --- TARGET BUTTON ---
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  decoration: BoxDecoration(
                      color: TColor.primaryColor2.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Today Target",
                        style: TextStyle(
                            color: TColor.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        width: 70,
                        height: 25,
                        child: RoundButton(
                          title: "Check ",
                          type: RoundButtonType.bgGradient,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ActivityTrackerView(),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),

                // --- HEART RATE (Static) ---
                Text(
                  "Activity Status",
                  style: TextStyle(
                      color: TColor.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: media.width * 0.02,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Container(
                    height: media.width * 0.4,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        color: TColor.primaryColor2.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(25)),
                    child: Stack(
                      alignment: Alignment.topLeft,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 25, horizontal: 25),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Heart Rate",
                                style: TextStyle(
                                    color: TColor.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700),
                              ),
                              ShaderMask(
                                blendMode: BlendMode.srcIn,
                                shaderCallback: (bounds) {
                                  return LinearGradient(
                                          colors: TColor.primaryGrad,
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight)
                                      .createShader(Rect.fromLTRB(
                                          0, 0, bounds.width, bounds.height));
                                },
                                child: Text(
                                  "78 BPM", // Static
                                  style: TextStyle(
                                      color: TColor.black.withOpacity(0.7),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                          ),
                        ),
                        LineChart(
                          LineChartData(
                            showingTooltipIndicators:
                                showingTooltipOnSpots.map((index) {
                              return ShowingTooltipIndicators([
                                LineBarSpot(
                                  tooltipsOnBar,
                                  lineBarsData.indexOf(tooltipsOnBar),
                                  tooltipsOnBar.spots[index],
                                ),
                              ]);
                            }).toList(),
                            lineTouchData: LineTouchData(
                              enabled: true,
                              handleBuiltInTouches: false,
                              touchCallback: (FlTouchEvent event,
                                  LineTouchResponse? response) {
                                if (response == null ||
                                    response.lineBarSpots == null) {
                                  return;
                                }
                                if (event is FlTapUpEvent) {
                                  final spotIndex = response
                                      .lineBarSpots!.first.spotIndex;
                                  showingTooltipOnSpots.clear();
                                  setState(() {
                                    showingTooltipOnSpots.add(spotIndex);
                                  });
                                }
                              },
                              mouseCursorResolver: (FlTouchEvent event,
                                  LineTouchResponse? response) {
                                if (response == null ||
                                    response.lineBarSpots == null) {
                                  return SystemMouseCursors.basic;
                                }
                                return SystemMouseCursors.click;
                              },
                              getTouchedSpotIndicator:
                                  (LineChartBarData barData,
                                      List<int> spotIndexes) {
                                return spotIndexes.map((index) {
                                  return TouchedSpotIndicatorData(
                                    FlLine(
                                      color: Colors.transparent,
                                    ),
                                    FlDotData(
                                      show: true,
                                      getDotPainter:
                                          (spot, percent, barData, index) =>
                                              FlDotCirclePainter(
                                        radius: 5,
                                        color: Colors.white,
                                        strokeWidth: 3,
                                        strokeColor: TColor.secondaryColor1,
                                      ),
                                    ),
                                  );
                                }).toList();
                              },
                              touchTooltipData: LineTouchTooltipData(
                                getTooltipColor: (touchedSpot) =>
                                    TColor.secondaryColor1,
                                tooltipBorderRadius: BorderRadius.circular(16),
                                getTooltipItems:
                                    (List<LineBarSpot> lineBarsSpot) {
                                  return lineBarsSpot.map((lineBarSpot) {
                                    return LineTooltipItem(
                                      "${lineBarSpot.x.toInt()} mins ago",
                                      const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  }).toList();
                                },
                              ),
                            ),
                            lineBarsData: lineBarsData,
                            minY: 0,
                            maxY: 130,
                            titlesData: FlTitlesData(
                              show: false,
                            ),
                            gridData: FlGridData(show: false),
                            borderData: FlBorderData(
                              show: true,
                              border: Border.all(
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                
                // --- WATER INTAKE SECTION ---
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: media.width * 0.95,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: const [
                              BoxShadow(color: Colors.black12, blurRadius: 2)
                            ]),
                        child: Row(
                          children: [
                            SimpleAnimationProgressBar(
                              height: media.width * 0.85,
                              width: media.width * 0.07,
                              backgroundColor: Colors.grey.shade100,
                              foregroundColor: Colors.purple,
                              ratio: (waterTaken / waterGoal).clamp(0.0, 1.0), 
                              direction: Axis.vertical,
                              curve: Curves.fastLinearToSlowEaseIn,
                              duration: const Duration(seconds: 3),
                              borderRadius: BorderRadius.circular(15),
                              gradientColor: LinearGradient(
                                  colors: TColor.primaryGrad,
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Water Intake",
                                  style: TextStyle(
                                      color: TColor.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700),
                                ),
                                ShaderMask(
                                  blendMode: BlendMode.srcIn,
                                  shaderCallback: (bounds) {
                                    return LinearGradient(
                                            colors: TColor.primaryGrad,
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight)
                                        .createShader(Rect.fromLTRB(
                                            0, 0, bounds.width, bounds.height));
                                  },
                                  child: Text(
                                    "$waterTaken ml", 
                                    style: TextStyle(
                                        color: TColor.black.withOpacity(0.7),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "Real time updates",
                                  style: TextStyle(
                                    color: TColor.grey,
                                    fontSize: 12,
                                  ),
                                ),
                                
                                // DYNAMIC WATER LIST
                                waterHistory.isEmpty 
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text("No water yet", style: TextStyle(color: TColor.grey, fontSize: 10)),
                                  )
                                : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: waterHistory.map((wObj) { 
                                    var isLast = wObj == waterHistory.last;
                                    return Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.symmetric(
                                                  vertical: 4),
                                              width: 10,
                                              height: 10,
                                              decoration: BoxDecoration(
                                                  color: TColor.secondaryColor1
                                                      .withOpacity(0.5),
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                            ),
                                            if (!isLast)
                                              DottedDashedLine(
                                                height: media.width * 0.08,
                                                width: 0,
                                                axis: Axis.vertical,
                                                dashColor: TColor.secondaryColor1
                                                    .withOpacity(0.5),
                                              )
                                          ],
                                        ),
                                        const SizedBox(width: 10),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              wObj["title"].toString(),
                                              style: TextStyle(
                                                color: TColor.grey,
                                                fontSize: 10,
                                              ),
                                            ),
                                            ShaderMask(
                                              blendMode: BlendMode.srcIn,
                                              shaderCallback: (bounds) {
                                                return LinearGradient(
                                                        colors:
                                                            TColor.secondaryGrad,
                                                        begin:
                                                            Alignment.centerLeft,
                                                        end:
                                                            Alignment.centerRight)
                                                    .createShader(Rect.fromLTRB(
                                                        0,
                                                        0,
                                                        bounds.width,
                                                        bounds.height));
                                              },
                                              child: Text(
                                                wObj["subtitle"].toString(),
                                                style: TextStyle(
                                                  color: TColor.black
                                                      .withOpacity(0.7),
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    );
                                  }).toList())
                              ],
                            )),
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(
                      width: media.width * 0.05,
                    ),
                    
                    // --- RIGHT COLUMN: SLEEP & CALORIES ---
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // SLEEP
                          Container(
                            width: double.maxFinite,
                            padding: const EdgeInsets.symmetric(
                                vertical: 25, horizontal: 20),
                            height: media.width * 0.45,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.black12, blurRadius: 2)
                                ]),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Sleep",
                                    style: TextStyle(
                                        color: TColor.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  ShaderMask(
                                    blendMode: BlendMode.srcIn,
                                    shaderCallback: (bounds) {
                                      return LinearGradient(
                                              colors: TColor.primaryGrad,
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight)
                                          .createShader(Rect.fromLTRB(0, 0,
                                              bounds.width, bounds.height));
                                    },
                                    child: Text(
                                      sleepTime, 
                                      style: TextStyle(
                                          color: TColor.black.withOpacity(0.7),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  const Spacer(),
                                  Image.asset("assets/img/Sleep-Graph.png",
                                      width: double.maxFinite,
                                      fit: BoxFit.fitWidth),
                                ]),
                          ),
                          SizedBox(
                            height: media.width * 0.05,
                          ),
                          // CALORIES
                          Container(
                            width: double.maxFinite,
                            padding: const EdgeInsets.symmetric(
                                vertical: 25, horizontal: 20),
                            height: media.width * 0.45,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.black12, blurRadius: 2)
                                ]),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Calories",
                                    style: TextStyle(
                                        color: TColor.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  ShaderMask(
                                    blendMode: BlendMode.srcIn,
                                    shaderCallback: (bounds) {
                                      return LinearGradient(
                                              colors: TColor.primaryGrad,
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight)
                                          .createShader(Rect.fromLTRB(0, 0,
                                              bounds.width, bounds.height));
                                    },
                                    child: Text(
                                      "$caloriesBurned kCal", 
                                      style: TextStyle(
                                          color: TColor.black.withOpacity(0.7),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      width: media.width * 0.2,
                                      height: media.width * 0.2,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            width: media.width * 0.15,
                                            height: media.width * 0.15,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                  colors: TColor.primaryGrad),
                                              borderRadius: BorderRadius.circular(
                                                  media.width * 0.075),
                                            ),
                                            child: FittedBox(
                                              child: Text(
                                                "${caloriesTarget - caloriesBurned}kCal\nleft", 
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: TColor.white
                                                        .withOpacity(0.7),
                                                    fontSize: 10),
                                              ),
                                            ),
                                          ),
                                          SimpleCircularProgressBar(
                                            progressStrokeWidth: 10,
                                            backStrokeWidth: 10,
                                            startAngle: -180,
                                            backColor: Colors.grey.shade100,
                                            progressColors: TColor.primaryGrad,
                                            valueNotifier: ValueNotifier((caloriesBurned/caloriesTarget) * 100), 
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ]),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: media.width * 0.01,
                ),
                
                // --- WORKOUT PROGRESS GRAPH ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Workout Progress",
                      style: TextStyle(
                          color: TColor.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                    Container(
                        height: 30,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: TColor.primaryGrad),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            items: ["Weekly", "Monthly"]
                                .map((name) => DropdownMenuItem(
                                      value: name,
                                      child: Text(
                                        name,
                                        style: TextStyle(
                                            color: TColor.grey, fontSize: 14),
                                      ),
                                    ))
                                .toList(),
                            onChanged: (value) {},
                            icon: Icon(Icons.expand_more, color: TColor.white),
                            hint: Text(
                              "Weekly",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: TColor.white, fontSize: 12),
                            ),
                          ),
                        )),
                  ],
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 15),
                  height: media.width * 0.4,
                  width: double.maxFinite,
                  child: LineChart(
                    LineChartData(
                      showingTooltipIndicators:
                          showingTooltipOnSpots.map((index) {
                        return ShowingTooltipIndicators([
                          LineBarSpot(
                            tooltipsOnBar,
                            lineBarsData.indexOf(tooltipsOnBar),
                            tooltipsOnBar.spots[index],
                          ),
                        ]);
                      }).toList(),
                      lineTouchData: LineTouchData(
                        enabled: true,
                        handleBuiltInTouches: false,
                        touchCallback: (FlTouchEvent event,
                            LineTouchResponse? response) {
                          if (response == null ||
                              response.lineBarSpots == null) {
                            return;
                          }
                          if (event is FlTapUpEvent) {
                            final spotIndex =
                                response.lineBarSpots!.first.spotIndex;
                            showingTooltipOnSpots.clear();
                            setState(() {
                              showingTooltipOnSpots.add(spotIndex);
                            });
                          }
                        },

                        //aniket anik
                        mouseCursorResolver: (FlTouchEvent event,
                            LineTouchResponse? response) {
                          if (response == null ||
                              response.lineBarSpots == null) {
                            return SystemMouseCursors.basic;
                          }
                          return SystemMouseCursors.click;
                        },
                        getTouchedSpotIndicator:
                            (LineChartBarData barData, List<int> spotIndexes) {
                          return spotIndexes.map((index) {
                            return TouchedSpotIndicatorData(
                              FlLine(
                                color: Colors.transparent,
                              ),
                              FlDotData(
                                show: true,
                                getDotPainter:
                                    (spot, percent, barData, index) =>
                                        FlDotCirclePainter(
                                  radius: 5,
                                  color: Colors.white,
                                  strokeWidth: 3,
                                  strokeColor: TColor.secondaryColor1,
                                ),
                              ),
                            );
                          }).toList();
                        },
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipColor: (touchedSpot) =>
                              TColor.secondaryColor1,
                          tooltipBorderRadius: BorderRadius.circular(16),
                          getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
                            return lineBarsSpot.map((lineBarSpot) {
                              return LineTooltipItem(
                                "${lineBarSpot.x.toInt()} mins ago",
                                const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }).toList();
                          },
                        ),
                      ),
                      lineBarsData: lineBarsData1,
                      minY: -0.5,
                      maxY: 110,
                      titlesData: FlTitlesData(
                          show: true,
                          leftTitles: AxisTitles(),
                          topTitles: AxisTitles(),
                          bottomTitles: AxisTitles(
                              sideTitles: bottomTitles),
                          rightTitles: AxisTitles(
                            sideTitles: rightTitles,
                          )),
                      gridData: FlGridData(
                        show: true,
                        drawHorizontalLine: true,
                        horizontalInterval: 25,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (value) {
                          return FlLine(
                            color: TColor.grey.withOpacity(0.25),
                            strokeWidth: 2,
                          );
                        },
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                
                // --- LATEST WORKOUT LIST ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Latest Workout",
                      style: TextStyle(
                          color: TColor.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "See More",
                        style: TextStyle(
                            color: TColor.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      ),
                    )
                  ],
                ),
                
                lastWorkoutArr.isEmpty 
                ? const Text("No workout history found") 
                : ListView.builder(
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: lastWorkoutArr.length,
                    itemBuilder: (context, index) {
                      var wObj = lastWorkoutArr[index] as Map? ?? {};
                      return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const FinishedWorkoutView(),
                              ),
                            );
                          },
                          child: WorkoutRow(wObj: wObj));
                    }),
                    
                SizedBox(height: media.width * 0.1),
                
                // --- QUICK LOG SECTION (NEW) ---
                Text(
                  "Quick Log",
                  style: TextStyle(
                      color: TColor.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(height: media.width * 0.05),

                // 1. Water Input
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: TColor.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Add Water", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: TColor.black)),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: TColor.lightGrey,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: TextField(
                                controller: waterController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                  border: InputBorder.none,
                                  hintText: "ex: 200 (ml)",
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          SizedBox(
                            width: 60,
                            height: 40,
                            child: RoundButton(
                              title: "+",
                              onPressed: addWater, 
                              type: RoundButtonType.bgGradient,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: media.width * 0.05),

                // 2. Sleep Input
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: TColor.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Update Sleep", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: TColor.black)),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: TColor.lightGrey,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: TextField(
                                controller: sleepController,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                  border: InputBorder.none,
                                  hintText: "ex: 8h 30m",
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          SizedBox(
                            width: 80,
                            height: 40,
                            child: RoundButton(
                              title: "Save",
                              onPressed: updateSleep, 
                              type: RoundButtonType.bgGradient,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: media.width * 0.2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- DYNAMIC PIE CHART SECTION ---
  List<PieChartSectionData> showingSections() {
    return List.generate(
      2,
      (i) {
        var color0 = TColor.secondaryColor1;

        switch (i) {
          case 0:
            return PieChartSectionData(
                color: color0,
                value: bmiValue, 
                title: '',
                radius: 55,
                titlePositionPercentageOffset: 0.55,
                badgeWidget: Text(
                  bmiValue.toStringAsFixed(1), 
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700),
                ));
          case 1:
            return PieChartSectionData(
              color: Colors.white,
              value: 100 - bmiValue, 
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

  // --- CHART CONFIGURATIONS ---
  LineTouchData get lineTouchData1 => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (touchedSpot) => TColor.secondaryColor1,
        ),
      );

  List<LineChartBarData> get lineBarsData1 => [
        lineChartBarData1_1,
        lineChartBarData1_2,
      ];

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
        isCurved: true,
        gradient: LinearGradient(colors: [
          TColor.primaryColor2.withOpacity(0.5),
          TColor.primaryColor1.withOpacity(0.5),
        ]),
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: weeklyProgressSpots, 
      );

  LineChartBarData get lineChartBarData1_2 => LineChartBarData(
        isCurved: true,
        gradient: LinearGradient(colors: [
          TColor.secondaryColor2.withOpacity(0.5),
          TColor.secondaryColor1.withOpacity(0.5),
        ]),
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: false,
        ),
        spots: const [
          FlSpot(1, 80), FlSpot(2, 50), FlSpot(3, 90),
          FlSpot(4, 40), FlSpot(5, 80), FlSpot(6, 35), FlSpot(7, 60),
        ],
      );

  SideTitles get rightTitles => SideTitles(
        getTitlesWidget: rightTitleWidgets,
        showTitles: true,
        interval: 20,
        reservedSize: 40,
      );

  Widget rightTitleWidgets(double value, TitleMeta meta) {
    String text;
    switch (value.toInt()) {
      case 0: text = '0%'; break;
      case 20: text = '20%'; break;
      case 40: text = '40%'; break;
      case 60: text = '60%'; break;
      case 80: text = '80%'; break;
      case 100: text = '100%'; break;
      default: return Container();
    }
    return Text(text,
        style: TextStyle(
          color: TColor.grey,
          fontSize: 12,
        ),
        textAlign: TextAlign.center);
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    var style = TextStyle(
      color: TColor.grey,
      fontSize: 12,
    );
    Widget text;
    switch (value.toInt()) {
      case 1: text = Text('Sun', style: style); break;
      case 2: text = Text('Mon', style: style); break;
      case 3: text = Text('Tue', style: style); break;
      case 4: text = Text('Wed', style: style); break;
      case 5: text = Text('Thu', style: style); break;
      case 6: text = Text('Fri', style: style); break;
      case 7: text = Text('Sat', style: style); break;
      default: text = const Text(''); break;
    }

    return SideTitleWidget(
      meta: meta,
      space: 10,
      child: text,


    );
  }
}