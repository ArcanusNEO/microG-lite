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
$curl -o "$MODPATH/system/priv-app/microGServicesCore/base.apk" -kL "https://github.com/microg/GmsCore/releases/download/v0.3.9.250932/com.google.android.gms-250932018.apk"
echo " |                                                    | "
echo " |    downloading microG Services Framework Proxy...  | "
mkdir -p "$MODPATH/system/priv-app/microGServicesFrameworkProxy"
$curl -o "$MODPATH/system/priv-app/microGServicesFrameworkProxy/base.apk" -kL "https://github.com/microg/GsfProxy/releases/download/v0.1.0/GsfProxy.apk"
echo " |                                                    | "
echo " |    Enjoy!                                          | "
echo " |____________________________________________________| "
echo
