# WalkAway

WalkAway is a macOS menu bar app that locks the screen when you walk away with your Apple Watch or iPhone. It does not sleep the Mac. Jobs keep running.

macOS can unlock with Apple Watch. It does not lock when you leave. WalkAway fills that gap.

## Requirements

- macOS 13 Ventura or later
- A trusted BLE device (Apple Watch is the reliable pick)

## Status

Foundation increment. Core lock policy is implemented and tested. BLE device picker and Preferences ship in the remaining stories.

## Development

```
swift test
swift run WalkAway
```

Product work follows [docs/pdlc.md](docs/pdlc.md).
