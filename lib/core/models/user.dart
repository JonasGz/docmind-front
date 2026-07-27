import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// Espelha `UserResponse` do backend (`app/schemas/auth.py`).
///
/// Fica em `core/models` porque é consumido por mais de uma feature: a tela
/// de ajustes exibe o perfil e a sessão precisa dele para o cabeçalho.
@freezed
abstract class User with _$User {
  const factory User({
    required String id,
    required String email,
    required String? name,
    required DateTime createdAt,
  }) = _User;

  const User._();

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// Nome a exibir — contas Google normalmente têm nome, mas o backend
  /// permite nulo.
  String get displayName => name ?? email;

  /// Iniciais para o avatar do card de perfil: "Marina Barros" → "MB".
  String get initials {
    final parts = displayName.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return parts.first.characters.take(2).toString().toUpperCase();
    }
    return '${parts.first.characters.first}${parts.last.characters.first}'
        .toUpperCase();
  }
}
