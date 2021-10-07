import 'package:data_store/src/documents/data_document.dart';
import 'package:test/test.dart';

void main() async {
  final inputFile = 'test_data/test_sheet_in.xlsx';
  final outputFile = 'test_data/test_sheet_out.xlsx';
  final sheetName = 'sheet';

  group('Test Excel Store', () {
    test('Get Sheet Names', () async {
      final excelDocument = await DocumentExcel(filePath: inputFile).open();
      final sheetNames = excelDocument.getSheetNames();
      print(sheetNames);
      expect(sheetNames.length, equals(2));
    });
    test('Set Sheet data', () async {
      final excelDocument = await DocumentExcel(filePath: inputFile).open();
      final sheetData = [
        ['a', 'b', 'c'],
        ['A', 'B', 'C'],
        ['1', '2', '3'],
      ];
      await excelDocument.sheetFromCSV(sheetName, sheetData);
    });
    test('Get Sheet data', () async {
      final excelDocument = await DocumentExcel(filePath: inputFile).open();
      final csvData = excelDocument.sheetToCSV(sheetName);
      expect(csvData.length, equals(3));
      expect(csvData[0][0], equals('a'));
      expect(csvData[2][2], equals('3'));
    });
    test('Rename Sheet', () async {
      final excelDocument = await DocumentExcel(filePath: inputFile).open();
      final originalName = 'Rename Me';
      final newName = 'Thanks';
      print(excelDocument.getSheetNames());
      excelDocument.renameSheet(originalName, newName);
      final sheetNames = excelDocument.getSheetNames();
      print(sheetNames);
      await excelDocument.saveAs(outputFile);
    });
    test('Delete Sheet', () async {
      final excelDocument = await DocumentExcel(filePath: inputFile).open();
      final beforeNames = excelDocument.getSheetNames();
      expect(beforeNames.length, equals(2));
      expect(beforeNames[0], 'sheet');
      expect(beforeNames[1], 'Rename Me');
      excelDocument.deleteSheet('sheet');
      final afterNames = excelDocument.getSheetNames();
      expect(afterNames.length, equals(1));
      expect(afterNames[0], 'Rename Me');
    });
    test('Save as new Document', () async {
      final excelDocument = await DocumentExcel().open(inputFile);
      await excelDocument.saveAs(outputFile);
    });
    test('Document as Map', () async {
      final excelDocument = await DocumentExcel(filePath: inputFile).open();
      final mapData = excelDocument.toDataSet();
      expect(mapData, isNotEmpty);
      final tabNames = mapData.keys;
      expect(tabNames.length, equals(2));
      print(mapData);
    });
    test('Document Sheet as List', () async {
      final excelDocument = await DocumentExcel(filePath: inputFile).open();
      final sheetCSV = excelDocument.sheetToCSV('sheet');
      expect(sheetCSV.length, equals(3));
      expect(sheetCSV[0].length, equals(3));
      print(sheetCSV);
    });

    test('Test addSheet', () async {
      final document = DocumentExcel();
      document
          .addSheet(
              title: 'A',
              csvData: [
                [1, 2, 3],
                [4, 5, 6],
                [7, 8, 9]
              ],
              clearFirst: true)
          .addSheet(title: 'B', csvData: [
        [9, 8, 7],
        [6, 5, 4],
        [3, 2, 1]
      ]);
      final sheetNames = document.getSheetNames();
      expect(sheetNames.length, equals(2));
      expect(sheetNames[0], equals('A'));
      expect(sheetNames[1], equals('B'));
    });

    test('Test addSheets', () async {
      final sheetData = {
        'C': [
          [1, 2, 3],
          [4, 5, 6],
          [7, 8, 9]
        ],
        'B': [
          [9, 8, 7],
          [6, 5, 4],
          [3, 2, 1]
        ],
        'A': [
          [7, 8, 9],
          [4, 5, 6],
          [1, 2, 3]
        ]
      };
      final document = DocumentExcel();
      final sheetOrder = ['A', 'B', 'C'];

      document.addSheets(sheetMap: sheetData, clearFirst: true);
      expect(document.getSheetNames().length, equals(sheetData.keys.length));
      expect(document.getSheetNames(), isNot(equals(sheetOrder)));

      document.addSheets(sheetMap: sheetData, order: sheetOrder, clearFirst: true);
      expect(document.getSheetNames().length, equals(sheetOrder.length));
      expect(document.getSheetNames(), equals(sheetOrder));
    });
  });
}
