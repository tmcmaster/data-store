part of 'transcoder.dart';

class TranscoderCSV extends Transcoder<DataTableCSV> {
  final String? eol;
  final bool delimitAllFields;

  TranscoderCSV({
    this.eol = '\n',
    this.delimitAllFields = true,
  });

  @override
  DataTableCSV createData() {
    return [];
  }

  @override
  DataTableCSV decodeData(DataSet dataSet) {
    final listData = dataSet.isEmpty ? [] : dataSet.values.first;
    final csvDataTable = listData.map((row) => row as DataRowCSV).toList();
    return [...csvDataTable];
  }

  @override
  DataSet encodeData(DataTableCSV data) {
    return {'Default': _transcodeDataTableCSV(data)};
  }

  @override
  Future<DataTableCSV> readData(File file) async {
    final contents = await file.readAsString();
    return CsvToListConverter(eol: eol).convert(contents);
  }

  @override
  Future<void> writeData(File file, DataTableCSV data) async {
    final csvString = ListToCsvConverter(
      delimitAllFields: delimitAllFields,
    ).convert(data);
    await file.writeAsString(csvString);
  }

  @override
  DataSet? transcode(data) {
    if (data == null) return null;
    if (data is DataSetCSV) {
      return _transcodeDataSetCSV(data);
    }
    if (data is DataTableCSV) {
      return {
        'Default': _transcodeDataTableCSV(data),
      };
    }
    if (data is DataRowCSV) {
      return {
        'Default': [
          _transcodeDataRowCSV(data),
        ]
      };
    }
    return null;
  }

  DataSet _transcodeDataSetCSV(DataSetCSV data) {
    return data;
  }

  DataTable _transcodeDataTableCSV(DataTableCSV data) {
    return data;
  }

  DataRow _transcodeDataRowCSV(DataRowCSV data) {
    return data;
  }
}
