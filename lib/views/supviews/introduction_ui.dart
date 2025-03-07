// ignore_for_file: prefer_const_constructors, unnecessary_import

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroductionUI extends StatefulWidget {
  const IntroductionUI({super.key});

  @override
  State<IntroductionUI> createState() => _IntroductionUIState();
}

class _IntroductionUIState extends State<IntroductionUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.01,
          right: MediaQuery.of(context).size.width * 0.01,
          top: MediaQuery.of(context).size.height * 0.05,
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/WobBG.png'),
            // fit: BoxFit.cover, // ทำให้ภาพเต็มหน้าจอ
          ),
        ),
        child: IntroductionScreen(
          pages: [
            PageViewModel(
              image: Image.asset('assets/images/body_back.png'),
              title: 'Solar Guardian',
              body: 'จากภาพ คือ เครื่องแผงโซลาร์เซลล์ ระบบอัจฉริยะที่ใช้ AI ในการตรวจจับและทำความสะอาดแผงโซลาร์เซลล์ พร้อมทั้งสามารถตรวจสอบข้อมูลแบบเรียลไทม์\n เช่น อุณหภูมิ,ความชื้น,และค่าพลังงานที่แผงโซลาร์เซลล์.',
            ),
            PageViewModel(
              image: Image.asset('assets/images/ECC.png'),
              title: 'Electrical circuit set',
              body: 'จากภาพ ภายในตู้มี ชุดวงจรCIRCUIT,POWER SUPPLY และการเดินสายเชื่อมต่อเข้ากับแผงโซลาร์เซลล์รับส่งผ่าน SENSOR เข้าตัวบอร์ด ESP32และส่งขึ้นไปยัง DATABASE',
            ),
            PageViewModel(
              image: Image.asset('assets/images/weare_solar.png'),
              title: 'We are Solar Guardian',
              body: 'ภาพประกอบชิ้นงานทั้งหมดและผู้จัดทำโดย \nNo.6419410003 ธนวัฒน์ ศรีโสภา\nNo.6419410007 ณัฐวุฒิ กรทอง \n No.6419410026 จรรยารักษ์	ชูกลิ่น \nNo.6419410027 นรวิชญ์	แดนดง',
            ),
          ],
          next: Icon(Icons.arrow_forward_ios_rounded, color: Colors.cyan),
          nextFlex: 0,
          showSkipButton: false,
          showDoneButton: false,
          dotsDecorator: DotsDecorator(
            color: Colors.grey,
            activeColor: Colors.cyan,
            activeSize: Size(12, 6),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          infiniteAutoScroll: true,
          autoScrollDuration: 5000,
          globalBackgroundColor: Colors.transparent,
        ),
      ),
    );
  }
}
