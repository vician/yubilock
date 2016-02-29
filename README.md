# yubilock
_Lock and unlock your computer via yubikey._

This script will add a rule to udev which run script `yubilock.sh` when a yubikey is insterted or removed from USB port.

Usage:
* run only once for init when your yubikey is in your USB port.
```
./init.sh
```

Issues:
* Only i3 supported.
* No check if yubikey is inserted in USB port.
* Hard-coded vendor and model ID.
