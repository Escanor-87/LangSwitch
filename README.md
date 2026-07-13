# LangSwitch
LangSwitch is a super-simple macOS app that switches your keyboard languages (input sources) one by one by pressing the Fn/🌐 button. It aims to address the annoyance caused by the default macOS function, which includes a popup and a delay between source changes. The sole purpose of this app is to immediately change the language without any popups or delays.

# P.S.
MacOS Sonoma has improved language switching. They removed the popup, and switching is faster. But still it can be glitchy and works with bugs from time to time. So this app can still be relevant)

![langswitch-example](https://github.com/Nikeev/LangSwitch/assets/1555773/2850313a-f70d-4f76-b629-3d5798754f86)

**How to use:**
- Download and install the app from the releases page.
- Disable the default macOS 🌐 button click action in Keyboard settings.
- Run the LangSwitch app.
- A settings window opens at startup. It lets you choose whether LangSwitch starts at login, appears in the menu bar, and appears in the Dock.

## Install from a DMG

1. Download the `.dmg` from the [latest release](https://github.com/Escanor-87/LangSwitch/releases/latest).
2. Open it and drag `LangSwitch.app` onto the `Applications` folder shortcut.
3. Eject the mounted LangSwitch disk image and open LangSwitch from Applications.

The release installer is universal (`arm64` and `x86_64`) and works on Apple Silicon and Intel Macs.

## Create a release DMG

On a Mac with full Xcode installed:

```bash
scripts/create-dmg.sh 1.4.2
```

The command creates `dist/LangSwitch-1.4.2-universal.dmg` plus its SHA-256 checksum. The app is ad-hoc signed; Developer ID signing and Apple notarization require an Apple Developer certificate.
