# Design system do GSH Desktop

Fonte da verdade é o código: tokens em `lib/app/core/ui/themes/`
(`theme_registry.dart` → tema `gsh`, `app_colors.dart` → papéis,
`app_typography.dart` → tipografia). Este documento explica o que cada
token significa e de onde veio, para quem for desenhar tela nova ou tema novo.

## Identidade

A marca da Gorila é **acromática**: o gorila low-poly do site usa dois
slates (`#7A8588` claro, `#434B4D` escuro) e o site é cinza com texto
`#F1F5F9`. Por isso o tema `gsh` não tem cor de acento viva: o acento é o
próprio slate. As **únicas cores vivas** da interface são as de estado, e elas
nunca são usadas como decoração.

Fontes do site, adotadas no app: **Montserrat** (títulos) e **JetBrains Mono**
(código). O corpo de texto fica em **Hanken Grotesk** (decisão: Mono no corpo
cansa em uso longo).

Logo/ícone: o gorila sobre um tile escuro `#262626` (`assets/branding/`).

## Superfícies (tema `gsh`)

Quatro degraus de elevação. No escuro, mais alto = mais claro; no claro,
mais alto = mais claro também, mas sem branco puro no conteúdo (o claro
anterior, com painel `#FFFFFF`, "parecia flashbang").

| Token | Papel | Escuro | Claro |
|---|---|---|---|
| `bg` | chrome: rail, árvore, barras | `#161819` | `#E3E7E8` |
| `panel` | corpo da aba: editor, terminal, chat | `#1E2122` | `#EDF0F1` |
| `panel2` | elevado: cards, composer, menus | `#262A2B` | `#F8FAFA` |
| `panel3` | hover, seleção, código inline | `#2F3435` | `#DADFE0` |
| `border` | fio fino | `#2A2E2F` | `#D3D8DA` |
| `border2` | divisor mais forte | `#3A4042` | `#BEC5C8` |

Razão entre degraus ≈ 1,1 de luminância: a elevação se lê sem saltar.

## Texto

| Token | Papel | Escuro | Claro |
|---|---|---|---|
| `text` | principal | `#F1F5F9` | `#1A1A1A` |
| `text2` | secundário | `#A3ACAE` | `#4A5456` |
| `text3` | terciário, placeholder, metadado | `#7A8588` | `#6B7578` |
| `text4` | apagado, ícone em repouso | `#4F585A` | `#A3ACAE` |

Contraste mínimo: `text3` ≥ 3,8:1 sobre `panel` e sobre `panel2` nos dois
brilhos. `text4` é decorativo de propósito (não carrega informação sozinho).

## Marca (acento)

| Token | Escuro | Claro |
|---|---|---|
| `accent` | `#C9D3D6` (slate claro) | `#434B4D` (slate escuro) |
| `accentText` | `#DCE3E5` | `#2E3536` |
| `accentSoft` | `#7A8588` a 20% | `#434B4D` a 12% |

Usos: borda do item selecionado, cursor do terminal, seleção, botão
primário. Nunca como cor de estado.

## Estado (as únicas cores vivas)

| Significado | Token | Escuro | Claro |
|---|---|---|---|
| trabalhando / online / ok | `online` | `#3FB868` | `#2E9E54` |
| esperando alguém / aviso | `warn` | `#E0A33A` | `#B7791F` |
| parado / ocioso | `gitUntracked` (azul) | `#4F9DF0` | `#2F6FF0` |
| erro | `error` | `#E5484D` | `#D32F2F` |

Regra: verde = trabalhando, amarelo = precisa de você, azul = parado. Vale
igual na fazenda, nas abas, no rail, no chat e nas configurações. Git usa a
mesma família (`gitStaged` verde, `gitDeleted` vermelho, `gitConflict`
laranja `#F0883E`).

Cores por **agente** (identificam a aba/subagente, iguais em qualquer tema):
`agent_colors.dart` — azul, esmeralda, âmbar, rosa, violeta, ciano, laranja,
pink (Tailwind 500), escolhidas por hash estável do id.

## Tipografia

| Estilo | Fonte | Tamanho | Uso |
|---|---|---|---|
| `display` | Montserrat 600 | 22 | títulos de tela, estado vazio |
| `title` | Montserrat 600 | 13 | nomes de workspace, aba, seção |
| `tab` | Montserrat 500 | 12,5 | texto das abas |
| `body` | Hanken Grotesk | 14,5 / 1,6 | corpo, chat, inputs |
| `label` | Hanken Grotesk | 12 / 1,3 | rótulos, descrições, metadados |
| `mono` | JetBrains Mono | 13 (ajustável) | código, terminal, comandos |

Servidas pelo `google_fonts` (cache local). O usuário pode trocar a fonte da
interface, do chat e de código nas configurações.

## Espaço e forma

- Grade de 4 px; padding de linha de configurações 16×12; gutter de painel
  16; coluna do chat 760 px (opções 680/900).
- Raios: 6 (botões, linhas, menus), 8 (cards, campos), 10 (balão do
  usuário), 14 (logo).
- Bordas sempre de 1 px no `border`; destaque de pendência (permissão, plano,
  pergunta) com borda `warn`.
- Ícones: Material (outlined), 14–18 px, cor `text2`/`text3`.

## Componentes recorrentes

- **Linha de configuração**: título (`body` 13,5) + descrição (`label`,
  `text3`) à esquerda, controle à direita; seções com título `title`.
- **Cartão de pendência** (chat): `panel2`, borda `warn` enquanto espera,
  botões Primário / Contorno / Fantasma.
- **Balão do usuário**: `panel3`, alinhado à direita; resposta do agente sem
  balão.
- **Ficha** (chip): `panel3`, raio 5, `label` 11,5.
- **Ponto de status**: círculo de 6–7 px na cor de estado; amarelo pulsa.

## Fazenda

Cenário próprio, fora do tema (é arte, não interface): paleta e sprites em
`lib/app/gsh/ui/widgets/farm/` (porte do clodfarm, MIT). O HUD e os balões
usam as mesmas cores de estado acima.

## Temas

Qualquer tema é um `GshThemeSpec` com variantes escuro/claro sobre os mesmos
papéis; um tema importado só precisa dos tokens que quer mudar (`extends`
herda o resto, padrão `classic`). Esquema em `docs/theme.schema.json`,
exemplo em `docs/theme.example.json`, formato em `docs/theme-format.md`.
