// ignore_for_file: prefer__ructors, prefer__literals_to_create_immutables, prefer_const_constructors, non_constant_identifier_names, unused_field, prefer_const_literals_to_create_immutables
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:solar_pj/models/AiPredict.dart';
import 'package:solar_pj/models/cleaningHistory.dart';
import 'package:solar_pj/models/sensor.dart';
import 'package:solar_pj/services/call_api.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Showstatus extends StatefulWidget {
  const Showstatus({super.key});

  @override
  State<Showstatus> createState() => _ShowstatusState();
}

class _ShowstatusState extends State<Showstatus> {
  String? _RandomForest;
  String? _KNN;
  String? _NaiveBayes;
  String? _DecisionTreet;
  String? DateStar = '????-??-??';
  String? DateEnd = '????-??-??';
  double _MeanLight = 0.0;
  double _ElectricPower = 0.0;
  String _Temperature = "0.0";
  String _Humidity = "0.0";
  String _cleaningDate = "";
  String _cleaningText = "หยุด";
  String _cleaningStatus = "0";
  Timer? _timer;
  DateTime initDate = DateTime(1900);
  DateTime lastDate = DateTime(2100);
  DateTime defaultDate = DateTime.now();

  Future displayCalendar(BuildContext context) async {
    return await showDatePicker(
      context: context,
      firstDate: initDate,
      lastDate: lastDate,
      initialDate: defaultDate,
    );
  }

  @override
  void initState() {
    super.initState();
    fetchOneList(); // เรียกครั้งแรกเมื่อหน้าโหลด

    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      fetchOneList();
      fetchAllList(DateStar, DateEnd);
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // ยกเลิก Timer
    super.dispose();
  }

  Future<List<sensor>> fetchAllList(String? DateStar, String? DateEnd) async {
    if (DateStar == '????-??-??' || DateEnd == '????-??-??') {
      return [];
    }
    return CallApi.getAllData(DateStar, DateEnd);
  }

