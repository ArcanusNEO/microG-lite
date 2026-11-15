# microG-lite

**Summary**: This repo contains microG build assets ([source](https://microg.org/download.html)). No APK is bundled or downloaded by this module: the microG apps you installed yourself are copied into `/system/priv-app` by the module's **Action**.

module structure:
#### /system/priv-app (populated by the module's **Action**):
- microG Services Core (microG)
- microG Service Framework (proxy for microG)

#### /system/framework:
- maps.jar

#### /system/etc:
- permissions configuration

## Why you may want to use it
this module helps new user to start using microG, and also helps experienced user in the setup of microG mixing Google and Non Google services in order to have the most standard user experience avoiding boring "google service background process"

**Note**:
ensure the rom you are running allow "signature spoofing"

supported feature [list](https://github.com/microg/android_packages_apps_GmsCore/wiki/Implementation-Status)

## Installation
1. install the microG apps as normal user apps, in whatever version you like:
   - microG Services Core (`com.google.android.gms`, [releases](https://github.com/microg/GmsCore/releases))
   - microG Services Framework Proxy (`com.google.android.gsf`, [releases](https://github.com/microg/GsfProxy/releases))
2. flash this module in Magisk
3. tap the module's **Action** button in the Magisk app: it copies the installed APKs into `/system/priv-app` (systemless) and refreshes their `privapp-permissions` whitelist from the permissions the installed APKs actually declare. Apps that are not installed are simply skipped
4. system reboot then:
   - configure microG
   - add your google account
   - Enjoy!

**Note**: run the Action again after updating the microG apps or this module (a module update replaces the module folder, including the systemized copies)

## Credits
- **microG project** for their awesome work.
