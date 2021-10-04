part of '../data_store.dart';

abstract class DataStoreDocument<T, D, F> {
  D? _data;
  String? _filePath;

  DataStoreDocument(this._filePath);

  Future<T> open() async {
    if (_data != null) return this as T;
    return reload();
  }

  Future<T> reload() async {
    _data = null;
    if (_filePath == null) throw FileSystemException('No file path has been supplied.');
    final file = File(_filePath!);
    final exists = await file.exists();
    if (!exists) throw FileSystemException('File did not exist.', _filePath);
    final newData = await read(file) as Excel;
    print('new data: ${newData.tables.keys}');
    _data = newData as D;
    print('new _data: ${(_data as Excel).tables.keys}');
    return this as T;
  }

  Future<void> save() async {
    if (_data == null) throw Exception('Spreadsheet has not been created yet.');
    if (_filePath == null) throw FileSystemException('No file path has been supplied.');
    await write(File(_filePath!), _data!);
  }

  Future<void> saveAs(String newFilePath) {
    _filePath = newFilePath;
    return save();
  }

  void close() {
    _data = null;
  }

  T create();
  Future<D> read(File file);
  Future<void> write(File file, D data);
}
