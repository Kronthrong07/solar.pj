// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import, sort_child_properties_last
//โค้ดที่2
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:solar_pj/models/cleaningHistory.dart';
import 'package:solar_pj/services/call_api.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<GridColumn> getColumns() {
    return <GridColumn>[
      GridColumn(
        columnName: 'cleaningDate',
        label: Container(
          color: Color.fromARGB(255, 90, 90, 90),
          child: Text(
            'วันที่และเวลา\nที่ทำความสะอาด',
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
        columnName: 'PowerBefore',
        label: Container(
          color: Color.fromARGB(255, 90, 90, 90),
          child: Text(
            'กำลังไฟฟ้าก่อน\nที่จะทำความสะอาด',
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
        columnName: 'PowerAfter',
        label: Container(
          color: Color.fromARGB(255, 90, 90, 90),
          child: Text(
            'กำลังไฟฟ้าหลัง\nจากทำความสะอาด',
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
    return ShowDataGridSource(await CallApi.getCleaningHistory());
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
                      Icons.history,
                      size: MediaQuery.of(context).size.height * 0.04,
                    ),
                    Text(
                      "\tประวัติการทำความสะอาด",
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
  late List<cleaningHistory> _dataShow;

  void buildDataGridRows() {
    _dataGridRows = _dataShow.map<DataGridRow>((dataShow) {
      return DataGridRow(cells: [
        DataGridCell<String>(
            columnName: 'cleaningDate', value: dataShow.cleaningDate),
        DataGridCell<String>(
            columnName: 'PowerBefore', value: dataShow.powerBefore),
        DataGridCell<String>(
            columnName: 'PowerAfter', value: dataShow.powerAfter),
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
          ? Color.fromARGB(255, 0, 238, 255)
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
      ],
    );
  }
}
