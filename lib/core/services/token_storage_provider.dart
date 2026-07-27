import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../config/app_config.dart';
import 'token_storage.dart';

part 'token_storage_provider.g.dart';

@Riverpod(keepAlive: true)
TokenStorage tokenStorage(Ref ref) =>
    AppConfig.useMocks ? InMemoryTokenStorage() : const SecureTokenStorage();
