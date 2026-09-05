# Addendum — Second trusted device

Mechanism for implementers. FR IDs refer to `prd.md`.

## Core

Presence input becomes a set of RSSI samples keyed by device id. Band per device, then OR: any near → near; else away if at least one configured.

Unknown: no samples yet for a device does not count as near. If all configured devices have never sampled, band unknown — do not lock.

## Tests

One device regression, OR near, both away, duplicate id rejected. Inject samples; no BLE in unit tests.
