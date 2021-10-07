import 'package:data_store/src/transcoders/transcoder.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  final row1 = [1, 2, 3];
  final row2 = [4, 5, 6];
  final row3 = [7, 8, 9];
  final table1 = [row1, row2, row3];
  final setName1 = 'Default';
  final set1 = {setName1: table1};

  final jsonTable = [
    {'one': 1, 'two': 2, 'three': 3},
    {'one': 4, 'two': 5, 'three': 6},
    {'one': 7, 'two': 8, 'three': 9},
  ];

  final jsonSet = {'Default': jsonTable};

  final csvTable = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9],
  ];

  final csvSet = {'Default': csvTable};

  group('Test DataConverter', () {
    test('From DataSet', () {
      final dataSet = Transcoder.convert(set1);
      expect(dataSet.keys.length, equals(1));
      expect(dataSet.containsKey(setName1), isTrue);
      expect(dataSet[setName1], isNotNull);
      expect(dataSet[setName1], equals(table1));
      expect(dataSet[setName1]!.length, equals(3));
    });
    test('From DataTable', () {
      final dataSet = Transcoder.convert(table1);
      expect(dataSet.keys.length, equals(1));
      expect(dataSet.containsKey(setName1), isTrue);
      expect(dataSet[setName1], isNotNull);
      expect(dataSet[setName1], equals(table1));
      expect(dataSet[setName1]!.length, equals(3));
    });
    test('From DataRow', () {
      final dataSet = Transcoder.convert(row1);
      expect(dataSet.keys.length, equals(1));
      expect(dataSet.containsKey(setName1), isTrue);
      expect(dataSet[setName1], isNotNull);
      expect(dataSet[setName1]!.length, equals(1));
      expect(dataSet[setName1]![0][1], equals(2));
    });
    test('From DataSetCSV', () {
      final transcoder = TranscoderCSV();
      final dataSet = transcoder.transcode(csvTable);
      expect(dataSet, isNotNull);
      expect(dataSet!.keys.length, equals(1));
      expect(dataSet.containsKey(setName1), isTrue);
      expect(dataSet[setName1], isNotNull);
      expect(dataSet[setName1], equals(table1));
      expect(dataSet[setName1]!.length, equals(3));
    });
    test('From DataTableCSV', () {
      final transcoder = TranscoderCSV();
      final dataSet = transcoder.transcode(csvTable);
      expect(dataSet, isNotNull);
      expect(dataSet!.keys.length, equals(1));
      expect(dataSet.containsKey(setName1), isTrue);
      expect(dataSet[setName1], isNotNull);
      expect(dataSet[setName1], equals(table1));
      expect(dataSet[setName1]!.length, equals(3));
    });
    test('From DataSetJSON', () {
      final transcoder = TranscoderJSON();
      final dataSet = transcoder.transcode(jsonSet);
      expect(dataSet, isNotNull);
      expect(dataSet!.keys.length, equals(1));
      expect(dataSet.containsKey(setName1), isTrue);
      expect(dataSet[setName1], isNotNull);
      expect(dataSet[setName1], equals(table1));
      expect(dataSet[setName1]!.length, equals(3));
    });
    test('From DataTableJSON', () {
      final transcoder = TranscoderJSON();
      final dataSet = transcoder.transcode(jsonTable);
      expect(dataSet, isNotNull);
      expect(dataSet!.keys.length, equals(1));
      expect(dataSet.containsKey(setName1), isTrue);
      expect(dataSet[setName1], isNotNull);
      expect(dataSet[setName1], equals(table1));
      expect(dataSet[setName1]!.length, equals(3));
    });
  });
}
