#!/bin/bash
# Build a universal LangSwitch app and package it as a drag-and-drop DMG.
# Usage: scripts/create-dmg.sh [version]

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VERSION="${1:-$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "$ROOT_DIR/build/release/Build/Products/Release/LangSwitch.app/Contents/Info.plist" 2>/dev/null || true)}"
VERSION="${VERSION:-1.4.2}"
PRODUCT_NAME="LangSwitch"
VOLUME_NAME="${PRODUCT_NAME} ${VERSION}"
BUILD_ROOT="$ROOT_DIR/build/release"
APP_PATH="$BUILD_ROOT/Build/Products/Release/${PRODUCT_NAME}.app"
DIST_DIR="$ROOT_DIR/dist"
DMG_PATH="$DIST_DIR/${PRODUCT_NAME}-${VERSION}-universal.dmg"
STAGING_DIR="$(mktemp -d "${TMPDIR:-/tmp}/langswitch-dmg.XXXXXX")"

cleanup() {
    rm -rf "$STAGING_DIR"
}
trap cleanup EXIT

rm -rf "$BUILD_ROOT"
mkdir -p "$DIST_DIR"

xcodebuild \
    -project "$ROOT_DIR/LangSwitch.xcodeproj" \
    -scheme "$PRODUCT_NAME" \
    -configuration Release \
    -derivedDataPath "$BUILD_ROOT" \
    ARCHS="arm64 x86_64" \
    ONLY_ACTIVE_ARCH=NO \
    CODE_SIGNING_ALLOWED=NO \
    clean build

if [[ ! -d "$APP_PATH" ]]; then
    echo "Build succeeded but ${APP_PATH} was not created." >&2
    exit 1
fi

# This verifies that the DMG works on both Apple Silicon and Intel Macs.
ARCHITECTURES="$(lipo -archs "$APP_PATH/Contents/MacOS/$PRODUCT_NAME")"
if [[ "$ARCHITECTURES" != *"arm64"* || "$ARCHITECTURES" != *"x86_64"* ]]; then
    echo "Expected universal app (arm64 + x86_64), got: ${ARCHITECTURES}" >&2
    exit 1
fi

# Ad-hoc signing preserves a valid local signature after copying the app into the image.
# Developer ID signing and Apple notarization require a configured Apple Developer certificate.
codesign --force --deep --sign - "$APP_PATH"
codesign --verify --deep --strict --verbose=2 "$APP_PATH"

ditto "$APP_PATH" "$STAGING_DIR/${PRODUCT_NAME}.app"
ln -s /Applications "$STAGING_DIR/Applications"

rm -f "$DMG_PATH"
hdiutil create \
    -volname "$VOLUME_NAME" \
    -srcfolder "$STAGING_DIR" \
    -ov \
    -format UDZO \
    "$DMG_PATH"

hdiutil imageinfo "$DMG_PATH" >/dev/null
DMG_FILENAME="$(basename "$DMG_PATH")"
(
    cd "$DIST_DIR"
    shasum -a 256 "$DMG_FILENAME" > "${DMG_FILENAME}.sha256"
)

printf '\nCreated installer:\n%s\n\nSHA-256:\n' "$DMG_PATH"
cat "${DMG_PATH}.sha256"
