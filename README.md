# Happ Sky Background

Rootless Theos tweak for Happ iOS (`su.ffg.happ`).

Target tested/design target:
- iPhone XS
- iOS 16.7.16
- Dopamine rootless
- Happ 5.9.0

The supplied photo is bundled as `HappSkyBackground.jpg` and is displayed with `aspectFill` behind the root view.

## Build

Requires Theos with rootless support.

```sh
make clean package FINALPACKAGE=1 THEOS_PACKAGE_SCHEME=rootless
```

The resulting `.deb` is placed in `packages/`.

## Install

Copy the `.deb` to the jailbroken phone and install it with Sileo/Zebra, then respring or restart Happ.

## Important

This is a best-effort generic UIKit hook. Happ 5.9.0 uses implementation details that are not publicly documented, so the tweak may need one small adjustment if the app's root view is opaque or rebuilt dynamically.

If Happ enters Safe Mode, disable/remove this tweak from Sileo and restart the app.
