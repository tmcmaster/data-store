part of 'transcoder.dart';

class TranscoderJSON extends Transcoder<DataSetJSON> {
  DataSchema? schema;
  TranscoderJSON([this.schema]);

  @override
  DataSetJSON createData() {
    return {};
  }

  @override
  DataSetJSON decodeData(DataSet dataSet) {
    return {};
  }

  @override
  DataSet encodeData(DataSetJSON data) {
    return transcodeDataSetJSON(data, schema);
  }

  @override
  Future<DataSetJSON> readData(File file) async {
    final contents = await file.readAsString();
    final json = jsonDecode(contents);
    if (json is DataSetJSON) {
      return json;
    } else if (json is DataTableJSON) {
      return {
        'Default': json,
      };
    } else if (json is DataRowJSON) {
      return {
        'Default': [json],
      };
    } else {
      throw Exception('File did not seem to be the right format: ${file.absolute}');
    }
  }

  @override
  Future<void> writeData(File file, DataSetJSON data) async {
    await file.writeAsString(jsonEncode(data));
  }

  @override
  DataSet? transcode(data) {
    if (data == null) return null;
    if (data is DataSetJSON) {
      return transcodeDataSetJSON(data, schema);
    }
    if (data is DataTableJSON) {
      return {
        'Default': transcodeDataTableJSON(data, schema),
      };
    }
    if (data is DataRowJSON) {
      return {
        'Default': [
          transcodeDataRowJSON(data, schema),
        ]
      };
    }
    return null;
  }

  static DataSet transcodeDataSetJSON(DataSetJSON data, [DataSchema? schema]) {
    return {for (var key in data.keys) key: transcodeDataTableJSON(data[key]!, schema)};
  }

  static DataTable transcodeDataTableJSON(DataTableJSON data, [DataSchema? schema]) {
    return data.map((row) => transcodeDataRowJSON(row, schema)).toList();
  }

  static DataRow transcodeDataRowJSON(DataRowJSON data, [DataSchema? schema]) {
    final fields = schema ?? data.keys;
    return fields.map((field) => data[field]).toList();
  }
}
