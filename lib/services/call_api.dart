// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:solar_pj/models/AiPredict.dart';
import 'package:solar_pj/models/cleaningHistory.dart';
import 'package:solar_pj/models/sensor.dart';
import 'package:solar_pj/models/user.dart';
import 'package:solar_pj/utils/env.dart';

class CallApi {
  //login ได้ใช่ไหม
  static Future<List<User>> CheckLoginApi(User user) async {
    final responseData = await http.post(
      Uri.parse('${Env.baseUrl}/check_login_api.php'),
      body: jsonEncode(user.toJson()),
      headers: {"Content-Type": "application/json"},
    );
    if (responseData.statusCode == 200) {
      //แปลงข้อมูลที่ส่งกลับมาจาก JSON เพื่อใช้ในแอปฯ
      final responseDataDecode = jsonDecode(responseData.body);
      List<User> data = await responseDataDecode
          .map<User>((json) => User.fromJson(json))
          .toList();
      //ส่งค่าข้อมูลที่ได้ไปยังจุดที่เรียกใช้เมธอด
      return data;
    } else {
      throw Exception('Failed to .... login');
    }
  }

  static Future<List<User>> RegisterAPI(User user) async {
    print("Sending data: ${jsonEncode(user.toJson())}");

    final responseData = await http.post(
      Uri.parse('${Env.baseUrl}/insert_new_user_api.php'),
      body: jsonEncode(user.toJson()),
      headers: {"Content-Type": "application/json"},
    );

    print("Response Status: ${responseData.statusCode}");
    print("Response Body: ${responseData.body}");

    if (responseData.statusCode == 200) {
      final decodedData = jsonDecode(responseData.body);
      return decodedData is List
          ? decodedData.map<User>((json) => User.fromJson(json)).toList()
          : throw Exception("Unexpected response format");
    } else {
      throw Exception(
          "Failed to registe3r. Status: ${responseData.statusCode}");
    }
  }

  static Future<List<User>> editUser(User user) async {
    // print("Sending data: ${jsonEncode(user.toJson())}");

    final responseData = await http.post(
      Uri.parse('${Env.baseUrl}/update_user.php'),
      body: jsonEncode(user.toJson()),
      headers: {"Content-Type": "application/json"},
    );

    // print("Response Status: ${responseData.statusCode}");
    // print("Response Body: ${responseData.body}");

    if (responseData.statusCode == 200) {
      final decodedData = jsonDecode(responseData.body);
      return decodedData is List
          ? decodedData.map<User>((json) => User.fromJson(json)).toList()
          : throw Exception("Unexpected response format");
    } else {
      throw Exception(
          "Failed to registe3r. Status: ${responseData.statusCode}");
    }
  }

  static Future<List<cleaningHistory>> getCleaningHistory() async {
    final responseData = await http.get(
      Uri.parse('${Env.baseUrl}/cleaningHistory.php'),
      headers: {"Content-Type": "application/json"},
    );
    // print("Response Body: ${responseData.body}");
    if (responseData.statusCode == 200) {
      //แปลงข้อมูลที่ส่งกลับมาจาก JSON เพื่อใช้ในแอปฯ
      final responseDataDecode = jsonDecode(responseData.body);
      List<cleaningHistory> data = await responseDataDecode
          .map<cleaningHistory>((json) => cleaningHistory.fromJson(json))
          .toList();
      //ส่งค่าข้อมูลที่ได้ไปยังจุดที่เรียกใช้เมธอด
      return data;
    } else {
      throw Exception('Failed to .... login');
    }
  }

  static Future<List<sensor>> getOneData() async {
    final responseData = await http.get(
      Uri.parse('${Env.baseUrl}/get_one_data.php'),
      headers: {"Content-Type": "application/json"},
    );
    if (responseData.statusCode == 200) {
      //แปลงข้อมูลที่ส่งกลับมาจาก JSON เพื่อใช้ในแอปฯ
      final responseDataDecode = jsonDecode(responseData.body);
      List<sensor> data = await responseDataDecode
          .map<sensor>((json) => sensor.fromJson(json))
          .toList();
      //ส่งค่าข้อมูลที่ได้ไปยังจุดที่เรียกใช้เมธอด
      return data;
    } else {
      throw Exception('Failed to .... login');
    }
  }

