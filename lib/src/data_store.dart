// TODO: Put public facing types in this file.

import 'dart:io';

import 'package:csv/csv.dart';
import 'package:excel/excel.dart';

part 'impl/csv_document.dart';
part 'impl/data_store_document.dart';
part 'impl/excel_document.dart';

class DataStore {
  static Future<ExcelDocument> openExcel(String filePath) async {
    final document = ExcelDocument(filePath);
    return await document.open();
  }

  static Future<T> openExcelThen<T>(String filePath, T Function(ExcelDocument document) action) async {
    final document = ExcelDocument(filePath);
    return action(await document.open());
  }

  static Future<ExcelDocument> createExcel([String? filePath]) async {
    final document = ExcelDocument(filePath);
    return document.create();
  }

  static Future<CsvDocument> openCsv(String filePath) async {
    final document = CsvDocument(filePath);
    return await document.open();
  }

  static Future<CsvDocument> createCsv([String? filePath]) async {
    final document = CsvDocument(filePath);
    return await document.create();
  }
}
