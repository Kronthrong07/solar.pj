import 'package:intl/intl.dart';

class cleaningHistory {
  String? message;
  String? status;
  String? cleaningDate;
  String? powerBefore;
  String? powerAfter;

  cleaningHistory({
    this.message,
    this.status,
    this.cleaningDate,
    this.powerBefore,
    this.powerAfter,
  });

  cleaningHistory.fromJson(Map<String, dynamic> json) {
    message = json['message']?.toString() ?? "";
    status = json['status']?.toString() ?? "";
    if (json['cleaningDate'] != null &&
        json['cleaningDate'].toString().isNotEmpty) {
      DateTime parsedDate = DateTime.parse(json['cleaningDate']);
      cleaningDate = DateFormat('dd/MM/yyyy HH:mm:ss').format(parsedDate);
    } else {
      cleaningDate = "N/A"; // กรณีไม่มีค่า
    }
    powerBefore =
        (json['PowerBefore'] as num?)?.toDouble().toStringAsFixed(3) ?? "0.000";
    powerAfter =
        (json['PowerAfter'] as num?)?.toDouble().toStringAsFixed(3) ?? "0.000";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['message'] = message;
    data['status'] = status;
    data['cleaningDate'] = cleaningDate;
    data['PowerBefore'] = powerBefore;
    data['PowerAfter'] = powerAfter;

    return data;
  }
}
