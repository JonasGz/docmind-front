import 'package:json_annotation/json_annotation.dart';

/// Espelha `MessageRole` do backend (`app/models/message.py`).
@JsonEnum(valueField: 'wire')
enum MessageRole {
  user('user'),
  assistant('assistant');

  const MessageRole(this.wire);

  final String wire;

  bool get isUser => this == MessageRole.user;
}
