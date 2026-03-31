# ChangeLog

## [v0.2.0] - 2026-03-31

### Release Summary

Релиз `v0.2.0` концентрируется на надежности execution-stage в `gigacraft`.
После `v0.1.0` расширение стало заметно устойчивее в реальной работе с планами: статус выполнения теперь ведется детерминированно, milestone boundaries получили явные commit checkpoints, `Serena` / `code-index` переоцениваются в момент старта execution, `brainstorming` перестал преждевременно уходить в review, интерактивные блоки вопросов получили жесткий output contract, а `subagent-driven-development` теперь требует реального запуска сабагентов вместо имитации делегации.

### Scope of Change

- 6 целевых workflow-улучшений после `v0.1.0`
- 21 измененный файл
- 351 добавлений и 37 удалений
- 6 smoke-check скриптов для контроля prompt contracts

### Highlights

#### 1. Resumable execution стал надежнее

- `executing-plans` и `subagent-driven-development` теперь автоматически подхватывают sibling `-status.md` и используют его как source of truth.
- После каждого task / validation шага status companion должен обновляться немедленно, а не best-effort.

#### 2. Появились milestone commit checkpoints

- `writing-plans` теперь требует явных commit checkpoints на уровне milestone.
- Execution-stage создает non-interactive commit только после прохождения milestone gate и только при валидном diff без unrelated changes.

#### 3. Navigation helpers проверяются в момент старта execution

- Planning может записать readiness `Serena` / `code-index` только как advisory context.
- Реальная проверка helper readiness теперь происходит при активации `executing-plans` и `subagent-driven-development`, с явным fallback на `rg`.

#### 4. Brainstorming получил строгий review gate

- `spec-reviewer`, `api-designer` и `sre-skeptic` больше не должны запускаться до появления записанного spec-файла.
- Dispatch templates и reviewer prompts теперь дополнительно отказываются ревьюить “идею в чате” вместо written spec.

#### 5. Интерактивные блоки вопросов стали стабильнее

- Для `AskUserQuestion` и `ReviewOptions` добавлен прямой запрет на fenced-code output и любой текст перед raw block.
- Это уменьшает риск того, что UI покажет plain text вместо интерактивного элемента.

#### 6. Subagent execution теперь требует реальной делегации

- `subagent-driven-development` больше не должен “говорить, что делегирует”, не запуская сабагентов.
- Добавлены bounded dispatch templates для `implementer` и `code-reviewer`, а при отсутствии subagent support workflow обязан честно предложить fallback на `executing-plans`.

### Verification

Пакет изменений проверен встроенными smoke-check скриптами:

- `scripts/check-brainstorming-interactive-format.sh`
- `scripts/check-brainstorming-review-gate.sh`
- `scripts/check-code-index-readiness-planning.sh`
- `scripts/check-execution-skill-status.sh`
- `scripts/check-milestone-commit-checkpoints.sh`
- `scripts/check-subagent-dispatch-contract.sh`

### Included Commits

- `a94f53e` `fix: enforce status companion updates during execution`
- `c6f11e4` `fix: gate brainstorming review on written spec`
- `e54c9bc` `feat: add milestone commit checkpoints to plan execution`
- `ade2081` `fix: re-check code-index readiness on execution activation`
- `dbd279e` `fix: require raw interactive blocks in brainstorming`
- `4bc6cb6` `fix: require real subagent dispatch in execution`

## [v0.1.0]

- Первый tagged baseline для `gigacraft` skills-first workflow.
