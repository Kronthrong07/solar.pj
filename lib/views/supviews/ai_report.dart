// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import, sort_child_properties_last
//โค้ดที่2
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:solar_pj/models/AiPredict.dart';
import 'package:solar_pj/services/call_api.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class AiReport extends StatefulWidget {
  const AiReport({super.key});

  @override
  State<AiReport> createState() => _AiReportState();
}

class _AiReportState extends State<AiReport> {
  List<GridColumn> getColumns() {
    return <GridColumn>[
      GridColumn(
        columnName: 'senserTime',
        label: Container(
          color: Color.fromARGB(255, 90, 90, 90),
          child: Text(
            'วันที่และเวลา\nที่ข้อมูลถูกส่งมา',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
            overflow: TextOverflow.visible,
            textAlign: TextAlign.center,
            softWrap: true,
            maxLines: null,
          ),
          alignment: Alignment.center,
          padding: EdgeInsets.all(8.0),
        ),
      ),
      GridColumn(
        columnName: 'KNN',
        label: Container(
          color: Color.fromARGB(255, 90, 90, 90),
          child: Text(
            'IA model KNN',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
            overflow: TextOverflow.visible,
            textAlign: TextAlign.center,
            softWrap: true,
            maxLines: null,
          ),
          alignment: Alignment.center,
          padding: EdgeInsets.all(8.0),
        ),
      ),
      GridColumn(
        columnName: 'RandomForest',
        label: Container(
          color: Color.fromARGB(255, 90, 90, 90),
          child: Text(
            'IA model Random Forest',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
            overflow: TextOverflow.visible,
            textAlign: TextAlign.center,
            softWrap: true,
            maxLines: null,
          ),
          alignment: Alignment.center,
          padding: EdgeInsets.all(8.0),
        ),
      ),
      GridColumn(
        columnName: 'DecisionTree',
        label: Container(
          color: Color.fromARGB(255, 90, 90, 90),
          child: Text(
            'IA model Decision Tree',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
            overflow: TextOverflow.visible,
            textAlign: TextAlign.center,
            softWrap: true,
            maxLines: null,
          ),
          alignment: Alignment.center,
          padding: EdgeInsets.all(8.0),
        ),
      ),
      GridColumn(
        columnName: 'NaiveBayes',
        label: Container(
          color: Color.fromARGB(255, 90, 90, 90),
          child: Text(
            'IA model Naive Bayes',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
            overflow: TextOverflow.visible,
            textAlign: TextAlign.center,
            softWrap: true,
            maxLines: null,
          ),
          alignment: Alignment.center,
          padding: EdgeInsets.all(8.0),
        ),
      ),
    ];
  }

  Future<ShowDataGridSource> getHistory() async {
    return ShowDataGridSource(await CallApi.AiPredictAll());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // padding: EdgeInsets.all(50),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/WobBG.png'),
            // fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                  color: Color.fromARGB(125, 255, 255, 255),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.microchip,
                      size: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Text(
                      "\tผลการทำนายของ AI",
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.025,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.25,
                  right: MediaQuery.of(context).size.width * 0.25,
                  top: MediaQuery.of(context).size.height * 0.05,
                  bottom: MediaQuery.of(context).size.height * 0.05,
                ),
                child: FutureBuilder(
                  future: getHistory(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                          child: Text("เกิดข้อผิดพลาด: ${snapshot.error}"));
                    } else if (!snapshot.hasData ||
                        snapshot.data!.rows.isEmpty) {
                      return Center(child: Text("ไม่มีข้อมูลการทำความสะอาด"));
                    } else {
                      return SfDataGrid(
                        source: snapshot.data,
                        columns: getColumns(),
                        columnWidthMode: ColumnWidthMode.fill,
                        gridLinesVisibility: GridLinesVisibility.both,
                        headerGridLinesVisibility: GridLinesVisibility.both,
                      );
                    }
                  },
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}

class ShowDataGridSource extends DataGridSource {
  late List<DataGridRow> _dataGridRows;
  late List<AiPredict> _dataShow;

  void buildDataGridRows() {
    _dataGridRows = _dataShow.map<DataGridRow>((dataShow) {
      return DataGridRow(cells: [
        DataGridCell<String>(
            columnName: 'senserTime', value: dataShow.senserTime),
        DataGridCell<String>(
            columnName: 'KNN',
            value: dataShow.KNN == "N/A" ? "N/A" : "-${dataShow.KNN}%"),
        DataGridCell<String>(
            columnName: 'RandomForest',
            value: dataShow.RandomForest == "1"
                ? "-15%"
                : dataShow.RandomForest == "2"
                    ? "-30%"
                    : dataShow.RandomForest == "0"
                        ? "-0%"
                        : "N/A"),
        DataGridCell<String>(
            columnName: 'DecisionTreet',
            value: dataShow.DecisionTreet == "1"
                ? "-15%"
                : dataShow.DecisionTreet == "2"
                    ? "-30%"
                    : dataShow.DecisionTreet == "0"
                        ? "-0%"
                        : "N/A"),
        DataGridCell<String>(
            columnName: 'NaiveBayes',
            value: dataShow.NaiveBayes == "1"
                ? "-15%"
                : dataShow.NaiveBayes == "2"
                    ? "-30%"
                    : dataShow.NaiveBayes == "0"
                        ? "-0%"
                        : "N/A"),
      ]);
    }).toList(growable: false);
  }

  ShowDataGridSource(this._dataShow) {
    buildDataGridRows();
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      color: effectiveRows.indexOf(row) % 2 == 0
          ? Color.fromARGB(255, 77, 249, 255)
          : Color.fromARGB(255, 238, 241, 241),
      cells: [
        Container(
          child: Text(
            row.getCells()[0].value.toString(),
            style: TextStyle(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
          alignment: Alignment.center,
          padding: EdgeInsets.all(8.0),
        ),
        Container(
          child: Text(
            row.getCells()[1].value.toString(),
            style: TextStyle(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
          alignment: Alignment.center,
          padding: EdgeInsets.all(8.0),
        ),
        Container(
          child: Text(
            row.getCells()[2].value.toString(),
            style: TextStyle(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
          alignment: Alignment.center,
          padding: EdgeInsets.all(8.0),
        ),
        Container(
          child: Text(
            row.getCells()[3].value.toString(),
            style: TextStyle(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
          alignment: Alignment.center,
          padding: EdgeInsets.all(8.0),
        ),
        Container(
          child: Text(
            row.getCells()[4].value.toString(),
            style: TextStyle(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
          alignment: Alignment.center,
          padding: EdgeInsets.all(8.0),
        ),
      ],
    );
  }
}
