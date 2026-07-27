# Doc Mind — App Flutter

App mobile do Doc Mind. A spec completa está em
[`../ref/SPECS/SPEC-FRONTEND.md`](../ref/SPECS/SPEC-FRONTEND.md).

## Estado: Fase 3 — Models e mocks

Concluídas as fases 1 a 3.

### Fase 3 — Models e mocks

Models Dart espelhando os schemas Pydantic do backend (Freezed +
json_serializable, `field_rename: snake` no `build.yaml`):

| Model | Schema do backend |
| --- | --- |
| `Document`, `DocumentStatus`, `DocumentType` | `DocumentResponse` |
| `Conversation` | `ConversationResponse` |
| `Message`, `Source`, `MessageRole` | `MessageResponse`, `Source` |
| `User` | `UserResponse` |
| `TokenPair` | `TokenPair` |

Os enums têm um membro `unknown`: uma categoria nova no backend não pode
derrubar a tela do usuário.

Datasources com mock em memória — o de documentos simula o pipeline
assíncrono (`uploaded` → `processing` → `indexed`), o de conversas responde
por palavra-chave e **admite não saber** quando nada bate, que é o
comportamento crítico no domínio jurídico.

A troca mock/HTTP fica em `AppConfig.useMocks`, lido de `--dart-define`.

### Fase 2 — Navegação

`go_router` com `StatefulShellRoute.indexedStack`. Histórico de conversas e
visualizador de PDF são rotas empilhadas no navigator raiz, cobrindo a tab bar.

### Fase 1 — Design System

O que existe:

- **Tokens** (`lib/core/theme/`) — cores, tipografia Poppins, espaçamento,
  radius e sombras, todos derivados de `ref/FRONT/design-system.md`.
- **Tema Material** (`app_theme.dart`) — botões, inputs e divisores já saem
  corretos sem estilo por chamada.
- **Componentes compartilhados** (`lib/core/widgets/`) — `AppHeader`,
  `AppTabBar`, `AppToggle`, `AppChip`, `AppCard`, `AppListGroup`/`AppListRow`,
  `AppIconButton`, ícones.
- **4 telas estáticas** — login, chat, documentos, ajustes.
- **Galeria** (`lib/dev/gallery_page.dart`) — é a home nesta fase.

Ainda **não** existe: navegação real, estado, models, HTTP, autenticação.

### Retrabalho previsto e aceito

As telas de Documentos e Ajustes usam os textos literais do design, incluindo
dados que **não existem no backend**: tamanho de arquivo (`2,1 MB`), percentual
de progresso (`64%`), badge `DOCX` (o backend só aceita PDF), "Plano Pro",
"Notificações", "Tema escuro", "Estilo/Idioma das respostas" e "Privacidade e
dados". As Fases 4 e 6 reescrevem essas telas contra o contrato real.

## Rodar

```bash
flutter pub get
flutter pub run build_runner build    # models Freezed e providers Riverpod
flutter run                            # roda com mocks
flutter test
flutter analyze
```

A galeria de componentes fica em Ajustes → Desenvolvimento.

## Próxima fase

Fase 4 — tela de Documentos ligada aos models reais: lista, upload, polling
de status e busca client-side.
