#!/bin/bash

if [ $ARCH = "arm" ]; then
  # 32-bit
  curl=$MODPATH/tools/curl/arm64eabi-v7a/curl
else
  # 64-bit
  curl=$MODPATH/tools/curl/arm64-v8a/curl
fi
chmod 777 $curl

echo "  ____________________________________________________  "
echo " |                                                    | "
echo " |    downloading microG Services Core...             | "
mkdir -p "$MODPATH/system/priv-app/microGServicesCore"
$curl -o "$MODPATH/system/priv-app/microGServicesCore/base.apk" -k "https://microg.org/fdroid/repo/com.google.android.gms-250932014.apk"
echo " |                                                    | "
echo " |    downloading microG Services Framework Proxy...  | "
mkdir -p "$MODPATH/system/priv-app/microGServicesFrameworkProxy"
$curl -o "$MODPATH/system/priv-app/microGServicesFrameworkProxy/base.apk" -k "https://microg.org/fdroid/repo/com.google.android.gsf-8.apk"
echo " |                                                    | "
echo " |    Enjoy!                                          | "
echo " |____________________________________________________| "
echo
