part of 'transcoder.dart';

class TranscoderExcel extends Transcoder<Excel> {
  @override
  Excel createData() {
    return Excel.createExcel();
  }

  @override
  Excel decodeData(DataSet dataSet) {
    final excel = createData();
    dataSet.forEach((sheetName, dataTable) {
      final sheet = excel.sheets[sheetName];
      dataTable.forEach((row) {
        sheet!.appendRow(row);
      });
    });
    excel.delete('Sheet1');
    return excel;
  }

  @override
  DataSet encodeData(Excel data) {
    return _transcodeDataSetExcel(data);
  }

  @override
  Future<Excel> readData(File file) async {
    final bytes = await file.readAsBytes();
    final excel = Excel.decodeBytes(bytes);
    return excel;
  }

  @override
  Future<void> writeData(File file, Excel data) async {
    final encodedExcel = data.encode();
    if (encodedExcel != null) {
      await file.writeAsBytes(encodedExcel);
    } else {
      throw Exception('Could not write _data.');
    }
  }

  @override
  DataSet? transcode(data) {
    if (data == null) return null;
    if (data is DataSetExcel) {
      return _transcodeDataSetExcel(data);
    }
    if (data is DataTableExcel) {
      return {
        'Default': _transcodeDataTableExcel(data),
      };
    }
    if (data is DataRowExcel) {
      return {
        'Default': [
          _transcodeDataRowExcel(data),
        ]
      };
    }
    return null;
  }

  DataSet _transcodeDataSetExcel(DataSetExcel data) {
    return {for (var sheetName in data.sheets.keys) sheetName: _transcodeDataTableExcel(data.sheets[sheetName]!)};
  }

  DataTable _transcodeDataTableExcel(Sheet sheet) {
    return sheet.rows.map((row) => row.map((cell) => cell == null ? null : cell.value).toList()).toList();
  }

  DataRow _transcodeDataRowExcel(DataRowExcel data) {
    return data;
  }
}
