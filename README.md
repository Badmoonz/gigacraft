# gigacraft

`gigacraft` — это легковесное расширение для структурированной backend-разработки в GigaCode. Цель проекта — адаптировать `obra/superpowers` под среду разработки GigaCode и доступную в ней модель `Qwen-Coder-Next`.


- `skills-first` workflow для spec, plan, implementation, review и verification
- сфокусированные субагенты для каждого этапа workflow
- поддерживаемые fallback-команды для ручного управления этапами, когда это удобнее
- нейтральные backend-стандарты с Java- и Go-оверлеями

## Зачем Нужен Этот Репозиторий

Это расширение предназначено для персонального форка GigaCode под названием `gigacraft`. Его задача — перенести workflow из `obra/superpowers` в среду GigaCode в форме, которая хорошо подходит доступной модели `Qwen-Coder-Next`, сохранив дисциплинированный процесс без добавления runtime-сервисов и MCP-сложности в v1.

## Установка

### Подключение из локального checkout

```bash
qwen extensions link  %{gigacraft}
```

### Установка из git-репозитория

```bash
qwen extensions install <git-url>
```

### Просмотр установленных расширений

```bash
qwen extensions list
```

## Дополнительные Помощники

При желании можно использовать дополнительные MCP-помощники для более удобной навигации по репозиторию и поиска документации:

- Serena или `code-index-mcp` для навигации по репозиторию
- Context7 для поиска документации по фреймворкам и библиотекам с учетом версий

Это опциональные помощники, а не обязательные зависимости для использования `gigacraft`.

## Workflow По Умолчанию

Для большинства backend-задач используйте `skills-first` путь:

1. `using-gigacraft` routes to the right workflow stage
2. `brainstorming`
3. `writing-plans`
4. `subagent-driven-development` or `executing-plans`
5. `requesting-code-review`
6. `verification-before-completion`

Такой подход четко разделяет design, planning, implementation, review и verification, делая `skills` основным интерфейсом workflow.

## Ручные Fallback-Команды

Slash-команды остаются доступными, если вам нужен явный контроль или автоматического stage routing недостаточно. Это тонкие редиректы на соответствующие `gigacraft:*` skills, а не отдельные определения workflow:

1. `/write-spec`
2. `/write-plan`
4. `/implement-plan`
5. `/review-changes`

Дополнительная ручная команда:

- `/refactor-scope`

## Структура Репозитория

```text
.
├── LICENSE
├── README.md
├── qwen-extension.json
├── gigacode-extension.json
├── QWEN.md
├── GIGACODE.md
├── agents/
├── commands/
├── skills/
├── context/
├── demo/
├── plans/
└── ...
```

### Основные директории

- `skills/`: основная workflow-политика для design, planning, execution, review и verification
- `agents/`: сфокусированные role-prompts для субагентов `architect`, `api-designer`, `spec-reviewer`, `sre-skeptic`, `planner`, `implementer`, `code-reviewer` и `refactor`
- `commands/`: поддерживаемые ручные точки входа для поэтапного управления
- `context/`: переиспользуемые нейтральные backend-правила и оверлеи для Java, Go, testing и service-задач
- `demo/`: демонстрационные и onboarding-материалы по проекту
- `plans/`: примеры устойчивых артефактов, создаваемых workflow

## Заметки Для Maintainer'ов

Если вы разрабатываете сам `gigacraft`, скопируйте `AGENTS.example.md` в локальный `AGENTS.md` и добавьте `AGENTS.md` в `.git/info/exclude`. Храните там только maintainer-специфичные инструкции; поведение, которое должно поставляться вместе с расширением, оставляйте в отслеживаемых prompt assets.

## Нейтральный Backend По Умолчанию

Расширение по умолчанию придерживается нейтральной backend-позиции. Java- и Go-специфичные рекомендации доступны как оверлеи, а не зашиты прямо в root prompt. Это делает расширение полезным для смешанных backend-кодовых баз.

