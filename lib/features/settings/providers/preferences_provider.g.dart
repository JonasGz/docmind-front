// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferences_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Preferências locais de exibição. Não vão para o backend — ele sempre
/// retorna as fontes; o que muda é se a tela as mostra.

@ProviderFor(CiteSourcesPreference)
final citeSourcesPreferenceProvider = CiteSourcesPreferenceProvider._();

/// Preferências locais de exibição. Não vão para o backend — ele sempre
/// retorna as fontes; o que muda é se a tela as mostra.
final class CiteSourcesPreferenceProvider
    extends $AsyncNotifierProvider<CiteSourcesPreference, bool> {
  /// Preferências locais de exibição. Não vão para o backend — ele sempre
  /// retorna as fontes; o que muda é se a tela as mostra.
  CiteSourcesPreferenceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'citeSourcesPreferenceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$citeSourcesPreferenceHash();

  @$internal
  @override
  CiteSourcesPreference create() => CiteSourcesPreference();
}

String _$citeSourcesPreferenceHash() =>
    r'4697e86447320579b7decb1d63d306b001a48c6f';

/// Preferências locais de exibição. Não vão para o backend — ele sempre
/// retorna as fontes; o que muda é se a tela as mostra.

abstract class _$CiteSourcesPreference extends $AsyncNotifier<bool> {
  FutureOr<bool> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<bool>, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, bool>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
