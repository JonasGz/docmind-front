import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'wire')
enum DocumentStatus {
  uploaded('uploaded'),
  processing('processing'),
  indexed('indexed'),
  failed('failed'),

  unknown('unknown');

  const DocumentStatus(this.wire);

  final String wire;

  static DocumentStatus fromWire(String? value) {
    return DocumentStatus.values.firstWhere(
      (status) => status.wire == value,
      orElse: () => DocumentStatus.unknown,
    );
  }

  bool get isPending =>
      this == DocumentStatus.uploaded || this == DocumentStatus.processing;

  bool get isReady => this == DocumentStatus.indexed;

  bool get hasFailed => this == DocumentStatus.failed;
}
