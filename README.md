# Vaultblocks Mobile

Vaultblocks Mobile is a Flutter monorepo that keeps the app thin and pushes shared business logic into internal packages under `internals/`.

It is a fake-banking demo only. There are no real banking API calls.

## What Is In The Repo

- `lib/` contains the main Flutter app.
- `internals/core` contains shared infrastructure like API abstractions, auth session fakes, result types, and observability helpers.
- `internals/account_management` contains the account domain, repository, service layer, models, requests, responses, and tests.
- `internals/lib/internals.dart` is the barrel that the app imports with `package:internals/internals.dart`.
- `melos.yaml` defines workspace commands for setup, analysis, and tests.

## Architecture

The dependency flow is intentionally simple:

```txt
Vaultblocks Mobile app
  -> internals/account_management
  -> internals/core
```

The app does not import package internals directly from deep paths. It uses one stable barrel:

```dart
import 'package:internals/internals.dart';
```

That makes it easier to control what the app can see and to change internal package structure later without touching feature files.

## Features

- Accounts screen that loads fake account data.
- Transfer inquiry screen that validates and returns fake inquiry results.
- `get_it` dependency injection.
- Live account state via `ValueNotifier`.
- Package-level tests for the internal packages.

## Project Structure

```txt
vaultblocks_mobile/
  lib/
    main.dart
    di/
    features/
  internals/
    pubspec.yaml
    lib/
      internals.dart
    core/
    account_management/
  melos.yaml
  pubspec.yaml
```

## Setup

Run these from the repository root:

```bash
flutter pub get
melos bootstrap
```

What they do:

- `flutter pub get` fetches dependencies for the root app package.
- `melos bootstrap` links the workspace packages together and fetches dependencies for every package in the monorepo.

If you do not already have Melos installed:

```bash
dart pub global activate melos
```

## Common Commands

### Analysis

```bash
flutter analyze
melos run analyze
melos run analyze:core
melos run analyze:account
```

- `flutter analyze` checks the root Flutter app for analyzer issues.
- `melos run analyze` runs `flutter analyze` across every package in the workspace.
- `melos run analyze:core` checks only the `core` package.
- `melos run analyze:account` checks only the `account_management` package.

### Tests

```bash
flutter test
melos run test
melos run test:core
melos run test:account
melos run check:account
```

- `flutter test` runs tests for the root app package.
- `melos run test` runs tests across all workspace packages.
- `melos run test:core` runs tests only for `core`.
- `melos run test:account` runs tests only for `account_management`.
- `melos run check:account` runs both `analyze:account` and `test:account`.

### Run The App

```bash
flutter run
```

## Package Responsibilities

### `internals/core`

`core` owns shared infrastructure only:

- `ApiClient`
- `FakeApiClient`
- `AuthSession`
- `FakeAuthSession`
- `AppFailure`
- `AppResult<T>`
- `ObservabilityService`
- `ConsoleObservabilityService`

### `internals/account_management`

`account_management` owns the account domain:

- `UserAccount`
- `AccountInquiryRequest`
- `AccountInquiryResponse`
- `AccountRemoteDataSource`
- `AccountRepository`
- `AccountManagementService`
- `AccountStateStore`
- `AccountObservabilityTags`

The account service updates live state after successful fetches, which the UI can listen to.

## Notes On The Barrel

`internals/lib/internals.dart` is the package entrypoint that Flutter resolves when you import `package:internals/internals.dart`. That file is the stable public surface for the app.

If you want to expose a new class to the app, export it there. If you want to hide something, simply do not export it.

## Working In `internals/`

The main app should stay as thin as possible. As a team rule, only change files under `internals/` when the app actually needs the change.

Good reasons to edit `internals/`:

- a new app feature needs shared logic,
- a bug exists in shared package behavior,
- the barrel needs to expose or hide a type,
- package-level tests or analysis need to be updated.

If the change only affects one app screen, prefer keeping it in `lib/` instead of pushing it into `internals/`.

## Running Tests Manually In A Package

You can also enter a package and run its own Flutter commands directly:

```bash
cd internals/account_management
flutter test
```
