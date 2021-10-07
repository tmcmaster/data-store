import 'dart:io';

import 'package:data_store/src/transcoders/transcoder.dart';
import 'package:excel/excel.dart';

part 'document_csv.dart';
part 'document_excel.dart';
part 'document_json.dart';

/// TODO: need to completed CSV implementation and add a JSON implementation
abstract class DataDocument<T, D> {
  List<String>? _schema;
  String? _filePath;
  late D _data;
  final String extension;
  final Transcoder<D> transcoder;

  DataDocument({
    String? filePath,
    List<String>? schema,
    data,
    required this.extension,
    required this.transcoder,
  }) {
    _schema = _generateSchema(schema);
    _filePath = _generateFilePath(filePath, data);
    _data = _generateData(data, schema);
  }

  String? _generateFilePath(String? filePath, dynamic data) {
    if (data is DataDocument) {
      if (data._filePath != null) {
        return _filePathWithNewExtension(data._filePath, extension);
      }
    }
    return filePath;
  }

  List<String>? _generateSchema(List<String>? schema) {
    return schema;
  }

  D _generateData(dynamic data, [List<String>? schema]) {
    final dataSet = Transcoder.convert(data);
    return transcoder.decodeData(dataSet);
  }

  Future<T> open([String? filePath]) async {
    if (filePath != null) _filePath = filePath;
    return reload();
  }

  Future<T> reload() async {
    if (_filePath == null) throw FileSystemException('No file path has been supplied.');
    final file = File(_filePath!);
    final exists = await file.exists();
    if (!exists) throw FileSystemException('File did not exist.', _filePath);
    final newData = await transcoder.readData(file) as Excel;
    print('new data: ${newData.tables.keys}');
    _data = newData as D;
    print('new _data: ${(_data as Excel).tables.keys}');
    return this as T;
  }

  Future<void> save() async {
    if (_data == null) throw Exception('Spreadsheet has not been created yet.');
    if (_filePath == null) throw FileSystemException('No file path has been supplied.');
    await transcoder.writeData(File(_filePath!), _data!);
  }

  Future<void> saveAs(String newFilePath) {
    _filePath = newFilePath;
    return save();
  }

  void close() {
    _filePath = null;
    _data = transcoder.createData();
  }

  DataSet toDataSet() {
    return transcoder.encodeData(_data);
  }

  void fromDataSet(DataSet dataSet) {
    _data = transcoder.decodeData(dataSet);
  }

  static String? _filePathWithNewExtension(String? filePath, String extension) {
    if (filePath == null) return null;
    final index = filePath.lastIndexOf('.');
    if (index < 0) {
      return '$filePath.$extension';
    } else {
      final pathWithoutExtension = filePath.substring(0, index);
      return '$pathWithoutExtension.$extension';
    }
  }
}
