// ignore_for_file: must_be_immutable, prefer_const_constructors, prefer_final_fields, prefer_const_literals_to_create_immutables, unused_local_variable, dead_code
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:solar_pj/models/user.dart';
import 'package:solar_pj/views/supviews/ai_report.dart';
import 'package:solar_pj/views/supviews/edit_user.dart';
import 'package:solar_pj/views/supviews/history.dart';
// import 'package:solar_pj/views/supviews/intro_ui.dart';
import 'package:solar_pj/views/supviews/introduction_ui.dart';
import 'package:solar_pj/views/supviews/showstatus.dart';
import 'package:solar_pj/views/login_user.dart';

class HomeUi extends StatefulWidget {
  User? user;
  HomeUi({
    this.user,
    super.key,
  });

  @override
  State<HomeUi> createState() => _HomeUiState();
}

class _HomeUiState extends State<HomeUi> {
  Widget _currentPage = IntroductionUI();
  int _currentIndex = 0;
  Uint8List? _imageBytes;
  List<Widget> _pages = [
    IntroductionUI(),
    Showstatus(),
    History(),
    AiReport(),
  ];
  @override
  void initState() {
    super.initState();
    if (widget.user?.imageName != null && widget.user!.imageName!.isNotEmpty) {
      _imageBytes = base64Decode(widget.user!.imageName!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0B2447),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: LayoutBuilder(
          builder: (context, constraints) {
            bool isSmallScreen = constraints.maxWidth < 600;
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      _currentPage = IntroductionUI();
                      _currentIndex = 0;
                    });
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Solar Guardian",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Welcome to Solar Guardian",
                        style: TextStyle(fontSize: 15, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
              ],
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF0B2447),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.green,
                          child: _imageBytes != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.memory(
                                    _imageBytes!,
                                    fit: BoxFit.cover,
                                    width: 60,
                                    height: 60,
                                  ),
                                )
                              : Icon(Icons.person,
                                  color: Colors.white, size: 30),
                        ),
                        SizedBox(height: 10),
                        Text(
                          widget.user?.username ?? "User Name",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        Text(
                          widget.user?.email ?? "user@example.com",
                          style: TextStyle(fontSize: 14, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: IconButton(
                      icon: Icon(
                        FontAwesomeIcons.userPen,
                        color: Colors.white,
                        size: 18,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => editUser(
                              user: widget.user,
                            ),
                          ),
                        ).then((value) {
                          if (value != null && value is User) {
                            setState(() {
                              widget.user = value;
                            });
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(Icons.home, "Home", 0),
            _buildDrawerItem(Icons.show_chart, "Show Status", 1),
            _buildDrawerItem(Icons.history, "History", 2),
            _buildDrawerItem(FontAwesomeIcons.microchip, "AI Report", 3),
            Divider(),
            _buildDrawerItem(Icons.logout, "Logout", -1),
            SizedBox(height: 400),
            Center(
              child: Text(
                "ติดต่อเจ้าหน้าที่ \nEmail : 6EzV0@example.com\n Call: 062-464-4258 ",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center, 
              ),
            ),
          ],
        ),
      ),
      body: _currentPage,
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        if (index == -1) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginUser()));
        } else {
          setState(() {
            _currentIndex = index;
            _currentPage = _pages[_currentIndex];
          });
        }
      },
    );
  }
}
