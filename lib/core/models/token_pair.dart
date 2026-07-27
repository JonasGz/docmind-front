import 'package:freezed_annotation/freezed_annotation.dart';

part 'token_pair.freezed.dart';
part 'token_pair.g.dart';

/// Espelha `TokenPair` do backend (`app/schemas/auth.py`).
///
/// Guardado em `flutter_secure_storage`. O `refreshToken` é usado pelo
/// interceptor do Dio quando o access token expira.
@freezed
abstract class TokenPair with _$TokenPair {
  const factory TokenPair({
    required String accessToken,
    required String refreshToken,
    @Default('bearer') String tokenType,
  }) = _TokenPair;

  factory TokenPair.fromJson(Map<String, dynamic> json) =>
      _$TokenPairFromJson(json);
}
