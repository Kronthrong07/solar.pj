// ignore_for_file: prefer__ructors, prefer_const_constructors, prefer_final_fields, prefer_const_constructors_in_immutables, no_leading_underscores_for_local_identifiers, prefer_const_literals_to_create_immutables, non_constant_identifier_names, use_build_context_synchronously, avoid_web_libraries_in_flutter

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:solar_pj/models/user.dart';
import 'package:solar_pj/services/call_api.dart';
import 'package:solar_pj/views/login_user.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html; // ใช้เฉพาะในเว็บ

class RegisterUI extends StatefulWidget {
  RegisterUI({super.key});

  @override
  State<RegisterUI> createState() => _RegisterUIState();
}

class _RegisterUIState extends State<RegisterUI> {
  File? _imageSelected;
  String? _imageBase64Selected;
  TextEditingController _usernameController = TextEditingController(text: "");
  TextEditingController _passwordController = TextEditingController(text: "");
  TextEditingController _emailController = TextEditingController(text: "");
  TextEditingController _locationController = TextEditingController(text: "");
  TextEditingController _phoneController = TextEditingController(text: "");

  bool _passwordShow = true;

  Future<void> _pickImage() async {
    if (kIsWeb) {
      // สำหรับเว็บ ใช้ input file element
      final html.FileUploadInputElement uploadInput =
          html.FileUploadInputElement();
      uploadInput.accept = 'image/*';
      uploadInput.click();

      uploadInput.onChange.listen((event) {
        final file = uploadInput.files!.first;
        final reader = html.FileReader();

        reader.readAsDataUrl(file);
        reader.onLoadEnd.listen((event) {
          setState(() {
            _imageBase64Selected = reader.result as String?;
          });
        });
      });
    } else {
      // สำหรับมือถือและเดสก์ท็อป
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null) {
        setState(() {
          _imageSelected = File(result.files.first.path!);
          _imageBase64Selected =
              base64Encode(_imageSelected!.readAsBytesSync());
        });
      }
    }
  }

  Future<void> showDialogMassage(context, titleText, msg,
      {bool goToLogin = false}) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Align(
          alignment: Alignment.center,
          child: Text(titleText),
        ),
        content: Text(msg),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              if (goToLogin) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginUser()),
                );
              }
            },
            child: Text('ตกลง'),
          ),
        ],
      ),
    );
  }

  Future<void> _Register() async {
    if ([
      _usernameController,
      _passwordController,
      _emailController,
      _locationController,
      _phoneController
    ].any((controller) => controller.text.trim().isEmpty)) {
      showDialogMassage(context, 'แจ้งเตือน', 'กรุณาป้อนข้อมูลให้ครบทุกช่อง');
      return;
    }
    bool isValidEmail(String email) {
      return RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$")
          .hasMatch(email);
    }

    if (!isValidEmail(_emailController.text)) {
      showDialogMassage(context, 'แจ้งเตือน', 'กรุณากรอกอีเมลให้ถูกต้อง');
      return;
    }

    // แสดง Dialog ขณะกำลังโหลด
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Text("กำลังบันทึกการลงทะเบียน..."),
          ],
        ),
      ),
    );

    User user = User(
      username: _usernameController.text,
      password: _passwordController.text,
      email: _emailController.text,
      location: _locationController.text,
      phone: _phoneController.text,
      imageName: _imageBase64Selected,
    );

    try {
      var value = await CallApi.RegisterAPI(user);
      Navigator.pop(context);

      if (value[0].message == "1") {
        showDialogMassage(context, 'แจ้งเตือน', 'ลงทะเบียนสำเร็จ',
            goToLogin: true);
        _usernameController.clear();
        _passwordController.clear();
        _emailController.clear();
        _locationController.clear();
        _phoneController.clear();
        setState(() {
          _imageSelected = null;
          _imageBase64Selected = null;
        });
      } else if (value[0].message == "2") {
        showDialogMassage(context, 'แจ้งเตือน', "ชื่อผู้ใช้งานนี้ถูกใช้ไปแล้ว");
      } else {
        showDialogMassage(
            context, 'แจ้งเตือน', "ลงทะเบียนไม่สําเร็จ กรุณาลองใหม่อีกครั้ง");
      }
    } catch (e) {
      Navigator.pop(context); // ปิด Dialog โหลด
      if (e is TimeoutException) {
        showDialogMassage(
            context, 'ข้อผิดพลาด', 'การเชื่อมต่อล้มเหลว โปรดลองอีกครั้ง');
      } else if (e is SocketException) {
        showDialogMassage(
            context, 'ข้อผิดพลาด', 'ไม่มีการเชื่อมต่ออินเทอร์เน็ต');
      } else {
        showDialogMassage(
            context, 'ข้อผิดพลาด', 'เกิดข้อผิดพลาด: ${e.toString()}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.05,
          left: MediaQuery.of(context).size.width * 0.25,
          right: MediaQuery.of(context).size.width * 0.25,
          bottom: MediaQuery.of(context).size.height * 0.05,
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/WobBG.png'),
            // fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.01,
              right: MediaQuery.of(context).size.width * 0.01,
              top: MediaQuery.of(context).size.height * 0.01,
              bottom: MediaQuery.of(context).size.height * 0.01,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color.fromARGB(174, 255, 255, 255),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'เพิ่มข้อมูลผู้ใช้งาน',
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.03,
                      //fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 8, 3, 74)),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                CircleAvatar(
                  radius: MediaQuery.of(context).size.height * 0.1,
                  backgroundColor: Colors.transparent, // พื้นหลังโปร่งใส
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Color.fromARGB(255, 8, 3, 74), // สีของเส้นขอบ
                        width: 3, // ความหนาของเส้นขอบ
                      ),
                    ),
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: MediaQuery.of(context).size.height * 0.1,
                          backgroundColor: Colors.transparent,
                          backgroundImage: _imageBase64Selected != null
                              ? (kIsWeb
                                  ? MemoryImage(base64Decode(
                                      _imageBase64Selected!
                                          .split(',')
                                          .last)) as ImageProvider
                                  : FileImage(_imageSelected!))
                              : AssetImage("assets/images/LOGO.webp")
                                  as ImageProvider,
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            width: MediaQuery.of(context).size.height * 0.06,
                            height: MediaQuery.of(context).size.height * 0.05,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(
                                  255, 8, 3, 74), // พื้นหลังของไอคอนกล้อง
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white, // เส้นขอบรอบไอคอนกล้อง
                                width: 2,
                              ),
                            ),
                            child: IconButton(
                              onPressed: _pickImage,
                              icon: Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.white,
                                size: MediaQuery.of(context).size.height * 0.03,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'ชื่อผู้ใช้',
                    floatingLabelStyle: TextStyle(
                      color: Color.fromARGB(255, 8, 3, 74),
                      fontSize: MediaQuery.of(context).size.height * 0.025,
                    ),
                    hintText: "Username",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 8, 3, 74)),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                TextField(
                  controller: _passwordController,
                  obscureText: _passwordShow,
                  decoration: InputDecoration(
                    labelText: 'รหัสผ่าน',
                    floatingLabelStyle: TextStyle(
                      color: Color.fromARGB(255, 8, 3, 74),
                      fontSize: MediaQuery.of(context).size.height * 0.025,
                    ),
                    hintText: "Password",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordShow ? Icons.visibility_off : Icons.visibility,
                        color: Color.fromARGB(255, 8, 3, 74),
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordShow = !_passwordShow;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 8, 3, 74)),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    floatingLabelStyle: TextStyle(
                      color: Color.fromARGB(255, 8, 3, 74),
                      fontSize: MediaQuery.of(context).size.height * 0.025,
                    ),
                    hintText: "user@example.com",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 8, 3, 74)),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    floatingLabelStyle: TextStyle(
                      color: Color.fromARGB(255, 8, 3, 74),
                      fontSize: MediaQuery.of(context).size.height * 0.025,
                    ),
                    hintText: "08xxxxxxxx",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 8, 3, 74)),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                TextField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    labelText: 'Location',
                    floatingLabelStyle: TextStyle(
                      color: Color.fromARGB(255, 8, 3, 74),
                      fontSize: MediaQuery.of(context).size.height * 0.025,
                    ),
                    hintText: "city",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 8, 3, 74)),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                ElevatedButton(
                  onPressed: _Register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 12, 5, 119),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    fixedSize: Size(
                      MediaQuery.of(context).size.width * 0.80,
                      MediaQuery.of(context).size.height * 0.070,
                    ),
                  ),
                  child: Text(
                    'บันทึกการลงทะเบียน',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height *
                          0.02, // ขนาดฟอนต์
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.025,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("return to"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginUser()),
                        );
                      },
                      child: Text("Login"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
