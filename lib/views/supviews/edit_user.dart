// ignore_for_file: prefer__ructors, prefer_const_constructors, prefer_final_fields, prefer_const_constructors_in_immutables, no_leading_underscores_for_local_identifiers, prefer_const_literals_to_create_immutables, non_constant_identifier_names, use_build_context_synchronously, avoid_web_libraries_in_flutter, camel_case_types, must_be_immutable, deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:solar_pj/models/user.dart';
import 'package:solar_pj/services/call_api.dart';
import 'package:solar_pj/views/login_user.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html; // ใช้เฉพาะในเว็บ

class editUser extends StatefulWidget {
  User? user;
  editUser({
    this.user,
    super.key,
  });

  @override
  State<editUser> createState() => _editUserState();
}

class _editUserState extends State<editUser> {
  Uint8List? _imageBytes;
  File? _imageSelected;
  String? _imageBase64Selected;
  TextEditingController _usernameController = TextEditingController(text: "");
  TextEditingController _passwordController = TextEditingController(text: "");
  TextEditingController _emailController = TextEditingController(text: "");
  TextEditingController _locationController = TextEditingController(text: "");
  TextEditingController _phoneController = TextEditingController(text: "");

  bool _passwordShow = true;

  void initState() {
    _usernameController.text = widget.user!.username!;
    _passwordController.text = widget.user!.password!;
    _emailController.text = widget.user!.email!;
    _locationController.text = widget.user!.location!;
    _phoneController.text = widget.user!.phone!;
    super.initState();
    if (widget.user?.imageName != null && widget.user!.imageName!.isNotEmpty) {
      _imageBytes = base64Decode(widget.user!.imageName!);
    }
  }

  Future<void> _pickImage() async {
    if (kIsWeb) {
      // สำหรับเว็บ: ใช้ File Upload
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
            _imageBytes = base64Decode(_imageBase64Selected!.split(',').last);
          });

          print(
              "Image selected (Web): ${_imageBase64Selected?.substring(0, 30)}...");
          print("Image bytes length: ${_imageBytes?.length}");
        });
      });
    } else {
      // สำหรับมือถือและเดสก์ท็อป
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null) {
        File imageFile = File(result.files.first.path!);
        Uint8List bytes = await imageFile.readAsBytes();
        String base64String = base64Encode(bytes);

        setState(() {
          _imageSelected = imageFile;
          _imageBase64Selected = base64String;
          _imageBytes = bytes;
        });

        print("Image selected (Mobile/Desktop): ${_imageSelected?.path}");
        print("Image bytes length: ${_imageBytes?.length}");
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

  Future<void> _update() async {
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
      userID: widget.user!.userID,
      username: _usernameController.text,
      password: _passwordController.text,
      email: _emailController.text,
      location: _locationController.text,
      phone: _phoneController.text,
      imageName: _imageBase64Selected,
    );

    try {
      var value = await CallApi.editUser(user);
      Navigator.pop(context);

      if (value[0].message == "1") {
        showDialogMassage(
          context,
          'แจ้งเตือน',
          'แก้ไขข้อมูลสําเร็จ',
        ).then((value) => {
              Navigator.pop(context, user),
            });
      } else {
        showDialogMassage(
            context, 'แจ้งเตือน', "แก้ไขข้อมูลไม่สําเร็จ กรุณาลองใหม่อีกครั้ง");
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
                  'แก้ไขข้อมูลผู้ใช้งาน',
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
                          backgroundImage: _imageBytes != null
                              ? MemoryImage(_imageBytes!)
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
                  obscureText: true,
                  // obscureText: _passwordShow,
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
                      // onPressed: () {
                      //   setState(() {
                      //     _passwordShow = !_passwordShow;
                      //   });
                      // },
                      onPressed: () {
                        showDialogMassage(context, 'แจ้งเตือน',
                            "ไม่อนุญาตให้ดูรหัสผ่านเพื่อความปลอดภัยของผู้ใช้งาน");
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
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 173, 173, 173),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          fixedSize: Size(
                            MediaQuery.of(context).size.width * 0.80,
                            MediaQuery.of(context).size.height * 0.070,
                          ),
                        ),
                        child: Text(
                          'ยกเลิกการลงทะเบียน',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height *
                                0.02, // ขนาดฟอนต์
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed: _update,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 21, 255, 0),
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
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.025,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
