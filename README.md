# BDO Companion

A lightweight macOS menu bar app that tracks Black Desert Online world boss spawn times with live countdowns and native notifications.

![macOS 14+](https://img.shields.io/badge/macOS-14%2B-blue)
![Swift 6](https://img.shields.io/badge/Swift-6-orange)

## Features

- Live countdown in the menu bar (e.g. `Kzarka · 2h 15m`)
- Upcoming boss list with color-coded urgency
- Native macOS notifications before spawns
- Configurable alert timing (5/10/15/30 min)
- Per-boss tracking toggles
- NA region schedule (EU/SEA/SA coming soon)
- Launch at login support

## Install

### Homebrew

```bash
brew tap delCatta/tap
brew install --cask bdo-companion
```

### Manual

Download the latest `.zip` from [Releases](https://github.com/delCatta/mac-bdo-companion/releases), unzip, and drag to Applications.

> Since the app isn't notarized, right-click > Open on first launch to bypass Gatekeeper.

## Build from source

Requires Xcode 16+ and [XcodeGen](https://github.com/yonaskolb/XcodeGen).

```bash
brew install xcodegen
xcodegen generate
open BDOCompanion.xcodeproj
```

Build and run (Cmd+R) in Xcode.

## Schedule data

Boss spawn times are sourced from [garmoth.com](https://garmoth.com/boss-timer) and the [official Pearl Abyss wiki](https://www.naeu.playblackdesert.com/en-US/Wiki?wikiNo=83). Times are stored in PT and converted to your local timezone automatically.

## License

MIT
