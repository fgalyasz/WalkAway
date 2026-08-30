# WalkAway

WalkAway is a macOS menu bar app that locks the screen when you walk away with your Apple Watch or iPhone. It does not sleep the Mac. Jobs keep running.

macOS can unlock with Apple Watch. It does not lock when you leave. WalkAway fills that gap.

## Requirements

- macOS 13 Ventura or later
- A trusted BLE device (Apple Watch is the reliable pick)

## Status

Foundation increment shipped. Pick a Watch in Preferences, leave Armed on, walk away. The screen locks; encodes keep running.

## Development

```
swift test
swift run WalkAway
./build_dmg.sh
```

Product work follows [docs/pdlc.md](docs/pdlc.md).
