import 'package:data_store/data_store.dart';

void main() async {
  final excelDocument = await DataStore.openExcel('test_data/test_sheet_in.xlsx');
}
