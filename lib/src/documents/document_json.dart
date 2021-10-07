part of 'data_document.dart';

class DocumentJSON extends DataDocument<DocumentJSON, DataSetJSON> {
  DocumentJSON({
    String? filePath,
    DataSchema? schema,
    data,
  }) : super(
          filePath: filePath,
          data: data,
          extension: 'json',
          transcoder: TranscoderJSON(schema),
        );
}
