# AGENTS.md

Flutter country flag trivia app. Guess the country from its flag; every question has exactly
four options and three attempts.

## Commands

```bash
flutter pub get
flutter analyze          # must report "No issues found!"
flutter test             # 29 tests
flutter test test/unit/domain/usecases/generate_question_test.dart   # single file
flutter run
```

Run `flutter analyze` and `flutter test` before every commit. There is no CI config in this
repo, so these local checks are the only gate.

## Architecture

MVVM with Provider. Layer boundaries are real — do not let them leak:

| Layer | Path | Rule |
|---|---|---|
| Entities | `lib/domain/entities/` | Pure Dart. No Flutter imports. Use `copyWith`. |
| Use cases | `lib/domain/usecases/` | Pure Dart. Own all game rules. |
| Repositories | `lib/domain/repositories/` | Interfaces only. |
| Data | `lib/data/` | HTTP, SharedPreferences, JSON models, repo impls. |
| ViewModel | `lib/presentation/providers/` | `ChangeNotifier`. Owns UI state only. |
| Widgets | `lib/presentation/screens/`, `lib/presentation/widgets/` | No networking, no game rules. |

Dependencies point inward: `presentation -> domain <- data`. The domain layer must not import
`data/` or `presentation/`.

## Data source

- Countries: `GET https://countriesnow.space/api/v0.1/countries/flag/images`
- Response: `{ "error": bool, "msg": string, "data": [...] }`
- Per record: `name`, `flag`, `iso2`, `iso3`
- Validate every record and **deduplicate by `iso2`**. Do not hard-code the country count — the
  API returned 222 records on 2026-09-29, but that number changes.
- Flag images come from FlagCDN, **not** the API's `flag` field:
  `https://flagcdn.com/{iso2.lowercase}.png` (see `Country.flagCdnUrl`).
- `iso2` is the stable country ID. Never key persistence or de-duplication on `name`.

## Game rules (verified in `lib/domain/usecases/`)

These differ from the original spec — trust the code:

- **Three attempts per flag, not three lives per game.** Attempts reset to 3 for every question.
- A wrong answer does **not** end the game: it burns an attempt, keeps the same flag, and disables
  that option. The game ends only when every country is solved.
- Scoring by attempt: 1st = 10, 2nd = 8, 3rd = 5, exhausted = 0.
- Only **correctly answered** countries enter `solvedCountryIds`. Distractor countries that merely
  appeared as wrong options stay eligible for future questions.
- Solved IDs persist in SharedPreferences, so no repeat ever shows across sessions.
- `GenerateQuestion` throws when fewer than 4 countries remain unsolved. That is intentional.

## Two bugs that already happened here — do not reintroduce

1. **INTERNET permission.** The Flutter template only puts it in `android/app/src/debug/` and
   `profile/`. It must also be in `android/app/src/main/AndroidManifest.xml`, or release builds
   silently fail every request. If you add a new network dependency, re-check this file.

2. **Red/disabled wrong options.** `GameState.selectedWrongOptions` is *not* what the UI reads.
   `AnswerButton` reads `AnswerOption.isSelectedWrong`, so `SubmitAnswer` must rebuild the
   question's options on every wrong answer. If you refactor that path, verify a wrong option
   stays red and unclickable after the 500ms feedback delay — otherwise players can re-tap the
   same wrong answer to farm attempts.

## Rapid-tap protection

`GameProvider.submitAnswer` early-returns when `isAnswerLocked` is true, and every `SubmitAnswer`
result sets it. The lock clears only when the next question loads or attempts remain. Adding a
new state transition means deciding whether it sets the lock.

## Widget tests must inject fakes

The Flutter test binding blocks all HTTP (returns 400), so a widget test that hits the network
renders the error state, not the content. Pass `TriviaApp(countryRepositoryOverride: ...,
gameRepositoryOverride: ...)` using the fakes in `test/helpers/fakes.dart`. Do not add
`mockito` — the repository interfaces are small enough for hand-written fakes.

## Error states

Every async surface needs loading, error-with-retry, and empty handling. Broken flag images fall
back via `FlagImageWidget`'s `errorWidget`. Network timeouts are 10s
(`ApiConstants.requestTimeout`). Mapping lives in
`lib/data/datasources/remote/countries_remote_data_source.dart`.

## Testing expectations

Cover: API parsing/validation/dedup, question generation (four unique options, no repeat correct
answers, solved-country exclusion), attempt-based scoring, rapid-tap locking, persistence
round-trip, and the loading/error/game-over UI states. Use a seeded `Random` for anything
randomized so tests stay deterministic.
