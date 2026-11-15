#!/system/bin/sh

cd "$(dirname "$0")" 2>/dev/null
MODDIR=$(pwd)

APPS="
com.google.android.gms:microGServicesCore
com.google.android.gsf:microGServicesFrameworkProxy
"

FAILED=false
COPIED=0

requested_perms() {
  pm dump "$1" 2>/dev/null | awk '
    /requested permissions:/ { inblock = 1; next }
    inblock {
      if ($0 ~ /^ +[A-Za-z0-9_.$]+ *$/) { print $1; next }
      inblock = 0
    }
  ' | sort -u
}

update_perms() {
  PKG=$1
  PERMS=$(requested_perms "$PKG")
  TARGET="$MODDIR/system/etc/permissions/privapp-permissions-$PKG.xml"
  STAGE="$MODDIR/.stage/privapp-permissions-$PKG.xml"

  if [ -z "$PERMS" ]; then
    echo "- $PKG: no manifest permissions found, keeping existing whitelist"
    return 0
  fi

  mkdir -p "$MODDIR/.stage" "$MODDIR/system/etc/permissions"
  {
    echo "<permissions>"
    echo "  <privapp-permissions package=\"$PKG\">"
    for PERM in $PERMS; do
      echo "    <permission name=\"$PERM\" />"
    done
    echo "  </privapp-permissions>"
    echo "</permissions>"
  } > "$STAGE" || {
    echo "! $PKG: failed to generate privapp-permissions"
    rm -f "$STAGE"
    FAILED=true
    return 0
  }

  chown 0:0 "$STAGE"
  chmod 644 "$STAGE"
  chcon u:object_r:system_file:s0 "$STAGE" 2>/dev/null

  if ! mv -f "$STAGE" "$TARGET"; then
    echo "! $PKG: failed to finalize privapp-permissions"
    rm -f "$STAGE"
    FAILED=true
    return 0
  fi

  set -- $PERMS
  echo "- $PKG: privapp-permissions updated ($# permissions)"
}

systemize() {
  PKG=$1
  DIR=$2
  TARGET="$MODDIR/system/priv-app/$DIR"
  STAGE="$MODDIR/.stage/$DIR"

  ALL_PATHS=$(pm path "$PKG" 2>/dev/null | grep '^package:' | sed 's/^package://')

  if [ -z "$ALL_PATHS" ]; then
    echo "- $PKG: not installed, skipping"
    return
  fi

  APK_PATHS=$(printf '%s\n' "$ALL_PATHS" | grep '^/data/app/')
  if [ -z "$APK_PATHS" ]; then
    echo "- $PKG: already installed as a system app, skipping"
    return
  fi

  echo "- $PKG: copying to /system/priv-app/$DIR"

  rm -rf "$STAGE"
  mkdir -p "$STAGE" "$MODDIR/system/priv-app" || {
    echo "! $PKG: cannot create staging directory"
    FAILED=true
    return
  }

  for APK in $APK_PATHS; do
    if ! cp -f "$APK" "$STAGE/"; then
      echo "! $PKG: failed to copy $APK"
      rm -rf "$STAGE"
      FAILED=true
      return
    fi
  done

  chown 0:0 "$STAGE"
  chmod 755 "$STAGE"
  chcon u:object_r:system_file:s0 "$STAGE" 2>/dev/null
  for APK in "$STAGE"/*; do
    [ -f "$APK" ] || continue
    chown 0:0 "$APK"
    chmod 644 "$APK"
    chcon u:object_r:system_file:s0 "$APK" 2>/dev/null
  done

  rm -rf "$TARGET"
  if ! mv -f "$STAGE" "$TARGET"; then
    echo "! $PKG: failed to finalize /system/priv-app/$DIR"
    rm -rf "$STAGE"
    FAILED=true
    return
  fi

  COPIED=$((COPIED + 1))
  echo "- $PKG: done"
  update_perms "$PKG"
}

echo "- microG-lite: systemizing user-installed microG apps"
echo

for APP in $APPS; do
  systemize "${APP%%:*}" "${APP##*:}"
done

rmdir "$MODDIR/.stage" 2>/dev/null

echo
if $FAILED; then
  echo "! One or more apps could not be copied"
  exit 1
fi

if [ "$COPIED" -gt 0 ]; then
  echo "- All done, reboot to apply the changes"
else
  echo "- Nothing copied, nothing to do"
fi
