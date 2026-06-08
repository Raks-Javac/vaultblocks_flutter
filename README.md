# Vaultblocks Mobile

Vaultblocks Mobile is an open-source Flutter banking architecture demo built as a Melos workspace. It shows how to keep the app thin while moving shared infrastructure and account logic into internal packages.

The project uses fake data only. It does not depend on any real banking APIs.

## What This Demonstrates

- A Flutter app at the repository root.
- Internal packages grouped under `internals/`.
- A shared `core` package for cross-cutting infrastructure.
- An `account_management` package that owns the account domain.
- Dependency injection with `get_it`.
- A stable app barrel at `lib/internals.dart`.
- Live account state with `ValueNotifier`.
- Package-level tests and simple observability tags.

## Project Structure

```txt
vaultblocks_mobile/
  lib/
    main.dart
    di/
      app_di.dart
    features/
      accounts/
        account_controller.dart
        account_list_screen.dart
      transfer/
        transfer_inquiry_controller.dart
        transfer_inquiry_screen.dart
    internals.dart
  internals/
    core/
      lib/
        core.dart
        src/
    account_management/
      lib/
        account_management.dart
        src/
      test/
  melos.yaml
  pubspec.yaml
  README.md
```

## Architecture

The dependency direction is intentionally simple:

```txt
vaultblocks_mobile app
  -> internals/account_management
  -> internals/core
```

The app imports a single barrel:

```dart
import 'package:vaultblocks_mobile/internals.dart';
```

That barrel re-exports only the classes the app should see, so you can control the surface area from one place.

## Package Responsibilities

### `internals/core`

`core` holds shared infrastructure only:

- `ApiClient`
- `FakeApiClient`
- `AuthSession`
- `FakeAuthSession`
- `AppFailure`
- `AppResult<T>`
- `ObservabilityService`
- `ConsoleObservabilityService`

The fake API supports:

- `GET /accounts`
- `POST /accounts/inquiry`

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

This package updates live account state after a successful `getAccounts()` call.

## App Flow

### Get Accounts

The account screen calls:

```dart
accountManagementService.getAccounts();
```

That flow is:

```txt
UI
  -> AccountManagementService
  -> AccountRepository
  -> AccountRemoteDataSource
  -> Core ApiClient / AuthSession / Observability
  -> Fake backend response
```

The returned accounts are also written into `AccountStateStore`, which the UI listens to for live updates.

### Transfer Inquiry

The transfer inquiry screen calls:

```dart
accountManagementService.inquireAccount(
  request: AccountInquiryRequest(
    accountNumber: accountNumber,
    bankCode: bankCode,
  ),
);
```

Valid input returns fake account details. Invalid input returns a controlled `AccountFailure`.

## Why the Barrel Exists

`lib/internals.dart` gives the app one stable import path for internal packages. That helps with:

- avoiding import path churn,
- limiting what app code can see,
- making the dependency surface explicit,
- gradually changing what is public without touching feature files.

## Observability

Each account layer emits package-specific tags through `ObservabilityService`. In this demo, `ConsoleObservabilityService` prints errors and tags to the console so it is easy to trace failures during development.

## Running The Project

### Prerequisites

- Flutter SDK
- Dart SDK
- Melos

### Setup

Run these commands from the repository root:

```bash
flutter pub get
dart pub global activate melos
melos bootstrap
```

What each setup command does:

- `flutter pub get` fetches the root app dependencies.
- `dart pub global activate melos` installs Melos if you do not already have it.
- `melos bootstrap` links the workspace packages together and fetches package dependencies for the monorepo.

### Run The App

```bash
flutter run
```

### Run Tests

Run the account package tests:

```bash
cd internals/account_management
flutter test
```

Or run the workspace test script from the root:

```bash
melos run test:account
```

What the test commands do:

- `flutter test` runs tests inside the `account_management` package only.
- `melos run test:account` runs the account package test script from the workspace root.

### Run Analysis

```bash
flutter analyze
melos run analyze
melos run test
melos run analyze:core
melos run test:core
melos run analyze:account
melos run test:account
melos run check:account
```

What the analysis and workspace commands do:

- `flutter analyze` checks the root app for static analysis issues.
- `melos run analyze` runs `flutter analyze` across every package in the workspace.
- `melos run test` runs `flutter test` across every package in the workspace.
- `melos run analyze:core` runs analysis only for `internals/core`.
- `melos run test:core` runs tests only for `internals/core`.
- `melos run analyze:account` runs analysis only for `internals/account_management`.
- `melos run test:account` runs tests only for `internals/account_management`.
- `melos run check:account` runs both `analyze:account` and `test:account`.

## Workspace Scripts

Defined in `melos.yaml`:

- `melos run bootstrap`
- `melos run analyze`
- `melos run test`
- `melos run analyze:core`
- `melos run test:core`
- `melos run analyze:account`
- `melos run test:account`
- `melos run check:account`

## Notes

- The project uses fake data only.
- `account_management` owns the account models and workflows.
- The root app depends on the internal packages through path dependencies.
- Generated files such as `.dart_tool/` and `pubspec.lock` are intentionally left out of version control.