  static Future<List<sensor>> getAllData(
      String? startDate, String? endDate) async {
    final responseData = await http.post(
      Uri.parse('${Env.baseUrl}/get_all_data_by_date.php'),
      body: jsonEncode({"startDate": startDate, "endDate": endDate}),
      headers: {"Content-Type": "application/json"},
    );
    // print("Response Body: ${responseData.body}");
    if (responseData.statusCode == 200) {
      //แปลงข้อมูลที่ส่งกลับมาจาก JSON เพื่อใช้ในแอปฯ
      final responseDataDecode = jsonDecode(responseData.body);
      List<sensor> data = await responseDataDecode
          .map<sensor>((json) => sensor.fromJson(json))
          .toList();
      //ส่งค่าข้อมูลที่ได้ไปยังจุดที่เรียกใช้เมธอด
      return data;
    } else {
      throw Exception('Failed to .... login');
    }
  }

  static Future<List<cleaningHistory>> getCleaningStatus() async {
    final responseData = await http.get(
      Uri.parse('${Env.baseUrl}/cleanning_web.php'),
      headers: {"Content-Type": "application/json"},
    );

    // print("Response Body: ${responseData.body}");
    if (responseData.statusCode == 200) {
      //แปลงข้อมูลที่ส่งกลับมาจาก JSON เพื่อใช้ในแอปฯ
      final responseDataDecode = jsonDecode(responseData.body);
      List<cleaningHistory> data = await responseDataDecode
          .map<cleaningHistory>((json) => cleaningHistory.fromJson(json))
          .toList();
      //ส่งค่าข้อมูลที่ได้ไปยังจุดที่เรียกใช้เมธอด
      return data;
    } else {
      throw Exception('Failed to .... login');
    }
  }

  static Future<List<cleaningHistory>> orderCleaning(String? Clean) async {
    final responseData = await http.post(
      Uri.parse('${Env.baseUrl}/cleanning_api.php'),
      body: jsonEncode({"Clean": Clean}),
      headers: {"Content-Type": "application/json"},
    );
    // print("Response Body: ${responseData.body}");
    if (responseData.statusCode == 200) {
      //แปลงข้อมูลที่ส่งกลับมาจาก JSON เพื่อใช้ในแอปฯ
      final responseDataDecode = jsonDecode(responseData.body);
      List<cleaningHistory> data = await responseDataDecode
          .map<cleaningHistory>((json) => cleaningHistory.fromJson(json))
          .toList();
      //ส่งค่าข้อมูลที่ได้ไปยังจุดที่เรียกใช้เมธอด
      return data;
    } else {
      throw Exception('Failed to .... login');
    }
  }

  static Future<List<AiPredict>> latestAiPredict() async {
    final responseData = await http.get(
      Uri.parse('${Env.baseUrl}/latest_prediction_results.php'),
      headers: {"Content-Type": "application/json"},
    );
    print("Response Body: ${responseData.body}");
    if (responseData.statusCode == 200) {
      //แปลงข้อมูลที่ส่งกลับมาจาก JSON เพื่อใช้ในแอปฯ
      final responseDataDecode = jsonDecode(responseData.body);
      List<AiPredict> data = await responseDataDecode
          .map<AiPredict>((json) => AiPredict.fromJson(json))
          .toList();
      //ส่งค่าข้อมูลที่ได้ไปยังจุดที่เรียกใช้เมธอด
      return data;
    } else {
      throw Exception('Failed to .... login');
    }
  }

  static Future<List<AiPredict>> AiPredictAll() async {
    final responseData = await http.get(
      Uri.parse('${Env.baseUrl}/ai_predict_all.php'),
      headers: {"Content-Type": "application/json"},
    );
    print("Response Body: ${responseData.body}");
    if (responseData.statusCode == 200) {
      //แปลงข้อมูลที่ส่งกลับมาจาก JSON เพื่อใช้ในแอปฯ
      final responseDataDecode = jsonDecode(responseData.body);
      List<AiPredict> data = await responseDataDecode
          .map<AiPredict>((json) => AiPredict.fromJson(json))
          .toList();
      //ส่งค่าข้อมูลที่ได้ไปยังจุดที่เรียกใช้เมธอด
      return data;
    } else {
      throw Exception('Failed to .... login');
    }
  }
}
