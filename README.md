# Daily Local Notifications - WIP!

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

A widget which can be easily included in your app to add daily local notifications.
Uses [flutter_local_notifications][flutter_local_notifications_link] package under the hood.

## Current State
<!-- ![Screenshot](screenshot.png =250px) -->
<img src="screenshot.png" alt="goal" width="200"/>

## Installation 💻

**❗ In order to start using Daily Local Notifications you must have the [Flutter SDK][flutter_install_link] installed on your machine.**

Add `daily_local_notifications` to your `pubspec.yaml`:

```yaml
dependencies:
  daily_local_notifications:
```

Install it:

```sh
flutter packages get
```

---
## Example
```dart
DailyLocalNotification(
  reminderTitleText: Text('Reminder Title'),
  reminderRepeatText: Text('Repeat'),
  reminderDailyText: Text('Daily'),
  dayActiveColor: Colors.deepPurple,
  dayInactiveColor: Colors.deepPurple.withOpacity(0.3),
  timeNormalTextStyle:
      const TextStyle(fontSize: 24, color: Colors.grey),
  timeSelectedTextStyle: TextStyle(
    fontSize: 24,
    color: Colors.deepPurple,
    fontWeight: FontWeight.bold,
  ),
),
```

---

## Running Tests 🧪 (NOT YET :D)

For first time users, install the [very_good_cli][very_good_cli_link]:

```sh
dart pub global activate very_good_cli
```

To run all unit tests:

```sh
very_good test --coverage
```

To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov).

```sh
# Generate Coverage Report
genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
open coverage/index.html
```

[flutter_local_notifications_link]: https://pub.dev/packages/flutter_local_notifications
[flutter_install_link]: https://docs.flutter.dev/get-started/install
[github_actions_link]: https://docs.github.com/en/actions/learn-github-actions
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[logo_black]: https://raw.githubusercontent.com/VGVentures/very_good_brand/main/styles/README/vgv_logo_black.png#gh-light-mode-only
[logo_white]: https://raw.githubusercontent.com/VGVentures/very_good_brand/main/styles/README/vgv_logo_white.png#gh-dark-mode-only
[mason_link]: https://github.com/felangel/mason
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[very_good_cli_link]: https://pub.dev/packages/very_good_cli
[very_good_coverage_link]: https://github.com/marketplace/actions/very-good-coverage
[very_good_ventures_link]: https://verygood.ventures
[very_good_ventures_link_light]: https://verygood.ventures#gh-light-mode-only
[very_good_ventures_link_dark]: https://verygood.ventures#gh-dark-mode-only
[very_good_workflows_link]: https://github.com/VeryGoodOpenSource/very_good_workflows
