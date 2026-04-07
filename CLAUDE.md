# BDO Companion

macOS menu bar app (SwiftUI MenuBarExtra) for Black Desert Online world boss timers.

## Stack

- Swift 6, macOS 14+, SwiftUI
- XcodeGen (`project.yml`) for project generation
- Homebrew cask via `delcatta/tap`
- CI: GitHub Actions, releases triggered by `v*` tags

## Architecture

- `BossTimerEngine`: `@MainActor @Observable`, owns spawn state and 1s tick timer
- `NotificationService`: schedules local notifications, singleton
- `BossSchedule`: static spawn data per region, times stored in region-local timezone (PT for NA, CET for EU)
- `MenuBarExtra` with `.window` style, string-based label init

## Gotchas

- `Calendar.firstWeekday` must be set to `1` (Sunday) when mapping `DayOfWeek` raw values. European locales default to Monday and break week calculations.
- NA times are in PT (America/Los_Angeles), EU in CET (Europe/Berlin). Early morning CEST slots map to previous day's evening in PT.
- Locally-built unsigned apps may not trigger the notification permission prompt. Users must enable manually in System Settings.
- `@preconcurrency import UserNotifications` silences Sendable warnings in Swift 6.
- `deinit` can't access `@MainActor` properties.

## Schedule data status

- NA: verified against garmoth.com and Pearl Abyss wiki (April 2026)
- EU/SEA/SA: placeholders (mirror NA), need real data
- Black Shadow: excluded (inconsistent across servers)

## Build & run

```
xcodegen generate
xcodebuild -scheme BDOCompanion -configuration Debug build
```

## Release

Push a `v*` tag to trigger the GitHub Actions release workflow. Update the brew cask with `brew reinstall --cask bdo-companion`.
