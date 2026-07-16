# AI Agent Project Rules

## Universal Conventions
*(These apply to every project regardless of tech stack — keep this section identical across repos.)*

### Language
All technical comments, documentation, and logic descriptions in the codebase MUST be written in English.

### Documentation Convention
For every public class/method, add a doc comment following the language's standard doc format (e.g. dartdoc for Dart, JSDoc for TypeScript):
- One sentence summarizing purpose (don't repeat the class/method name).
- One line per non-trivial parameter (`@param` or equivalent).
- Return value documentation only if it isn't obvious from the type.
- NO code examples unless the logic is genuinely non-obvious.
- Do not document trivial getters/setters or self-explanatory boilerplate.

### Scope Discipline
- Only read, open, or modify files explicitly named in the task, or files directly imported/referenced by them.
- Do NOT explore or edit files outside the stated scope without first asking for confirmation.
- Exception — the following do NOT require asking first, as they are natural consequences of a task, not scope expansion:
  - Regenerating/updating codegen output files (e.g. `.g.dart`) that correspond to a modified source file.
  - Updating an existing test file that directly tests the modified code, when needed to keep the Mandatory Verification Pipeline passing.
- If the task seems to require touching files beyond the stated scope AND beyond the exceptions above, STOP and report which additional files you believe are needed, and why — before making changes.

### Ambiguity Handling
- If a requirement is ambiguous or underspecified, state your interpretation/assumption explicitly before proceeding, rather than silently guessing.
- Prefer asking one direct clarifying question over implementing multiple speculative variants.

### Dependency Changes
- Do NOT add, remove, or upgrade a dependency without explicitly flagging it in your response (name, version, reason).
- Never introduce a new dependency to solve a problem that can be reasonably solved with existing project dependencies or stdlib.

### Git & Version Control
- Once the full Mandatory Verification Pipeline has passed (all steps green, zero errors, zero failing tests) for a completed, atomic logical change, commit it without asking for permission first.
- Do NOT commit if any pipeline step failed, was skipped, or could not be run — stop and report instead, per Guardrails and Verification Honesty above.
- Write descriptive, atomic commit messages (what changed and why, not just "fix").
- NEVER force-push, rewrite shared history, or delete branches without explicit confirmation.

### Security
- NEVER hardcode API keys, tokens, passwords, or other secrets in source code.
- NEVER commit `.env` files or other files containing local secrets.
- Use environment variables / the platform's secure storage mechanism for anything sensitive.

### Verification Honesty
- NEVER report that a verification step (build, analyze, lint, test) passed unless you actually executed it in this session and observed the output.
- If a step cannot be run (e.g. missing tool, sandboxed environment limitation), say so explicitly instead of assuming or claiming success.
- Do not fabricate or paraphrase tool output — quote or summarize only what was actually returned.

### Debug Artifact Cleanup
- Remove debug print/log statements and commented-out code introduced during iteration before considering a task complete, unless explicitly asked to leave them for further debugging.
- Do not leave stray TODO comments describing unfinished work without flagging them explicitly in your final summary.

### Guardrails
- NEVER delete, skip, or weaken a test to make the verification pipeline pass. Fix the underlying code instead.
- NEVER add lint-suppression comments (e.g. `// ignore:`) or disable analyzer/linter rules to silence errors, unless explicitly instructed.
- If a fix is not obvious after 2 attempts, stop and report the exact error instead of applying a workaround.

### Formatting & Style
- Follow the official style guide / formatter for the language in use (e.g. `dart format .`).
- Ensure all generated files are correctly linked/imported per the framework's conventions (e.g. `part 'filename.g.dart';` for Dart build_runner output).

---

## Project Stack: weekend_memory
*(Replace this whole section when starting a new project with a different stack.)*

### Build & Generation Commands
- Install dependencies: `flutter pub get`
- Run build runner: `dart run build_runner build --delete-conflicting-outputs`
- Code analysis: `dart format .` and `flutter analyze`
- Run tests: `flutter test`

### Architecture & Layer Boundaries
This is a Local-First, AI-Native mobile memory game utilizing Clean Architecture under the following strict layout:
- **Domain Layer** (`lib/features/memory_game/domain/`): Pure Dart logic. Contains models (`MemoryCard`, `GameResult`, `GameConfig`), the core `GameEngine` service (handling card shuffling, matching rules, and win conditions), and repository interfaces. NO Flutter or Riverpod imports allowed here.
- **Data Layer** (`lib/features/memory_game/data/`): Repository implementations and local storage handlers utilizing `isar_community` (Isar Database).
- **Presentation Layer** (`lib/features/memory_game/presentation/`): Responsive UI components, state management via Riverpod 3.x generators (`@riverpod`), and configuration/theme states.
- **State Management:** Riverpod 3.x strictly.
- **Data Flow:** UI (`ConsumerWidget`) -> Notifier (`@riverpod`) -> Repository Interface (domain) -> Repository Impl (data) -> Local DB (`isar_community`).
- **Reactivity:** State Notifiers listen to game interactions and trigger synchronous state updates. Completed games are persisted asynchronously to Isar.

### Lifecycle & Resource Disposal Checklist
Before considering any game feature, animation, or timer complete, verify:
- Every `Timer` used for gameplay duration tracking or card flip delays is explicitly cancelled in the Notifier's `ref.onDispose()` or the widget's `dispose()`.
- No memory leaks exist during rapid screen transitions (e.g., navigating back to Home while the game timer is active).
- Database connections/Isar instances are properly handled via Riverpod providers to avoid multi-instance locks during test execution.

### Mandatory Verification Pipeline
After any modification within the `lib/**` directory, you MUST execute the following pipeline in strict order:
1. `dart run build_runner build --delete-conflicting-outputs`
2. `flutter analyze`
3. `flutter test`

A task is NOT considered complete until all steps pass with zero errors and zero failing tests, AND the Lifecycle & Resource Disposal Checklist above has been explicitly verified. Fix any arising issues autonomously, subject to the Guardrails above.
