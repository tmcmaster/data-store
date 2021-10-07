import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:data_store/src/documents/data_document.dart';
import 'package:excel/excel.dart';

part 'transcoder_csv.dart';
part 'transcoder_excel.dart';
part 'transcoder_json.dart';

typedef DataRow = List<dynamic>;
typedef DataTable = List<DataRow>;
typedef DataSet = Map<String, DataTable>;

typedef DataSchema = List<String>;

typedef DataRowCSV = DataRow;
typedef DataTableCSV = DataTable;
typedef DataSetCSV = DataSet;

typedef DataRowExcel = List<dynamic>;
typedef DataTableExcel = Sheet;
typedef DataSetExcel = Excel;

typedef DataRowJSON = Map<String, dynamic>;
typedef DataTableJSON = List<DataRowJSON>;
typedef DataSetJSON = Map<String, DataTableJSON>;

abstract class Transcoder<D> {
  static DataSet convert(data) {
    if (data is DataDocument) {
      return data.toDataSet();
    } else if (data is DataSet) {
      return data;
    } else if (data is DataTable) {
      return {
        'Default': data,
      };
    } else if (data is DataRow) {
      return {
        'Default': [
          data,
        ],
      };
    } else {
      return {};
    }
  }

  D decodeData(DataSet dataSet);
  DataSet encodeData(D data);
  D createData();
  Future<D> readData(File file);
  Future<void> writeData(File file, D data);
  DataSet? transcode(data);
}
