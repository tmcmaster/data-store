part of '../data_store.dart';

class ExcelDocument extends DataStoreDocument<ExcelDocument, Excel, List<List<dynamic>>> {
  ExcelDocument(filePath) : super(filePath);

  @override
  ExcelDocument create() {
    if (_data != null) return this;
    _data = Excel.createExcel();
    return this;
  }

  @override
  Future<Excel> read(File file) async {
    final bytes = await file.readAsBytes();
    final excel = Excel.decodeBytes(bytes);
    return excel;
  }

  @override
  Future<void> write(File file, Excel _data) async {
    final encodedExcel = _data.encode();
    if (encodedExcel != null) {
      await file.writeAsBytes(encodedExcel);
    } else {
      throw Exception('Could not write _data.');
    }
  }

  List<String> getSheetNames() {
    return _data == null ? [] : _data!.tables.keys.toList();
  }

  Map<String, List<List<dynamic>>> toMap() {
    if (_data == null) return <String, List<List<dynamic>>>{};
    final sheetNames = getSheetNames();
    return {for (var sheetName in sheetNames) sheetName: sheetToCSV(sheetName)};
  }

  ExcelDocument addSheets({
    required Map<String, List<List<dynamic>>> sheetMap,
    List<String>? order,
    bool clearFirst = false,
  }) {
    if (_data == null) throw Exception('Spreadsheet has not been created yet.');
    final titles = order ?? sheetMap.keys;
    if (clearFirst) clearSheet();
    titles.forEach((title) => addSheet(title: title, csvData: sheetMap[title] ?? []));
    if (clearFirst) deleteSheet('Sheet1');
    return this;
  }

  ExcelDocument addSheet({
    required String title,
    required List<List<dynamic>> csvData,
    bool clearFirst = false,
  }) {
    if (_data == null) throw Exception('Spreadsheet has not been created yet.');
    if (clearFirst) clearSheet();
    renameSheet('Sheet1', title);
    final sheet = _data![title];
    csvData.forEach((row) => sheet.appendRow(row));
    if (clearFirst) deleteSheet('Sheet1');
    return this;
  }

  ExcelDocument clearSheet() {
    final sheetNames = getSheetNames();
    _data!['Sheet1'];
    sheetNames.forEach((sheetName) => deleteSheet(sheetName));
    return this;
  }

  List<List<dynamic>> sheetToCSV(String sheetName) {
    if (_data == null) return <List<dynamic>>[];
    if (!sheetExists(sheetName)) return <List<dynamic>>[];
    final sheet = _data![sheetName];
    return sheet.rows.map((row) => row.map((_data) => _data == null ? null : _data.value).toList()).toList();
  }

  bool sheetExists(String sheetName) {
    final sheetNames = getSheetNames();
    return sheetNames.contains(sheetName);
  }

  void deleteSheet(String sheetName) {
    if (_data == null) return;
    if (!sheetExists(sheetName)) return;
    _data!.delete(sheetName);
  }

  void renameSheet(String originalSheetName, String newSheetName) {
    if (_data == null) return;
    if (!sheetExists(originalSheetName)) return;
    _data!.rename(originalSheetName, newSheetName);
  }

  Future<void> sheetFromCSV(String sheetName, List<List<dynamic>> csvData) async {
    if (_data == null) return;
    if (sheetExists(sheetName)) {
      deleteSheet(sheetName);
    }
    final sheet = _data!.sheets[sheetName];
    if (sheet != null) {
      csvData.forEach((row) {
        sheet.appendRow(row);
      });
    }
  }
}