  Future<void> fetchOneList() async {
    List<sensor> oneData =
        await CallApi.getOneData(); // เปลี่ยน sensor -> Sensor
    List<cleaningHistory> oneData2 = await CallApi.getCleaningHistory();
    List<cleaningHistory> oneData3 = await CallApi.getCleaningStatus();
    List<AiPredict> oneData4 = await CallApi.latestAiPredict();

    sensor firstSensor = oneData.first; // เปลี่ยน sensor -> Sensor
    cleaningHistory firstCleaningHistory = oneData2.first;
    cleaningHistory firstCleaningStatus = oneData3.first;
    AiPredict firstAiPredict = oneData4.first;

    // แปลงค่า String เป็น double (ใช้ 0 ถ้า null)
    double light1 = firstSensor.light1 ?? 0.00;
    double light2 = firstSensor.light2 ?? 0.00;
    double light3 = firstSensor.light3 ?? 0.00;
    double current = firstSensor.current ?? 0.00;
    double voltage = firstSensor.voltage ?? 0.00;

    setState(() {
      _MeanLight =
          double.parse(((light1 + light2 + light3) / 3).toStringAsFixed(3));
      _ElectricPower = double.parse((current * voltage).toStringAsFixed(3));
      _Temperature = firstSensor.temperature?.toString() ?? "0.0";
      _Humidity = firstSensor.humidity?.toString() ?? "0.0";
      _cleaningDate = firstCleaningHistory.cleaningDate ?? "ไม่มีวัน";
      _cleaningStatus = firstCleaningStatus.message ?? "0";
      _cleaningText = (firstCleaningStatus.message ?? "0") == "1"
          ? "กำลังทำความสะอาด"
          : "หยุด";
      _RandomForest = (firstAiPredict.RandomForest ?? "N/A") == "1"
          ? "-15%"
          : (firstAiPredict.RandomForest == "2")
              ? "-30%"
              : (firstAiPredict.RandomForest == "0")
                  ? "-0%"
                  : "N/A"; // เพิ่มค่าเริ่มต้นหากไม่ตรงกับเงื่อนไขใดเลย
      _NaiveBayes = (firstAiPredict.NaiveBayes ?? "N/A") == "1"
          ? "-15%"
          : (firstAiPredict.NaiveBayes == "2")
              ? "-30%"
              : (firstAiPredict.NaiveBayes == "0")
                  ? "-0%"
                  : "N/A";
      _DecisionTreet = (firstAiPredict.DecisionTreet ?? "N/A") == "1"
          ? "-15%"
          : (firstAiPredict.DecisionTreet == "2")
              ? "-30%"
              : (firstAiPredict.DecisionTreet == "0")
                  ? "-0%"
                  : "N/A";
      _KNN = (firstAiPredict.KNN ?? "N/A") == "N/A"
          ? "N/A"
          : "-${firstAiPredict.KNN}%";
    });
  }

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
          textAlign: TextAlign.center,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.height * 0.1,
          right: MediaQuery.of(context).size.height * 0.1,
          top: MediaQuery.of(context).size.height * 0.05,
          bottom: MediaQuery.of(context).size.height * 0.05,
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/WobBG.png'),
            // fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.01,
                    right: MediaQuery.of(context).size.width * 0.01,
                    top: MediaQuery.of(context).size.height * 0.01,
                    bottom: MediaQuery.of(context).size.height * 0.01,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromARGB(200, 255, 255, 255),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Solar Panel Monitoring Dashboard',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.03,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _buildInfoCard("ค่าความเข้มแสง", _MeanLight.toString()),
                    _buildInfoCard("อุณหภูมิ (°C)", _Temperature),
                    _buildInfoCard("ความชื้น (%)", _Humidity),
                    _buildInfoCard(
                        "กำลังไฟฟ้าล่าสุด (W)", _ElectricPower.toString()),
                    _buildInfoCard(
                        "ทำความสะอาดครั้งล่าสุดเมื่อ", _cleaningDate),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.01,
                    right: MediaQuery.of(context).size.width * 0.01,
                    top: MediaQuery.of(context).size.height * 0.01,
                    bottom: MediaQuery.of(context).size.height * 0.01,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromARGB(200, 255, 255, 255),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      Text(
                        'ผลการทำนายจาก AI ล่าสุด',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.02,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _buildInfoCard("model KNN", _KNN.toString()),
                          _buildInfoCard(
                              "model Random Forest", _RandomForest.toString()),
                          _buildInfoCard(
                              "model Decision Tree", _DecisionTreet.toString()),
                          _buildInfoCard(
                              "model Naive Bayes", _NaiveBayes.toString()),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.01,
                    right: MediaQuery.of(context).size.width * 0.01,
                    top: MediaQuery.of(context).size.height * 0.01,
                    bottom: MediaQuery.of(context).size.height * 0.01,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromARGB(200, 255, 255, 255),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          InkWell(
                            child: Text(
                              'ตั้งแต่วันที่ : ${DateStar}',
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                            ),
                            onTap: () {
                              displayCalendar(context).then((value) {
                                if (value != null) {
                                  // ตรวจสอบว่าผู้ใช้ได้เลือกวันที่หรือไม่
                                  setState(() {
                                    DateStar =
                                        value.toString().substring(0, 10);
                                  });
                                }
                              });
                            },
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.04,
                          ),
                          InkWell(
                            child: Text(
                              'ถึงวันที่ : ${DateEnd}',
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                            ),
                            onTap: () {
                              displayCalendar(context).then((value) {
                                if (value != null) {
                                  // ตรวจสอบว่าผู้ใช้ได้เลือกวันที่หรือไม่
                                  setState(() {
                                    DateEnd = value.toString().substring(0, 10);
                                  });
                                }
                              });
                            },
                          ),
                        ],
                      ),
                      if (DateStar == '????-??-??' || DateEnd == '????-??-??')
                        Text(
                          "*กรุณาเลือกวันที่ที่ต้องการแสดงกราฟ*",
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.01,
                        right: MediaQuery.of(context).size.width * 0.01,
                        top: MediaQuery.of(context).size.height * 0.01,
                        bottom: MediaQuery.of(context).size.height * 0.01,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromARGB(200, 255, 255, 255),
                      ),
                      width: MediaQuery.of(context).size.width > 900
                          ? 800
                          : MediaQuery.of(context).size.width * 0.9,
                      child: Column(
                        children: [
                          Text(
                            'กราฟค่าพลังงานไฟฟ้า',
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.02,
                            ),
                          ),
                          FutureBuilder<List<sensor>>(
                            future: (DateStar != null && DateEnd != null)
                                ? fetchAllList(DateStar, DateEnd)
                                : null,
                            builder: (context, snapshot) {
                              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return Text(
                                  'ไม่พบข้อมูล',
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                  textAlign: TextAlign.center,
                                );
                              }
                              return SfCartesianChart(
                                primaryXAxis: CategoryAxis(
                                    title: AxisTitle(text: 'วันที่')),
                                primaryYAxis: NumericAxis(
                                    title:
                                        AxisTitle(text: 'Electric Power (W)')),
                                crosshairBehavior: CrosshairBehavior(
                                  enable: true,
                                  activationMode: ActivationMode.singleTap,
                                  lineWidth: 1.5,
                                ),
                                tooltipBehavior: TooltipBehavior(
                                  enable: true,
                                  header: "ค่าพลังงานไฟฟ้า",
                                  format:
                                      'วันที่: point.x \nค่าพลังงาน: point.y W',
                                ),
                                series: <LineSeries<sensor, String>>[
                                  LineSeries<sensor, String>(
                                    dataSource: snapshot.data!,
                                    xValueMapper: (sensor data, _) =>
                                        data.sendDateTime ?? "N/A",
                                    yValueMapper: (sensor data, _) =>
                                        (data.current ?? 0) *
                                        (data.voltage ?? 0),
                                    dataLabelSettings:
                                        DataLabelSettings(isVisible: false),
                                    markerSettings:
                                        MarkerSettings(isVisible: false),
                                    enableTooltip: true,
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.01,
                        right: MediaQuery.of(context).size.width * 0.01,
                        top: MediaQuery.of(context).size.height * 0.01,
                        bottom: MediaQuery.of(context).size.height * 0.01,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromARGB(200, 255, 255, 255),
                      ),
                      width: MediaQuery.of(context).size.width > 900
                          ? 800
                          : MediaQuery.of(context).size.width * 0.9,
                      child: Column(
                        children: [
                          Text("กราฟค่าความสว่างแสงอาทิตย์",
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.02,
                              )),
                          FutureBuilder<List<sensor>>(
                            future: (DateStar != null && DateEnd != null)
                                ? fetchAllList(DateStar, DateEnd)
                                : null,
                            builder: (context, snapshot) {
                              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return Text(
                                  'ไม่พบข้อมูล',
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                  textAlign: TextAlign.center,
                                );
                              }
                              return SfCartesianChart(
                                primaryXAxis: CategoryAxis(
                                    title: AxisTitle(text: 'วันที่')),
                                primaryYAxis: NumericAxis(
                                    title: AxisTitle(text: 'Liters (lx)')),
                                crosshairBehavior: CrosshairBehavior(
                                  enable: true,
                                  activationMode: ActivationMode.singleTap,
                                  lineWidth: 1.5,
                                ),
                                tooltipBehavior: TooltipBehavior(
                                  enable: true,
                                  header: "ค่าความสว่างแสงอาทิตย์",
                                  format:
                                      'วันที่: point.x \nค่าแสง: point.y lx',
                                ),
                                series: <LineSeries<sensor, String>>[
                                  LineSeries<sensor, String>(
                                    dataSource: snapshot.data!,
                                    xValueMapper: (sensor data, _) =>
                                        data.sendDateTime ?? "N/A",
                                    yValueMapper: (sensor data, _) =>
                                        ((data.light1 ?? 0) +
                                            (data.light2 ?? 0) +
                                            (data.light3 ?? 0)) /
                                        3,
                                    dataLabelSettings:
                                        DataLabelSettings(isVisible: false),
                                    markerSettings:
                                        MarkerSettings(isVisible: false),
                                    enableTooltip: true,
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.01,
                        right: MediaQuery.of(context).size.width * 0.01,
                        top: MediaQuery.of(context).size.height * 0.01,
                        bottom: MediaQuery.of(context).size.height * 0.01,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromARGB(200, 255, 255, 255),
                      ),
                      width: MediaQuery.of(context).size.width > 900
                          ? 800
                          : MediaQuery.of(context).size.width * 0.9,
                      child: Column(
                        children: [
                          Text("กราฟอุณหภูมิ",
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.02,
                              )),
                          FutureBuilder<List<sensor>>(
                            future: (DateStar != null && DateEnd != null)
                                ? fetchAllList(DateStar, DateEnd)
                                : null,
                            builder: (context, snapshot) {
                              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return Text(
                                  'ไม่พบข้อมูล',
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                  textAlign: TextAlign.center,
                                );
                              }
                              return SfCartesianChart(
                                primaryXAxis: CategoryAxis(
                                    title: AxisTitle(text: 'วันที่')),
                                primaryYAxis: NumericAxis(
                                    title: AxisTitle(text: 'Temperature (°C)')),
                                crosshairBehavior: CrosshairBehavior(
                                  enable: true,
                                  activationMode: ActivationMode.singleTap,
                                  lineWidth: 1.5,
                                ),
                                tooltipBehavior: TooltipBehavior(
                                  enable: true,
                                  header: "อุณหภูมิ",
                                  format:
                                      'วันที่: point.x \nอุณหภูมิ: point.y °C',
                                ),
                                series: <LineSeries<sensor, String>>[
                                  LineSeries<sensor, String>(
                                    dataSource: snapshot.data!,
                                    xValueMapper: (sensor data, _) =>
                                        data.sendDateTime ?? "N/A",
                                    yValueMapper: (sensor data, _) =>
                                        (data.temperature ?? 0),
                                    dataLabelSettings:
                                        DataLabelSettings(isVisible: false),
                                    markerSettings:
                                        MarkerSettings(isVisible: false),
                                    enableTooltip: true,
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.01,
                        right: MediaQuery.of(context).size.width * 0.01,
                        top: MediaQuery.of(context).size.height * 0.01,
                        bottom: MediaQuery.of(context).size.height * 0.01,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromARGB(200, 255, 255, 255),
                      ),
                      width: MediaQuery.of(context).size.width > 900
                          ? 800
                          : MediaQuery.of(context).size.width * 0.9,
                      child: Column(
                        children: [
                          Text(
                            "กราฟความชื้นในอากาศ",
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.02,
                            ),
                          ),
                          FutureBuilder<List<sensor>>(
                            future: (DateStar != null && DateEnd != null)
                                ? fetchAllList(DateStar, DateEnd)
                                : null,
                            builder: (context, snapshot) {
                              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return Text(
                                  'ไม่พบข้อมูล',
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                  textAlign: TextAlign.center,
                                );
                              }
                              return SfCartesianChart(
                                primaryXAxis: CategoryAxis(
                                    title: AxisTitle(text: 'วันที่')),
                                primaryYAxis: NumericAxis(
                                    title: AxisTitle(text: 'Humidity (%)')),
                                crosshairBehavior: CrosshairBehavior(
                                  enable: true,
                                  activationMode: ActivationMode.singleTap,
                                  lineWidth: 1.5,
                                ),
                                tooltipBehavior: TooltipBehavior(
                                  enable: true,
                                  header: "ค่าความชื้นในอากาศ",
                                  format:
                                      'วันที่: point.x \nค่าความชื้น: point.y %',
                                ),
                                series: <LineSeries<sensor, String>>[
                                  LineSeries<sensor, String>(
                                    dataSource: snapshot.data!,
                                    xValueMapper: (sensor data, _) =>
                                        data.sendDateTime ?? "N/A",
                                    yValueMapper: (sensor data, _) =>
                                        (data.humidity ?? 0),
                                    dataLabelSettings:
                                        DataLabelSettings(isVisible: false),
                                    markerSettings:
                                        MarkerSettings(isVisible: false),
                                    enableTooltip: true,
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          var value = await CallApi.orderCleaning("1");

                          if (value.isNotEmpty &&
                              value[0].status == "updated") {
                            showDialogMassage(
                                context, 'แจ้งเตือน', "สั่งทำความสะอาดสำเร็จ");
                            fetchOneList();
                          } else {
                            showDialogMassage(
                                context, 'แจ้งเตือน', "สั่งทำความสะอาดล้มเหลว");
                          }
                        } catch (e) {
                          showDialogMassage(
                              context, 'แจ้งเตือน', "เกิดข้อผิดพลาด: $e");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        textStyle: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      child: Text(
                        "สั่งทำความสะอาด",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          var value = await CallApi.orderCleaning("0");

                          if (value.isNotEmpty &&
                              value[0].status == "updated") {
                            showDialogMassage(context, 'แจ้งเตือน',
                                "สั่งหยุดทำความสะอาดสำเร็จ");
                            fetchOneList();
                          } else {
                            showDialogMassage(context, 'แจ้งเตือน',
                                "สั่งหยุดทำความสะอาดล้มเหลว");
                          }
                        } catch (e) {
                          showDialogMassage(
                              context, 'แจ้งเตือน', "เกิดข้อผิดพลาด: $e");
                          print("เกิดข้อผิดพลาด: $e");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        textStyle: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      child: Text(
                        "หยุดทำความสะอาด",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.01,
                    right: MediaQuery.of(context).size.width * 0.01,
                    top: MediaQuery.of(context).size.height * 0.01,
                    bottom: MediaQuery.of(context).size.height * 0.01,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromARGB(200, 255, 255, 255),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Cleaning Status :',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.02,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _cleaningText,
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.025,
                          color: _cleaningStatus == '1'
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget สำหรับสร้าง Card แสดงข้อมูล
  Widget _buildInfoCard(String title, String value) {
    return Container(
      width: 200,
      height: 100,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // ✅ จัดให้อยู่กึ่งกลางแนวตั้ง
          crossAxisAlignment:
              CrossAxisAlignment.center, // ✅ จัดให้อยู่กึ่งกลางแนวนอน
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center, // ✅ จัดข้อความกึ่งกลาง
            ),
            SizedBox(height: 5),
            Text(
              value,
              style: TextStyle(fontSize: 16, color: Colors.blue),
              textAlign: TextAlign.center, // ✅ จัดข้อความกึ่งกลาง
            ),
          ],
        ),
      ),
    );
  }
}
