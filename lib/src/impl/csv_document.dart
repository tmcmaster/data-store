part of '../data_store.dart';

class CsvDocument extends DataStoreDocument<CsvDocument, List<List<dynamic>>, List<List<dynamic>>> {
  final String? eol;
  final bool delimitAllFields;

  CsvDocument(
    String? filePath, {
    this.eol = '\n',
    this.delimitAllFields = true,
  }) : super(filePath);

  @override
  CsvDocument create() {
    if (_data != null) return this;
    _data = [];
    return this;
  }

  @override
  Future<void> write(File file, List<List<dynamic>> data) async {
    final csvString = ListToCsvConverter(
      delimitAllFields: delimitAllFields,
    ).convert(data);
    await file.writeAsString(csvString);
  }

  @override
  Future<List<List<dynamic>>> read(File file) async {
    final contents = await file.readAsString();
    return CsvToListConverter(eol: eol).convert(contents);
  }
}
