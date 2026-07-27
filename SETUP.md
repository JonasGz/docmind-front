# Configuração do Google Sign-In

O aplicativo autentica pelo Google: obtém um `id_token` no dispositivo e o
troca por tokens da API em `POST /auth/google`. Para isso são necessários
**três Client IDs** no Google Cloud Console — o aplicativo referencia dois
deles diretamente.

Sem essa configuração o app roda normalmente com `USE_MOCKS=true`, que é o
padrão.

## Por que três Client IDs

| Tipo | Onde é usado | Referenciado no código |
| --- | --- | --- |
| **Web** | Passado como `serverClientId`. É a audiência que o backend valida — **o mesmo valor do `GOOGLE_CLIENT_ID` do backend**. | `GOOGLE_WEB_CLIENT_ID` |
| **iOS** | Vai no `Info.plist`, identifica o app no dispositivo. | Arquivo de configuração |
| **Android** | Registrado com o SHA-1 da chave de assinatura. | Nenhum — o Google resolve pelo pacote + SHA-1 |

**O erro mais comum é usar o Client ID da plataforma como `serverClientId`.**
O `id_token` sai endereçado à audiência errada e o backend responde
`AuthError("id_token inválido")` — mensagem que não distingue token corrompido,
token expirado e audiência trocada. Se o login falhar com um token
aparentemente válido, confira este ponto primeiro.

Os Client IDs de iOS e Android identificam o app no dispositivo perante o
Google; o backend nunca os vê.

## Passos

### 1. Projeto e tela de consentimento

1. Crie ou selecione um projeto no [Google Cloud Console](https://console.cloud.google.com/).
2. Em **APIs e serviços → Tela de permissão OAuth**, configure o app.
3. Adicione os escopos `email` e `profile`.

### 2. Client ID Web

Em **Credenciais → Criar credenciais → ID do cliente OAuth → Aplicativo da
Web**. Guarde o Client ID gerado.

**Este mesmo valor vai nos dois lados** — não são credenciais diferentes:

| Onde | Variável |
| --- | --- |
| Backend (`.env`) | `GOOGLE_CLIENT_ID` |
| App (`--dart-define`) | `GOOGLE_WEB_CLIENT_ID` |

O app pede ao Google um `id_token` endereçado a esse Client ID, e o valor fica
gravado no campo `aud` do token. O backend chama
`verify_oauth2_token(token, request, settings.google_client_id)`, que compara o
`aud` recebido com o que ele conhece. Valores diferentes nos dois lados = nenhum
login funciona.

Se o backend já está configurado, use o Client ID que ele usa e pule este
passo.

### 3. Client ID iOS

1. **Criar credenciais → ID do cliente OAuth → iOS**.
2. Bundle ID: `br.com.docmind.docmind`.
3. Baixe o `GoogleService-Info.plist` e coloque em `ios/Runner/`.
4. Em `ios/Runner/Info.plist`, adicione o esquema de URL invertido:

```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array>
      <!-- REVERSED_CLIENT_ID do GoogleService-Info.plist -->
      <string>com.googleusercontent.apps.SEU-CLIENT-ID-IOS</string>
    </array>
  </dict>
</array>
```

### 4. Client ID Android

1. Obtenha o SHA-1 da chave de assinatura:

```bash
# Debug
keytool -list -v -keystore ~/.android/debug.keystore \
  -alias androiddebugkey -storepass android -keypass android

# Release — use a sua keystore
keytool -list -v -keystore caminho/para/release.keystore -alias SEU_ALIAS
```

2. **Criar credenciais → ID do cliente OAuth → Android**.
3. Nome do pacote: `br.com.docmind.docmind`; cole o SHA-1.

Repita para a chave de release — o SHA-1 de debug não vale em produção, e o
login falha silenciosamente se isso for esquecido.

## Onde ficam essas configurações

`--dart-define` é uma flag de linha de comando do Flutter, resolvida em
**tempo de compilação** — por isso os valores em `AppConfig` são `const`. Não
existe arquivo de configuração lido em runtime.

Para não repetir as flags a cada execução, use um arquivo:

```bash
cp env/local.example.json env/local.json
```

Preencha `env/local.json` e rode:

```bash
flutter run --dart-define-from-file=env/local.json
```

`env/local.json` está no `.gitignore` — ele carrega o Client ID e não deve ir
para o repositório. Só o `.example.json` fica versionado.

No VS Code as duas configurações já estão em `.vscode/launch.json`: escolha
**Doc Mind (mocks)** ou **Doc Mind (backend local)** no seletor de execução.

Passar flag por flag continua funcionando, e tem precedência sobre o arquivo:

```bash
flutter run \
  --dart-define=USE_MOCKS=false \
  --dart-define=API_BASE_URL=http://localhost:8000 \
  --dart-define=GOOGLE_WEB_CLIENT_ID=SEU-CLIENT-ID-WEB.apps.googleusercontent.com
```

Em dispositivo físico Android, `localhost` aponta para o próprio aparelho —
use o IP da máquina na rede local.

## Rodar sem backend

```bash
flutter run
```

`USE_MOCKS` é `true` por padrão: os datasources mock respondem no lugar da API
e o login aceita qualquer toque, sem falar com o Google.

## Variáveis disponíveis

| Variável | Padrão | O que faz |
| --- | --- | --- |
| `USE_MOCKS` | `true` | `false` liga os datasources HTTP |
| `API_BASE_URL` | `http://localhost:8000` | Endereço do backend |
| `GOOGLE_WEB_CLIENT_ID` | vazio | `serverClientId` do Google Sign-In |
