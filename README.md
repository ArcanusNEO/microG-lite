# microG-lite

**Summary**: This repo contains microG build assets ([source](https://microg.org/download.html)), it is based on the latest release "com.google.android.gms **0.3.0.233515**".

module structure:
#### /system/priv-app:
- microG Services Core (microG)
- microG Service Framework (proxy for microG)

#### /system/framework:
- maps.jar

#### /system/etc:
- permissions configuration

## Why you may want to use it
this module helps new user to start using microG, and also helps experienced user in the setup of microG
mixing Google and Non Google services in order to have the most standard user experience avoiding boring "google service background process"

**Note**:
ensure the rom you are running allow "signature spoofing"

supported feature [list](https://github.com/microg/android_packages_apps_GmsCore/wiki/Implementation-Status)

## Installation
once flashed the module, system reboot then:
- configure microG
- add your google account
- Enjoy!

## Credits
- **microG project** for their awesome work.
