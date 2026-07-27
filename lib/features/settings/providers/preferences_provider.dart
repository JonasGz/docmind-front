import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'preferences_provider.g.dart';

/// Preferências locais de exibição. Não vão para o backend — ele sempre
/// retorna as fontes; o que muda é se a tela as mostra.
@Riverpod(keepAlive: true)
class CiteSourcesPreference extends _$CiteSourcesPreference {
  static const _key = 'cite_sources';

  @override
  Future<bool> build() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? true;
  }

  Future<void> toggle(bool value) async {
    state = AsyncData(value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, value);
  }
}
