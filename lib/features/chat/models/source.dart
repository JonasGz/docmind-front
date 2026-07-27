import 'package:freezed_annotation/freezed_annotation.dart';

part 'source.freezed.dart';
part 'source.g.dart';

@freezed
abstract class Source with _$Source {
  const factory Source({
    required String documentId,
    required String documentTitle,

    required int page,

    required double score,

    required String excerpt,
  }) = _Source;

  const Source._();

  factory Source.fromJson(Map<String, dynamic> json) => _$SourceFromJson(json);

  String get label => '$documentTitle · pág. $page';

  String get scoreLabel => '${(score * 100).round()}%';
}
