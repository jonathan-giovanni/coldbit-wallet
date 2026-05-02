# ColdBit Wallet - Quality Baseline

Baseline date: 2026-05-02  
Branch: `feature/00-quality-baseline`

## Commands

```bash
dart format .
flutter analyze
flutter test --coverage
flutter build apk --debug
```

## Original Baseline Result

`flutter analyze`:

```text
No issues found.
```

`flutter test --coverage`:

```text
All tests passed.
22 tests passed.
1 test skipped: BDK native FFI descriptor derivation requires native library/device.
```

Coverage summary from `coverage/lcov.info`:

```text
lines_hit=464
lines_found=842
coverage=55.11%
```

## Current Coverage Gate

Updated date: 2026-05-02  
Branch: `feature/04-expanded-onboarding`

`flutter test --coverage`:

```text
All tests passed.
42 tests passed.
1 test skipped: BDK native FFI descriptor derivation requires native library/device.
```

Coverage summary from `coverage/lcov.info`:

```text
lines_hit=968
lines_found=1241
coverage=78.00%
```

Android debug build:

```text
Built build/app/outputs/flutter-apk/app-debug.apk
```

## Coverage Rule

- Coverage must not decrease without an explicit written reason in the PR.
- Every production behavior change in crypto, seed handling, signing, address derivation, authentication, threat policy, or secure storage must add focused tests.
- Every P0 fix must include a regression test that fails against the previous behavior and passes after the fix.

## Lint Rule

Flutter linting for this project is enforced through:

```bash
flutter analyze
```

There is no separate first-party `flutter lint` command in this Flutter project. The active lint rules are defined by `flutter_lints` through `analysis_options.yaml`.
