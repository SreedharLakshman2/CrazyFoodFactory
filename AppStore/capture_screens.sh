#!/bin/zsh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
APP="$ROOT/.derivedData/Build/Products/Debug-iphonesimulator/CrazyFoodFactory.app"
BUNDLE="com.sreedhar.CrazyFoodFactory"

IPHONE_UDID="${IPHONE_UDID:-BEEA89A9-8CD4-44BE-B0CB-00CFE8B4BC7D}"
IPAD_UDID="${IPAD_UDID:-86D0A7D0-58FA-48E7-83D9-3A0A8C0B35FC}"

lcd_display() {
  local udid="$1"
  local info
  info="$(xcrun simctl io "$udid" enumerate 2>/dev/null || true)"
  python3 - "$info" <<'PY'
import re, sys
text = sys.argv[1]
ports = re.split(r"\nPort:\n", text)
best = None
best_area = -1
for port in ports:
    cls = re.search(r"Class:\s+(\S+)", port)
    uuid = re.search(r"UUID:\s+([0-9A-F-]{36})", port, re.I)
    width = re.search(r"Default width:\s+(\d+)", port)
    height = re.search(r"Default height:\s+(\d+)", port)
    if not uuid or not cls or cls.group(1) != "Display":
        continue
    w = int(width.group(1)) if width else 0
    h = int(height.group(1)) if height else 0
    if min(w, h) <= 480:
        continue
    area = w * h
    if area > best_area:
        best_area = area
        best = uuid.group(1)
print(best or "")
PY
}

boot_and_install() {
  local udid="$1"
  xcrun simctl boot "$udid" 2>/dev/null || true
  xcrun simctl bootstatus "$udid" -b
  xcrun simctl install "$udid" "$APP"
}

capture_set() {
  local udid="$1"
  local dest="$2"
  mkdir -p "$dest"
  local display
  display="$(lcd_display "$udid")"
  echo "UDID=$udid display=${display:-internal}"

  shot() {
    local name="$1"; shift
    xcrun simctl terminate "$udid" "$BUNDLE" >/dev/null 2>&1 || true
    sleep 0.35
    xcrun simctl launch "$udid" "$BUNDLE" "$@" >/dev/null
    sleep 3.4
    if [[ -n "$display" ]]; then
      xcrun simctl io "$udid" screenshot --display="$display" "$dest/${name}.png"
    else
      xcrun simctl io "$udid" screenshot --display=internal "$dest/${name}.png" \
        || xcrun simctl io "$udid" screenshot "$dest/${name}.png"
    fi
    echo "saved $dest/${name}.png"
  }

  shot 01-home -screen home
  shot 02-foods -screen foods
  shot 03-pizza -screen play -food pizza
  shot 04-dosa -screen play -food dosa
  shot 05-school -screen school
  shot 06-result -screen result -food pizza
  shot 07-howto -screen howto
}

if [[ "${SKIP_BUILD:-0}" != "1" ]]; then
  echo "Building Kido Chef for simulator..."
  xcodebuild -project "$ROOT/CrazyFoodFactory.xcodeproj" \
    -scheme CrazyFoodFactory \
    -destination "generic/platform=iOS Simulator" \
    -derivedDataPath "$ROOT/.derivedData" \
    -configuration Debug \
    CODE_SIGNING_ALLOWED=NO \
    build >/tmp/kido-capture-build.log
  rg "BUILD SUCCEEDED|BUILD FAILED|error:" /tmp/kido-capture-build.log || true
fi

boot_and_install "$IPHONE_UDID"
capture_set "$IPHONE_UDID" "$ROOT/AppStore/raw/iphone-69"

boot_and_install "$IPAD_UDID"
capture_set "$IPAD_UDID" "$ROOT/AppStore/raw/ipad-13"

echo "RAW_CAPTURE_DONE"
