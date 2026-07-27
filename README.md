# Doc Mind — App Flutter

App mobile do Doc Mind. A spec completa está em
[`../ref/SPECS/SPEC-FRONTEND.md`](../ref/SPECS/SPEC-FRONTEND.md).

## Estado: Fase 1 — Design System

Concluída. O que existe:

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
flutter run                 # abre na galeria
flutter test                # 3 viewports: 390×844, 1200×900, 800×600
flutter analyze
```

## Próxima fase

Fase 2 — navegação com `go_router` + `StatefulShellRoute`, preservando estado
por aba.
