part of 'data_document.dart';

class DocumentExcel extends DataDocument<DocumentExcel, Excel> {
  DocumentExcel({
    String? filePath,
    data,
  }) : super(
          filePath: filePath,
          data: data,
          extension: 'xlsx',
          transcoder: TranscoderExcel(),
        );

  List<String> getSheetNames() {
    return _data.tables.keys.toList();
  }

  DocumentExcel addSheets({
    required Map<String, List<List<dynamic>>> sheetMap,
    List<String>? order,
    bool clearFirst = false,
  }) {
    final titles = order ?? sheetMap.keys;
    if (clearFirst) clearSheet();
    titles.forEach((title) => addSheet(title: title, csvData: sheetMap[title] ?? []));
    if (clearFirst) deleteSheet('Sheet1');
    return this;
  }

  DocumentExcel addSheet({
    required String title,
    required List<List<dynamic>> csvData,
    bool clearFirst = false,
  }) {
    if (clearFirst) clearSheet();
    renameSheet('Sheet1', title);
    final sheet = _data[title];
    csvData.forEach((row) => sheet.appendRow(row));
    if (clearFirst) deleteSheet('Sheet1');
    return this;
  }

  DocumentExcel clearSheet() {
    _data = transcoder.createData();
    return this;
  }

  List<List<dynamic>> sheetToCSV(String sheetName) {
    if (!sheetExists(sheetName)) return <List<dynamic>>[];
    final sheet = _data[sheetName];
    return sheet.rows.map((row) => row.map((_data) => _data == null ? null : _data.value).toList()).toList();
  }

  bool sheetExists(String sheetName) {
    final sheetNames = getSheetNames();
    return sheetNames.contains(sheetName);
  }

  void deleteSheet(String sheetName) {
    if (!sheetExists(sheetName)) return;
    _data.delete(sheetName);
  }

  void renameSheet(String originalSheetName, String newSheetName) {
    if (!sheetExists(originalSheetName)) return;
    _data.rename(originalSheetName, newSheetName);
  }

  Future<void> sheetFromCSV(String sheetName, DataTable csvData) async {
    if (sheetExists(sheetName)) {
      deleteSheet(sheetName);
    }
    final sheet = _data.sheets[sheetName];
    if (sheet != null) {
      csvData.forEach((row) {
        sheet.appendRow(row);
      });
    }
  }
}
