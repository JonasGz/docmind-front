# Doc Mind — App Flutter

App mobile do Doc Mind. A spec completa está em
[`../ref/SPECS/SPEC-FRONTEND.md`](../ref/SPECS/SPEC-FRONTEND.md).

## Rodar

```bash
flutter pub get
flutter pub run build_runner build   # models Freezed e providers Riverpod
flutter run                          # roda com mocks, sem backend
flutter test
flutter analyze
```

Contra o backend real, veja [SETUP.md](SETUP.md):

```bash
flutter run \
  --dart-define=USE_MOCKS=false \
  --dart-define=API_BASE_URL=http://localhost:8000 \
  --dart-define=GOOGLE_WEB_CLIENT_ID=...
```

A galeria de componentes fica em Ajustes → Desenvolvimento.

## Arquitetura

MVVM por feature, sem Clean Architecture. Cada feature é autocontida:

```
lib/
├── core/            api, config, models, router, services, theme, utils, widgets
└── features/
    ├── auth/        datasources, providers, repositories, services, pages
    ├── chat/        models, viewmodels, widgets, pages
    ├── conversations/
    ├── documents/
    └── settings/
```

**Estado:** Riverpod com `riverpod_generator`. O ViewModel do MVVM *é* a
classe `@riverpod class XViewModel extends _$XViewModel` — não há uma camada
extra sobreposta ao Notifier.

**Navegação:** `go_router` com `StatefulShellRoute.indexedStack`, que preserva
o estado de cada aba. Histórico de conversas e visualizador de PDF são rotas
empilhadas no navigator raiz, cobrindo a tab bar.

**Mock ou HTTP:** a troca acontece no **datasource**, decidida por
`AppConfig.useMocks`. O repositório é classe concreta única — uma só
implementação não justificaria uma interface. Os mocks não foram descartados
na integração: continuam servindo para rodar sem backend e para os testes.

## Divergências entre o design e o backend

O design foi desenhado antes do contrato da API existir. Onde os dois
discordam, o app segue o backend:

| Elemento do design | Situação | Decisão |
| --- | --- | --- |
| Tamanho do arquivo (`2,1 MB`) | `DocumentResponse` não tem o campo | Removido |
| `4 arquivos · 28,4 MB` | idem | Virou `N documentos` |
| Progresso em `64%` | Backend expõe `status`, não percentual | Barra indeterminada |
| Badge `DOCX` | Backend aceita só `application/pdf` (415 no resto) | Badge sempre `PDF` |
| Campo de busca | `GET /documents` não aceita parâmetro de busca | Filtro client-side |
| "Plano Pro" | Não existe no backend | Removido |
| Notificações, tema escuro | Não existem | Removidos |
| Estilo/idioma das respostas | Prompt é fixo no backend | Removidos |
| "Privacidade e dados" | Tela não desenhada | Removido |
| "Citar fontes nas respostas" | `sources` sempre retorna | Virou preferência **local** de exibição |
| Saudação do bot | Não é persistida pela API | Texto de interface |
| Lista de conversas | Backend suporta, design não desenhou | Tela nova, com os componentes do design system |

### Duas exceções deliberadas

1. **"Entrar com e-mail"** continua na tela de login, fiel ao desenho, mas
   abre um sheet informando que ainda não está disponível. Perder o botão
   primário da tela custaria mais que mantê-lo marcado como futuro.
2. **Mensagens de progresso do chat** são cronometradas, não observadas — o
   backend não expõe a etapa do pipeline. Estão marcadas no código como
   encenação, para que ninguém as leia como telemetria.

## Decisões que não são óbvias no código

- **Polling global, não por tela.** O provider de documentos é `keepAlive` e
  faz polling de 2s enquanto houver documento em processamento, parando
  sozinho quando não há. É global porque o subtítulo do chat ("N documentos no
  contexto") consome o mesmo estado, e um upload precisa continuar sendo
  acompanhado depois que o usuário troca de aba. Pausa em segundo plano e
  consulta imediatamente ao voltar.
- **Refresh single-flight.** Se várias requisições receberem 401 juntas, só
  uma chama `/auth/refresh`; as demais aguardam. Sem isso o polling dispararia
  renovações simultâneas e todas menos a primeira falhariam, já que o backend
  invalida o refresh token a cada uso.
- **Conversa criada preguiçosamente.** `POST /conversations` só acontece no
  primeiro envio. Criar ao abrir a aba encheria o histórico de conversas
  vazias. O título é gerado pelo backend a partir da primeira pergunta.
- **Todas as fontes viram chip**, até as cinco do `RETRIEVAL_TOP_K`. Mostrar
  só a de maior score esconderia quatro de cinco e contrariaria o ponto do
  produto. Toque abre o PDF na página; toque longo mostra o trecho e a
  similaridade.
- **Enums toleram valores desconhecidos.** Um `doc_type` novo no backend
  degrada para `unknown` em vez de quebrar o parse e derrubar a tela.

## Testes

56 testes. A seam é única: o **datasource**, injetado via
`ProviderScope(overrides:)`. Ela já existia por necessidade da arquitetura —
não foi criada para testar.

| Arquivo | Cobre |
| --- | --- |
| `models_test.dart` | Parse contra JSON idêntico ao do FastAPI |
| `mock_datasources_test.dart` | Pipeline assíncrono e respostas do chat |
| `documents_page_test.dart` | Lista, busca, polling, divergências do design |
| `chat_page_test.dart` | Envio, fontes, criação preguiçosa, falhas |
| `auth_interceptor_test.dart` | Single-flight, renovação, sessão expirada |
| `auth_flow_test.dart` | Restauração de sessão e logout |
| `widget_test.dart` | Navegação e três viewports (390×844, 1200×900, 800×600) |
