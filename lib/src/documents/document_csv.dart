part of 'data_document.dart';

class DocumentCSV extends DataDocument<DocumentCSV, DataTableCSV> {
  final String? eol;
  final bool delimitAllFields;

  DocumentCSV({
    String? filePath,
    data,
    this.eol = '\n',
    this.delimitAllFields = true,
  }) : super(
          filePath: filePath,
          data: data,
          extension: 'csv',
          transcoder: TranscoderCSV(),
        );

  void addRow(DataRowCSV row) {
    _data.add(row);
  }

  void addRows(DataTableCSV rows) {
    _data.addAll(rows);
  }
}
