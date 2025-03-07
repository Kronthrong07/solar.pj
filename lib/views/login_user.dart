// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_final_fields, use_build_context_synchronously, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:solar_pj/models/user.dart';
import 'package:solar_pj/services/call_api.dart';
import 'package:solar_pj/views/home.dart';
import 'package:solar_pj/views/register_user.dart';

class LoginUser extends StatefulWidget {
  const LoginUser({super.key});

  @override
  State<LoginUser> createState() => _LoginUserState();
}

class _LoginUserState extends State<LoginUser> {
  TextEditingController _usernameController = TextEditingController(text: '');
  TextEditingController _passwordController = TextEditingController(text: '');

  bool pwdStatus = true;
  Future<void> showDialogMassage(context, titleText, msg) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Align(
          alignment: Alignment.center,
          child: Text(
            titleText,
          ),
        ),
        content: Text(
          msg,
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'ตกลง',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _login() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      showDialogMassage(context, 'แจ้งเตือน', 'กรุณาป้อนข้อมูลให้ครบทุกช่อง');
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
            Text("กำลังเข้าสู่ระบบ..."),
          ],
        ),
      ),
    );

    User user = User(
      username: _usernameController.text,
      password: _passwordController.text,
    );

    try {
      var value = await CallApi.CheckLoginApi(user);
      Navigator.pop(context); // ปิด Dialog โหลด

      if (value[0].message == "1") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeUi(user: value[0]),
          ),
        );
      } else {
        // _usernameController.clear();
        _passwordController.clear();
        showDialogMassage(
            context, 'แจ้งเตือน', "ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง");
      }
    } catch (e) {
      Navigator.pop(context); // ปิด Dialog โหลด
      showDialogMassage(context, 'ข้อผิดพลาด', 'เกิดข้อผิดพลาดในการเชื่อมต่อ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        // padding: EdgeInsets.all(50),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/WobBG.png'),
            // fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(200, 236, 236, 236),
              borderRadius: BorderRadius.circular(30.0),
            ),
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width * 0.6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                  visible: MediaQuery.of(context).size.width >
                      1024, 
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    child: Container(
                      color: Color.fromARGB(255, 100, 115, 136),
                      width: MediaQuery.of(context).size.width * 0.25,
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: Image.asset(
                        "assets/images/LOGO.webp",
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Login to Solar Guardian',
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.025,
                              color: Colors.black,
                            )),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: MediaQuery.of(context).size.height * 0.06,
                          child: TextFormField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 2.0),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.blue[900]!, width: 2.0),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              hintText: 'UserName',
                              hintStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                              prefixIcon: Icon(
                                Icons.person,
                                color: Colors.black54,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: MediaQuery.of(context).size.height * 0.06,
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: pwdStatus,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 2.0),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.blue[900]!, width: 2.0),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              contentPadding: EdgeInsets.only(
                                  right: 20), // เพิ่มระยะห่างขอบขวา
                              hintText: 'Password',
                              hintStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                              prefixIcon: Icon(
                                FontAwesomeIcons.unlockKeyhole,
                                color: Colors.black54,
                              ),
                              suffixIcon: Padding(
                                padding: EdgeInsets.only(
                                    right: 20), // เพิ่มระยะห่างไอคอนตา 20px
                                child: IconButton(
                                  icon: Icon(
                                    pwdStatus
                                        ? FontAwesomeIcons.eyeSlash
                                        : FontAwesomeIcons.eye,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      pwdStatus = !pwdStatus;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        ElevatedButton(
                          onPressed: _login,
                          child: Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.02,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(
                              MediaQuery.of(context).size.width * 0.5,
                              MediaQuery.of(context).size.height * 0.07,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            backgroundColor: Colors.blueGrey[500],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Don't have an account?",
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RegisterUI()),
                                );
                              },
                              child: Text("Register"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
