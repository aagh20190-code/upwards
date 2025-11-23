import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:upwards2/common_widget/titile_subtititle_cell.dart';
import 'package:url_launcher/url_launcher.dart'; 

import '../../common/colo_extension.dart';
import '../../common_widget/round_button.dart';
import '../../common_widget/setting_row.dart';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  // --- STATE VARIABLES ---
  bool positive = false; // Notification switch
  
  // Profile Data Display Variables
  String name = "Loading...";
  String email = "Loading...";
  String height = "-";
  String weight = "-";
  String age = "-";
  String gender = "-";
  String dob = "-";

  // Controllers for Editing Profile
  TextEditingController txtName = TextEditingController();
  TextEditingController txtHeight = TextEditingController();
  TextEditingController txtWeight = TextEditingController();
  TextEditingController txtAge = TextEditingController();

  // Menu Items
  List accountArr = [
    {"image": "assets/img/p_personal.png", "name": "Personal Data", "tag": "1"},
    {"image": "assets/img/p_achi.png", "name": "Achievement", "tag": "2"},
    {"image": "assets/img/p_activity.png", "name": "Activity History", "tag": "3"},
    {"image": "assets/img/p_workout.png", "name": "Workout Progress", "tag": "4"}
  ];

  List otherArr = [
    {"image": "assets/img/p_contact.png", "name": "Contact Us", "tag": "5"},
    {"image": "assets/img/p_privacy.png", "name": "Privacy Policy", "tag": "6"},
    {"image": "assets/img/p_setting.png", "name": "Setting", "tag": "7"},
  ];

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  // --- 1. BACKEND: FETCH DATA ---
  Future<void> fetchProfileData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Get Email from Auth
        setState(() {
          email = user.email ?? "No Email";
        });

        // Get Profile Data from Firestore
        var doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (doc.exists) {
          var data = doc.data() as Map<String, dynamic>;
          setState(() {
            name = "${data['firstName'] ?? ''} ${data['lastName'] ?? ''}";
            height = data['height']?.toString() ?? "-";
            weight = data['weight']?.toString() ?? "-";
            age = data['age']?.toString() ?? "-";
            gender = data['gender'] ?? "-";
            dob = data['date_of_birth'] ?? "-";
            positive = data['receive_notifications'] ?? false;
          });
        }
      }
    } catch (e) {
      print("Error fetching profile: $e");
    }
  }

  // --- 2. FEATURE: SHOW PERSONAL DATA POPUP ---
  void _showPersonalDataDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Personal Data", style: TextStyle(fontWeight: FontWeight.w700)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDataRow("Full Name", name),
                _buildDataRow("Email", email),
                _buildDataRow("Gender", gender),
                _buildDataRow("Date of Birth", dob),
                _buildDataRow("Age", "$age yo"),
                _buildDataRow("Height", "$height cm"),
                _buildDataRow("Weight", "$weight kg"),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            )
          ],
        );
      },
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text("$label:", style: TextStyle(color: TColor.grey, fontSize: 14, fontWeight: FontWeight.w500)),
          ),
          Expanded(
            child: Text(value, style: TextStyle(color: TColor.black, fontSize: 14, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  // --- 3. FEATURE: EDIT PROFILE POPUP ---
  void _showEditProfileDialog() {
    // Pre-fill controllers with current data
    txtName.text = name;
    txtHeight.text = height;
    txtWeight.text = weight;
    txtAge.text = age;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Profile"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: txtName, decoration: const InputDecoration(labelText: "Full Name")),
                TextField(controller: txtHeight, decoration: const InputDecoration(labelText: "Height (cm)"), keyboardType: TextInputType.number),
                TextField(controller: txtWeight, decoration: const InputDecoration(labelText: "Weight (kg)"), keyboardType: TextInputType.number),
                TextField(controller: txtAge, decoration: const InputDecoration(labelText: "Age"), keyboardType: TextInputType.number),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
            TextButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  // Split name logic
                  List<String> nameParts = txtName.text.split(" ");
                  String fName = nameParts.isNotEmpty ? nameParts[0] : "";
                  String lName = nameParts.length > 1 ? nameParts.sublist(1).join(" ") : "";
                  
                  // Update Firebase
                  await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
                    'firstName': fName,
                    'lastName': lName,
                    'height': txtHeight.text,
                    'weight': txtWeight.text,
                    'age': txtAge.text,
                  });
                  
                  // Refresh UI
                  fetchProfileData();
                  if(mounted) Navigator.pop(context);
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  // --- 4. FEATURE: EMAIL LAUNCHER ---
  Future<void> _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'contact.with.aniket.anik@gmail.com',
      queryParameters: {'subject': 'Support Request - Upwards App'},
    );
    try { await launchUrl(emailLaunchUri); } catch (e) { 
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Could not open email app")));
    }
  }

  // --- 5. FEATURE: PRIVACY POLICY ---
  void _showPrivacyPolicy() {
    const String policyText = """
Effective Date: November 24, 2025

1. Information We Collect
We collect personal data (Name, Email, Age) and physical data (Height, Weight) to calculate health metrics.

2. How We Use Your Data
- To provide BMI calculations and visualization charts.
- To manage your account securely via Firebase.

3. Data Storage
Your data is stored securely on Google Firebase servers. We do not share your personal health data with third parties.

4. Contact Us
For questions, email: contact.with.aniket.anik@gmail.com
""";
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Privacy Policy"),
          content: const SingleChildScrollView(child: Text(policyText, style: TextStyle(fontSize: 14))),
          actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close"))],
        );
      },
    );
  }

  // --- 6. FEATURE: NOTIFICATION TOGGLE ---
  void updateNotification(bool value) {
    setState(() => positive = value);
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance.collection('users').doc(user.uid).update({'receive_notifications': value});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white,
        centerTitle: true,
        elevation: 0,
        leadingWidth: 0,
        title: Text("Profile", style: TextStyle(color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700)),
        actions: [
          InkWell(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.all(8),
              height: 40, width: 40, alignment: Alignment.center,
              decoration: BoxDecoration(color: TColor.lightGrey, borderRadius: BorderRadius.circular(10)),
              child: Image.asset("assets/img/more_btn.png", width: 15, height: 15, fit: BoxFit.contain),
            ),
          )
        ],
      ),
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // HEADER
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset("assets/img/u2.png", width: 50, height: 50, fit: BoxFit.cover),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: TextStyle(color: TColor.black, fontSize: 14, fontWeight: FontWeight.w500)),
                        Text("Lose a Fat Program", style: TextStyle(color: TColor.grey, fontSize: 12))
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 70, height: 25,
                    child: RoundButton(
                      title: "Edit", type: RoundButtonType.bgGradient, fontSize: 12, fontWeight: FontWeight.w400,
                      onPressed: () => _showEditProfileDialog(),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15),
              
              // STATS
              Row(
                children: [
                  Expanded(child: TitleSubtitleCell(title: "${height}cm", subtitle: "Height")),
                  const SizedBox(width: 15),
                  Expanded(child: TitleSubtitleCell(title: "${weight}kg", subtitle: "Weight")),
                  const SizedBox(width: 15),
                  Expanded(child: TitleSubtitleCell(title: "${age}yo", subtitle: "Age")),
                ],
              ),
              const SizedBox(height: 25),

              // ACCOUNT SECTION
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(color: TColor.white, borderRadius: BorderRadius.circular(15), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Account", style: TextStyle(color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: accountArr.length,
                      itemBuilder: (context, index) {
                        var iObj = accountArr[index] as Map? ?? {};
                        return SettingRow(
                          icon: iObj["image"].toString(),
                          title: iObj["name"].toString(),
                          onPressed: () {
                            // Handle Account Buttons
                            if(iObj["tag"] == "1") {
                              _showPersonalDataDialog(); // Show Personal Data
                            } else {
                              // Placeholder for Achievement, Activity, Workout
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Opening ${iObj['name']}")));
                            }
                          },
                        );
                      },
                    )
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // NOTIFICATION SECTION
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(color: TColor.white, borderRadius: BorderRadius.circular(15), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Notification", style: TextStyle(color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 30,
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset("assets/img/p_notification.png", height: 15, width: 15, fit: BoxFit.contain),
                            const SizedBox(width: 15),
                            Expanded(child: Text("Pop-up Notification", style: TextStyle(color: TColor.black, fontSize: 12))),
                            CustomAnimatedToggleSwitch<bool>(
                              current: positive,
                              values: const [false, true],
                              spacing: 0.0,
                              indicatorSize: const Size.square(30.0),
                              animationDuration: const Duration(milliseconds: 200),
                              animationCurve: Curves.linear,
                              onChanged: (b) => updateNotification(b),
                              iconBuilder: (context, local, global) => const SizedBox(),
                              cursors: const ToggleCursors(defaultCursor: SystemMouseCursors.click),
                              onTap: (_) => updateNotification(!positive),
                              iconsTappable: false,
                              wrapperBuilder: (context, global, child) {
                                return Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Positioned(left: 10.0, right: 10.0, height: 30.0, child: DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(colors: TColor.secondaryGrad), borderRadius: const BorderRadius.all(Radius.circular(50.0))))),
                                    child,
                                  ],
                                );
                              },
                              foregroundIndicatorBuilder: (context, global) {
                                return SizedBox.fromSize(size: const Size(10, 10), child: DecoratedBox(decoration: BoxDecoration(color: TColor.white, borderRadius: const BorderRadius.all(Radius.circular(50.0)), boxShadow: const [BoxShadow(color: Colors.black38, spreadRadius: 0.05, blurRadius: 1.1, offset: Offset(0.0, 0.8))])));
                              },
                            ),
                          ]),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // OTHER SECTION
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(color: TColor.white, borderRadius: BorderRadius.circular(15), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Other", style: TextStyle(color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: otherArr.length,
                      itemBuilder: (context, index) {
                        var iObj = otherArr[index] as Map? ?? {};
                        return SettingRow(
                          icon: iObj["image"].toString(),
                          title: iObj["name"].toString(),
                          onPressed: () {
                            // Handle Contact & Privacy
                            if (iObj["tag"] == "5") {
                              _launchEmail();
                            } else if (iObj["tag"] == "6") {
                              _showPrivacyPolicy();
                            }
                          },
                        );
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}