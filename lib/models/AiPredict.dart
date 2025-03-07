import 'package:intl/intl.dart';

class AiPredict {
  String? senserTime;
  String? RandomForest;
  String? KNN;
  String? NaiveBayes;
  String? DecisionTreet;

  AiPredict({
    this.senserTime,
    this.RandomForest,
    this.KNN,
    this.NaiveBayes,
    this.DecisionTreet,
  });

  AiPredict.fromJson(Map<String, dynamic> json) {
    if (json['senserTime'] != null &&
        json['senserTime'].toString().isNotEmpty) {
      DateTime parsedDate = DateTime.parse(json['senserTime']);
      senserTime = DateFormat('dd/MM/yyyy HH:mm:ss').format(parsedDate);
    } else {
      senserTime = "N/A"; // กรณีไม่มีค่า
    }
    RandomForest = json['RandomForest']?.toString() ?? "N/A";
    // RandomForest = (json['RandomForest'] as num?)?.toInt().toString() ?? "N/A";
    KNN = json['KNN']?.toString() ?? "N/A";
    // KNN = (json['KNN'] as num?)?.toInt().toString() ?? "N/A";
    NaiveBayes = json['NaiveBayes']?.toString() ?? "N/A";
    // NaiveBayes = (json['NaiveBayes'] as num?)?.toInt().toString() ?? "N/A";
    DecisionTreet = json['DecisionTreet']?.toString() ?? "N/A";
    // DecisionTreet = (json['DecisionTreet'] as num?)?.toInt().toString() ?? "N/A";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['senserTime'] = senserTime;
    data['RandomForest'] = RandomForest;
    data['KNN'] = KNN;
    data['NaiveBayes'] = NaiveBayes;
    data['DecisionTreet'] = DecisionTreet;

    return data;
  }
}
